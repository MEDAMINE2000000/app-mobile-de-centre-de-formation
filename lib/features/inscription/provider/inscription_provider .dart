import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:three_alfa_mobile_app/features/inscription/model/inscription_model.dart';

class InscriptionProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<InscriptionModel> myInscriptions = [];

  bool isLoading = false;
  bool isSubmitting = false;

  String? errorMessage;
  String? successMessage;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
  _inscriptionsSubscription;

  @override
  void dispose() {
    _inscriptionsSubscription?.cancel();
    super.dispose();
  }

  // ============================================================
  // SUBMIT INSCRIPTION REQUEST
  // ============================================================

  Future<bool> submitInscription({
    required String formationId,
    required String formationTitle,
    required String formationImageUrl,
    required String formationCategoryName,
  }) async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      errorMessage = 'Vous devez être connecté pour vous inscrire.';
      notifyListeners();
      return false;
    }

    isSubmitting = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    try {
      // Check if user is already registered for this formation with pending or confirmed
      final existing = await _db
          .collection('inscriptions')
          .where('userId', isEqualTo: currentUser.uid)
          .where('formationId', isEqualTo: formationId)
          .where('status', whereIn: ['pending', 'confirmed'])
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) {
        errorMessage = 'Vous êtes déjà inscrit(e) à cette formation.';
        return false;
      }

      // Create inscription request
      await _db.collection('inscriptions').add({
        'userId': currentUser.uid,
        'formationId': formationId,
        'formationTitle': formationTitle,
        'formationImageUrl': formationImageUrl,
        'formationCategoryName': formationCategoryName,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      successMessage =
          'Votre demande d\'inscription a été envoyée au centre. '
          'Vous serez notifié après confirmation.';

      return true;
    } on FirebaseException catch (e) {
      errorMessage = 'Erreur lors de l\'envoi de la demande (${e.code}).';
      return false;
    } catch (e) {
      errorMessage = 'Une erreur inattendue est survenue.';
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  // ============================================================
  // LOAD MY INSCRIPTIONS WITH REALTIME LISTENER
  // ============================================================

  Future<void> loadMyInscriptions() async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      errorMessage = 'Aucun utilisateur connecté.';
      myInscriptions = [];
      notifyListeners();
      return;
    }

    _inscriptionsSubscription?.cancel();
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    _inscriptionsSubscription = _db
        .collection('inscriptions')
        .where('userId', isEqualTo: currentUser.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            myInscriptions = snapshot.docs
                .map(
                  (doc) => InscriptionModel.fromFirestore(doc.data(), doc.id),
                )
                .toList();
            isLoading = false;
            notifyListeners();
          },
          onError: (error) {
            if (error is FirebaseException) {
              errorMessage = 'Erreur lors du chargement (${error.code}).';
            } else {
              errorMessage = 'Une erreur inattendue est survenue.';
            }
            isLoading = false;
            notifyListeners();
          },
        );
  }

  // ============================================================
  // PENDING INSCRIPTIONS
  // ============================================================

  List<InscriptionModel> get pendingInscriptions {
    return myInscriptions
        .where((i) => i.status == InscriptionStatus.pending)
        .toList();
  }

  // ============================================================
  // CONFIRMED INSCRIPTIONS
  // ============================================================

  List<InscriptionModel> get confirmedInscriptions {
    return myInscriptions
        .where((i) => i.status == InscriptionStatus.confirmed)
        .toList();
  }

  // ============================================================
  // REJECTED INSCRIPTIONS
  // ============================================================

  List<InscriptionModel> get rejectedInscriptions {
    return myInscriptions
        .where((i) => i.status == InscriptionStatus.rejected)
        .toList();
  }

  // ============================================================
  // CANCEL PENDING INSCRIPTION
  // ============================================================

  Future<bool> cancelInscription(String inscriptionId) async {
    try {
      await _db.collection('inscriptions').doc(inscriptionId).delete();

      myInscriptions.removeWhere((i) => i.id == inscriptionId);

      successMessage = 'Demande annulée.';
      errorMessage = null;

      notifyListeners();

      return true;
    } on FirebaseException catch (e) {
      errorMessage = 'Erreur lors de l\'annulation (${e.code}).';
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = 'Une erreur inattendue est survenue.';
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // CLEAR MESSAGES
  // ============================================================

  void clearMessages() {
    errorMessage = null;
    successMessage = null;

    notifyListeners();
  }

  // ============================================================
  // RESET PROVIDER
  // ============================================================

  void reset() {
    _inscriptionsSubscription?.cancel();
    myInscriptions = [];

    isLoading = false;
    isSubmitting = false;

    errorMessage = null;
    successMessage = null;

    notifyListeners();
  }
}
