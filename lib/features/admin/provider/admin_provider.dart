import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:three_alfa_mobile_app/features/admin/model/admin_stats_model.dart';
import 'package:three_alfa_mobile_app/features/formation/models/formation_model.dart';
import 'package:three_alfa_mobile_app/features/inscription/model/inscription_model.dart';

class AdminProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  AdminStats stats = AdminStats.empty();
  bool isLoadingStats = false;

  List<InscriptionModel> allInscriptions = [];
  bool isLoadingInscriptions = false;
  bool hasErrorInscriptions = false;

  // Track processing per inscription ID
  final Set<String> _processingIds = {};

  String? errorMessage;
  String? successMessage;

  bool isProcessingId(String id) => _processingIds.contains(id);

  // ────────────────────────────────────────────────────
  // DASHBOARD STATS
  // ────────────────────────────────────────────────────

  Future<void> loadStats() async {
    isLoadingStats = true;
    errorMessage = null;
    notifyListeners();

    try {
      final usersCount = await _db.collection('users').count().get();

      final pendingCount = await _db
          .collection('inscriptions')
          .where('status', isEqualTo: 'pending')
          .count()
          .get();

      final confirmedCount = await _db
          .collection('inscriptions')
          .where('status', isEqualTo: 'confirmed')
          .count()
          .get();

      stats = AdminStats(
        totalUsers: usersCount.count ?? 0,
        totalFormations: FormationMockData.formations.length,
        pendingInscriptions: pendingCount.count ?? 0,
        confirmedInscriptions: confirmedCount.count ?? 0,
      );
    } on FirebaseException catch (e) {
      errorMessage = 'Erreur lors du chargement des statistiques (${e.code}).';
    } catch (e) {
      errorMessage = 'Une erreur inattendue est survenue.';
    } finally {
      isLoadingStats = false;
      notifyListeners();
    }
  }

  // ────────────────────────────────────────────────────
  // MANAGE INSCRIPTIONS (with user details)
  // ────────────────────────────────────────────────────

  Future<void> loadAllInscriptions({String? statusFilter}) async {
    isLoadingInscriptions = true;
    hasErrorInscriptions = false;
    errorMessage = null;
    notifyListeners();

    try {
      final snapshot = await _db
          .collection('inscriptions')
          .orderBy('createdAt', descending: true)
          .get();

      // Collect unique user IDs to fetch user profiles
      final userIds = snapshot.docs
          .map((doc) => doc.data()['userId'] as String?)
          .where((uid) => uid != null && uid.isNotEmpty)
          .cast<String>()
          .toSet();

      // Fetch user documents in parallel
      final Map<String, Map<String, dynamic>> userMap = {};
      await Future.wait(
        userIds.map((uid) async {
          try {
            final userDoc = await _db.collection('users').doc(uid).get();
            if (userDoc.exists && userDoc.data() != null) {
              userMap[uid] = userDoc.data()!;
            }
          } catch (e) {
            print('Error fetching user document $uid: $e');
          }
        }),
      );

      // Build enriched InscriptionModel list
      allInscriptions = snapshot.docs.map((doc) {
        final data = doc.data();
        final uid = data['userId'] as String? ?? '';
        return InscriptionModel.fromFirestore(
          data,
          doc.id,
          userData: userMap[uid],
        );
      }).toList();

      hasErrorInscriptions = false;
    } on FirebaseException catch (e) {
      print('LOAD ALL INSCRIPTIONS FIRESTORE ERROR: ${e.code}');
      errorMessage = 'Erreur lors du chargement (${e.code}).';
      hasErrorInscriptions = true;
    } catch (e) {
      print('LOAD ALL INSCRIPTIONS UNKNOWN ERROR: $e');
      errorMessage = 'Une erreur inattendue est survenue.';
      hasErrorInscriptions = true;
    } finally {
      isLoadingInscriptions = false;
      notifyListeners();
    }
  }

  /// Get filtered inscriptions based on search query and status filter
  List<InscriptionModel> getFilteredInscriptions({
    String? searchQuery,
    String statusFilter = 'all',
  }) {
    return allInscriptions.where((item) {
      // Filter by status
      if (statusFilter != 'all') {
        if (statusFilter == 'confirmed' || statusFilter == 'accepted') {
          if (item.status != InscriptionStatus.confirmed) return false;
        } else if (statusFilter == 'pending') {
          if (item.status != InscriptionStatus.pending) return false;
        } else if (statusFilter == 'rejected') {
          if (item.status != InscriptionStatus.rejected) return false;
        }
      }

      // Filter by search query (user name, email, phone, formation title)
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.trim().toLowerCase();
        final name = item.userFullName.toLowerCase();
        final email = (item.userEmail ?? '').toLowerCase();
        final phone = (item.userTelephone ?? '').toLowerCase();
        final title = item.formationTitle.toLowerCase();
        final category = item.formationCategoryName.toLowerCase();

        final matches =
            name.contains(q) ||
            email.contains(q) ||
            phone.contains(q) ||
            title.contains(q) ||
            category.contains(q);

        if (!matches) return false;
      }

      return true;
    }).toList();
  }

  // ────────────────────────────────────────────────────
  // CONFIRM INSCRIPTION (ACCEPT)
  // ────────────────────────────────────────────────────

  Future<bool> confirmInscription(String inscriptionId) async {
    _processingIds.add(inscriptionId);
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    try {
      await _db.collection('inscriptions').doc(inscriptionId).update({
        'status': 'confirmed',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update card in place without removing it from the list
      final index = allInscriptions.indexWhere((i) => i.id == inscriptionId);
      if (index != -1) {
        allInscriptions[index] = allInscriptions[index].copyWith(
          status: InscriptionStatus.confirmed,
          updatedAt: DateTime.now(),
        );
      }

      successMessage = 'Inscription acceptée avec succès.';
      return true;
    } on FirebaseException catch (e) {
      errorMessage = 'Erreur lors de la confirmation (${e.code}).';
      return false;
    } catch (e) {
      errorMessage = 'Une erreur inattendue est survenue.';
      return false;
    } finally {
      _processingIds.remove(inscriptionId);
      notifyListeners();
    }
  }

  // ────────────────────────────────────────────────────
  // REJECT INSCRIPTION
  // ────────────────────────────────────────────────────

  Future<bool> rejectInscription(String inscriptionId, {String? note}) async {
    _processingIds.add(inscriptionId);
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    try {
      final updateData = <String, dynamic>{
        'status': 'rejected',
        'updatedAt': FieldValue.serverTimestamp(),
      };
      if (note != null && note.trim().isNotEmpty) {
        updateData['centreNote'] = note.trim();
      }

      await _db
          .collection('inscriptions')
          .doc(inscriptionId)
          .update(updateData);

      // Update card in place without removing it from the list
      final index = allInscriptions.indexWhere((i) => i.id == inscriptionId);
      if (index != -1) {
        allInscriptions[index] = allInscriptions[index].copyWith(
          status: InscriptionStatus.rejected,
          updatedAt: DateTime.now(),
          centreNote: note?.trim(),
        );
      }

      successMessage = 'Inscription refusée avec succès.';
      return true;
    } on FirebaseException catch (e) {
      errorMessage = 'Erreur lors du refus (${e.code}).';
      return false;
    } catch (e) {
      errorMessage = 'Une erreur inattendue est survenue.';
      return false;
    } finally {
      _processingIds.remove(inscriptionId);
      notifyListeners();
    }
  }

  void clearMessages() {
    errorMessage = null;
    successMessage = null;
    notifyListeners();
  }

  void reset() {
    stats = AdminStats.empty();
    allInscriptions = [];
    _processingIds.clear();
    isLoadingStats = false;
    isLoadingInscriptions = false;
    hasErrorInscriptions = false;
    errorMessage = null;
    successMessage = null;
    notifyListeners();
  }
}
