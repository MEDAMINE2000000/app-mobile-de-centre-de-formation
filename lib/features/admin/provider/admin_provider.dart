import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:three_alfa_mobile_app/features/admin/model/admin_stats_model.dart';
import 'package:three_alfa_mobile_app/features/admin/model/user_admin_model.dart';
import 'package:three_alfa_mobile_app/features/formation/models/formation_model.dart';
import 'package:three_alfa_mobile_app/features/inscription/model/inscription_model.dart';

class AdminProvider extends ChangeNotifier {
  final FirebaseFirestore _db;

  AdminProvider({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  AdminStats stats = AdminStats.empty();
  bool isLoadingStats = false;

  List<InscriptionModel> allInscriptions = [];
  bool isLoadingInscriptions = false;
  bool hasErrorInscriptions = false;

  List<UserAdminModel> allUsers = [];
  bool isLoadingUsers = false;
  bool hasErrorUsers = false;

  // Track processing per inscription ID
  final Set<String> _processingIds = {};

  String? errorMessage;
  String? successMessage;

  bool isProcessingId(String id) => _processingIds.contains(id);

  bool _isSuperAdmin(String uid) {
    try {
      final user = allUsers.firstWhere((u) => u.uid == uid);
      return user.isSuperAdmin;
    } catch (e) {
      return false;
    }
  }

  // ────────────────────────────────────────────────────
  // DASHBOARD STATS
  // ────────────────────────────────────────────────────

  StreamSubscription<QuerySnapshot>? _usersStatsSub;
  StreamSubscription<QuerySnapshot>? _inscriptionsStatsSub;

  List<QueryDocumentSnapshot>? _lastUsersStatsDocs;
  List<QueryDocumentSnapshot>? _lastInscriptionsStatsDocs;

  Future<void> loadStats() async {
    isLoadingStats = true;
    errorMessage = null;
    notifyListeners();

    _usersStatsSub?.cancel();
    _usersStatsSub = _db.collection('users').snapshots().listen((snapshot) {
      _lastUsersStatsDocs = snapshot.docs;
      _recalculateStats();
    }, onError: (e) {
      errorMessage = 'Erreur lors du chargement des statistiques utilisateurs.';
      isLoadingStats = false;
      notifyListeners();
    });

    _inscriptionsStatsSub?.cancel();
    _inscriptionsStatsSub = _db.collection('inscriptions').snapshots().listen((snapshot) {
      _lastInscriptionsStatsDocs = snapshot.docs;
      _recalculateStats();
    }, onError: (e) {
      errorMessage = 'Erreur lors du chargement des statistiques inscriptions.';
      isLoadingStats = false;
      notifyListeners();
    });
  }

  void _recalculateStats() {
    if (_lastUsersStatsDocs == null || _lastInscriptionsStatsDocs == null) {
      return; // attendons que les deux soient chargés
    }

    try {
      final int totalUsers = _lastUsersStatsDocs!.length;
      int totalAdmins = 0;
      int totalNormalUsers = 0;

      for (var doc in _lastUsersStatsDocs!) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null && data['role'] == 'admin') {
          totalAdmins++;
        } else {
          totalNormalUsers++;
        }
      }

      int pending = 0;
      int confirmed = 0;
      int rejected = 0;
      Map<String, int> participants = {};

      for (var doc in _lastInscriptionsStatsDocs!) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) continue;

        final status = data['status'] as String? ?? 'pending';
        if (status == 'pending') {
          pending++;
        } else if (status == 'confirmed') {
          confirmed++;
          final fId = data['formationId'] as String? ?? '';
          if (fId.isNotEmpty) {
            participants[fId] = (participants[fId] ?? 0) + 1;
          }
        } else if (status == 'rejected') {
          rejected++;
        }
      }

      Map<String, int> participantsPerTitle = {};
      String mostPopular = 'Aucune';
      int maxParticipants = 0;

      for (var entry in participants.entries) {
        final fId = entry.key;
        final count = entry.value;
        final formationList = FormationMockData.formations
            .where((f) => f.id == fId)
            .toList();
        final title = formationList.isNotEmpty
            ? formationList.first.title
            : 'Inconnue ($fId)';

        participantsPerTitle[title] =
            (participantsPerTitle[title] ?? 0) + count;
      }

      for (var entry in participantsPerTitle.entries) {
        if (entry.value > maxParticipants) {
          maxParticipants = entry.value;
          mostPopular = entry.key;
        }
      }

      stats = AdminStats(
        totalUsers: totalUsers,
        totalAdmins: totalAdmins,
        totalNormalUsers: totalNormalUsers,
        totalFormations: FormationMockData.formations.length,
        pendingInscriptions: pending,
        confirmedInscriptions: confirmed,
        rejectedInscriptions: rejected,
        participantsPerFormation: participantsPerTitle,
        mostPopularFormation: mostPopular,
      );
    } catch (e) {
      errorMessage = 'Erreur inattendue lors du calcul des statistiques.';
    } finally {
      isLoadingStats = false;
      notifyListeners();
    }
  }

  // ────────────────────────────────────────────────────
  // MANAGE USERS
  // ────────────────────────────────────────────────────

  Future<void> loadAllUsers() async {
    isLoadingUsers = true;
    hasErrorUsers = false;
    errorMessage = null;
    notifyListeners();

    try {
      final snapshot = await _db
          .collection('users')
          .orderBy('createdAt', descending: true)
          .get();

      allUsers = snapshot.docs.map((doc) {
        return UserAdminModel.fromFirestore(doc.data(), doc.id);
      }).toList();

      hasErrorUsers = false;
    } on FirebaseException catch (e) {
      print('LOAD ALL USERS FIRESTORE ERROR: ${e.code}');
      errorMessage = 'Erreur lors du chargement des utilisateurs (${e.code}).';
      hasErrorUsers = true;
    } catch (e) {
      print('LOAD ALL USERS UNKNOWN ERROR: $e');
      errorMessage = 'Une erreur inattendue est survenue.';
      hasErrorUsers = true;
    } finally {
      isLoadingUsers = false;
      notifyListeners();
    }
  }

  List<UserAdminModel> getFilteredUsers({
    String? searchQuery,
    String statusFilter = 'all',
  }) {
    return allUsers.where((user) {
      if (statusFilter != 'all') {
        if (statusFilter == 'admin' && user.role != 'admin') return false;
        if (statusFilter == 'user' && user.role != 'user') return false;
      }

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.trim().toLowerCase();
        final name = user.fullName.toLowerCase();
        final email = user.email.toLowerCase();
        final phone = user.telephone.toLowerCase();

        final matches =
            name.contains(q) || email.contains(q) || phone.contains(q);

        if (!matches) return false;
      }

      return true;
    }).toList();
  }

  // ────────────────────────────────────────────────────
  // UPDATE USER ROLE
  // ────────────────────────────────────────────────────

  Future<bool> updateUserRole(String uid, String newRole) async {
    if (_isSuperAdmin(uid)) {
      errorMessage =
          'Action interdite : Le rôle du Super Administrateur ne peut pas être modifié.';
      notifyListeners();
      return false;
    }

    _processingIds.add(uid);
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    try {
      await _db.collection('users').doc(uid).update({
        'role': newRole,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update local user if found
      final index = allUsers.indexWhere((u) => u.uid == uid);
      if (index != -1) {
        allUsers[index] = allUsers[index].copyWith(role: newRole);
      }

      successMessage = 'Rôle mis à jour avec succès.';
      return true;
    } on FirebaseException catch (e) {
      errorMessage = 'Erreur lors de la mise à jour (${e.code}).';
      return false;
    } catch (e) {
      errorMessage = 'Une erreur inattendue est survenue.';
      return false;
    } finally {
      _processingIds.remove(uid);
      notifyListeners();
    }
  }

  // ────────────────────────────────────────────────────
  // DELETE USER
  // ────────────────────────────────────────────────────

  Future<bool> deleteUser(String uid) async {
    if (_isSuperAdmin(uid)) {
      errorMessage =
          'Action interdite : Impossible de supprimer le Super Administrateur.';
      notifyListeners();
      return false;
    }

    _processingIds.add(uid);
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    try {
      // Delete the user document
      // Note: orphaned inscriptions are automatically filtered on next load
      // (they have no matching user in userMap and are skipped)
      await _db.collection('users').doc(uid).delete();

      // Update local lists immediately
      allUsers.removeWhere((u) => u.uid == uid);
      allInscriptions.removeWhere((i) => i.userId == uid);

      successMessage = 'Utilisateur supprimé avec succès.';
      return true;
    } on FirebaseException catch (e) {
      errorMessage = 'Erreur lors de la suppression (${e.code}).';
      return false;
    } catch (e) {
      errorMessage = 'Une erreur inattendue est survenue.';
      return false;
    } finally {
      _processingIds.remove(uid);
      notifyListeners();
    }
  }

  // ────────────────────────────────────────────────────
  // UPDATE USER DETAILS
  // ────────────────────────────────────────────────────

  Future<bool> updateUserDetails(String uid, Map<String, dynamic> data) async {
    if (_isSuperAdmin(uid)) {
      errorMessage =
          'Action interdite : Les informations du Super Administrateur sont protégées.';
      notifyListeners();
      return false;
    }

    _processingIds.add(uid);
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    try {
      final updateData = {...data, 'updatedAt': FieldValue.serverTimestamp()};

      await _db.collection('users').doc(uid).update(updateData);

      // Update local user list
      final index = allUsers.indexWhere((u) => u.uid == uid);
      if (index != -1) {
        final currentUser = allUsers[index];
        allUsers[index] = currentUser.copyWith(
          nom: data['nom'] ?? currentUser.nom,
          prenom: data['prenom'] ?? currentUser.prenom,
          telephone: data['telephone'] ?? currentUser.telephone,
          dateNaissance: data['dateNaissance'] ?? currentUser.dateNaissance,
          role: data['role'] ?? currentUser.role,
        );
      }

      successMessage = 'Informations mises à jour avec succès.';
      return true;
    } on FirebaseException catch (e) {
      errorMessage = 'Erreur lors de la mise à jour (${e.code}).';
      return false;
    } catch (e) {
      errorMessage = 'Une erreur inattendue est survenue.';
      return false;
    } finally {
      _processingIds.remove(uid);
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
      final validInscriptions = <InscriptionModel>[];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final status = data['status'] as String? ?? 'pending';

        // Local filter to avoid Firestore composite index requirement
        if (status != 'pending') {
          continue;
        }

        final uid = data['userId'] as String? ?? '';

        // Skip orphaned inscriptions (utilisateur inconnu)
        // We do not delete them here to avoid PERMISSION_DENIED errors.
        if (uid.isNotEmpty && !userMap.containsKey(uid)) {
          continue;
        }

        validInscriptions.add(
          InscriptionModel.fromFirestore(data, doc.id, userData: userMap[uid]),
        );
      }

      allInscriptions = validInscriptions;

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

      // Remove it from the local list so it disappears from the screen
      allInscriptions.removeWhere((i) => i.id == inscriptionId);

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
  // DELETE INSCRIPTION
  // ────────────────────────────────────────────────────

  Future<bool> deleteInscription(String inscriptionId) async {
    _processingIds.add(inscriptionId);
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    try {
      await _db.collection('inscriptions').doc(inscriptionId).delete();

      // Remove it from the local list
      allInscriptions.removeWhere((i) => i.id == inscriptionId);

      successMessage = 'Inscription supprimée avec succès.';
      return true;
    } on FirebaseException catch (e) {
      errorMessage = 'Erreur lors de la suppression (${e.code}).';
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

      // Remove it from the local list so it disappears from the screen immediately
      allInscriptions.removeWhere((i) => i.id == inscriptionId);

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
    _usersStatsSub?.cancel();
    _inscriptionsStatsSub?.cancel();
    _lastUsersStatsDocs = null;
    _lastInscriptionsStatsDocs = null;
    stats = AdminStats.empty();
    allInscriptions = [];
    allUsers = [];
    _processingIds.clear();
    isLoadingStats = false;
    isLoadingInscriptions = false;
    isLoadingUsers = false;
    hasErrorInscriptions = false;
    hasErrorUsers = false;
    errorMessage = null;
    successMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _usersStatsSub?.cancel();
    _inscriptionsStatsSub?.cancel();
    super.dispose();
  }
}
