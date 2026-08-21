import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:shared_preferences/shared_preferences.dart';
=======
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1

import 'package:three_alfa_mobile_app/features/inscription/model/inscription_model.dart';

class InscriptionProvider extends ChangeNotifier {
<<<<<<< HEAD
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  InscriptionProvider({
    FirebaseFirestore? db,
    FirebaseAuth? auth,
  })  : _db = db ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance {
    _loadHiddenIds();
  }
=======
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1

  List<InscriptionModel> myInscriptions = [];

  bool isLoading = false;
  bool isSubmitting = false;

  String? errorMessage;
  String? successMessage;

<<<<<<< HEAD
  List<String> hiddenInscriptionIds = [];

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      _inscriptionsSubscription;



  Future<void> _loadHiddenIds() async {
    final prefs = await SharedPreferences.getInstance();
    hiddenInscriptionIds = prefs.getStringList('hidden_inscriptions') ?? [];
    notifyListeners();
  }

  Future<void> _saveHiddenIds() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('hidden_inscriptions', hiddenInscriptionIds);
  }
=======
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
  _inscriptionsSubscription;
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1

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
<<<<<<< HEAD
      errorMessage = 'Vous devez etre connecte pour vous inscrire.';
=======
      errorMessage = 'Vous devez être connecté pour vous inscrire.';
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
      notifyListeners();
      return false;
    }

    isSubmitting = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    try {
<<<<<<< HEAD
=======
      // Check if user is already registered for this formation with pending or confirmed
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
      final existing = await _db
          .collection('inscriptions')
          .where('userId', isEqualTo: currentUser.uid)
          .where('formationId', isEqualTo: formationId)
          .where('status', whereIn: ['pending', 'confirmed'])
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) {
<<<<<<< HEAD
        errorMessage = 'Vous etes deja inscrit(e) a cette formation.';
        return false;
      }

=======
        errorMessage = 'Vous êtes déjà inscrit(e) à cette formation.';
        return false;
      }

      // Create inscription request
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
      await _db.collection('inscriptions').add({
        'userId': currentUser.uid,
        'formationId': formationId,
        'formationTitle': formationTitle,
        'formationImageUrl': formationImageUrl,
        'formationCategoryName': formationCategoryName,
        'status': 'pending',
<<<<<<< HEAD
        'decisionRead': false,
        'readAt': null,
=======
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

<<<<<<< HEAD
      successMessage = 'Votre demande a ete envoyee au centre.';
      return true;
    } on FirebaseException catch (e) {
      errorMessage = 'Erreur lors de l envoi (${e.code}).';
=======
      successMessage =
          'Votre demande d\'inscription a été envoyée au centre. '
          'Vous serez notifié après confirmation.';

      return true;
    } on FirebaseException catch (e) {
      errorMessage = 'Erreur lors de l\'envoi de la demande (${e.code}).';
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
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
<<<<<<< HEAD
      errorMessage = 'Aucun utilisateur connecte.';
=======
      errorMessage = 'Aucun utilisateur connecté.';
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
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
<<<<<<< HEAD
                .map((doc) => InscriptionModel.fromFirestore(doc.data(), doc.id))
=======
                .map(
                  (doc) => InscriptionModel.fromFirestore(doc.data(), doc.id),
                )
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
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
<<<<<<< HEAD
  // GETTERS
  // ============================================================


  // ============================================================
=======
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
  // PENDING INSCRIPTIONS
  // ============================================================

  List<InscriptionModel> get pendingInscriptions {
    return myInscriptions
<<<<<<< HEAD
        .where((i) => i.status == InscriptionStatus.pending && !hiddenInscriptionIds.contains(i.id))
=======
        .where((i) => i.status == InscriptionStatus.pending)
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
        .toList();
  }

  // ============================================================
  // CONFIRMED INSCRIPTIONS
  // ============================================================

  List<InscriptionModel> get confirmedInscriptions {
    return myInscriptions
<<<<<<< HEAD
        .where((i) => i.status == InscriptionStatus.confirmed && !hiddenInscriptionIds.contains(i.id))
=======
        .where((i) => i.status == InscriptionStatus.confirmed)
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
        .toList();
  }

  // ============================================================
  // REJECTED INSCRIPTIONS
  // ============================================================

  List<InscriptionModel> get rejectedInscriptions {
    return myInscriptions
<<<<<<< HEAD
        .where((i) => i.status == InscriptionStatus.rejected && !hiddenInscriptionIds.contains(i.id))
=======
        .where((i) => i.status == InscriptionStatus.rejected)
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
        .toList();
  }

  // ============================================================
<<<<<<< HEAD
  // DECISIONS TO READ (confirmed/rejected + decisionRead == false)
  // ============================================================

  List<InscriptionModel> get decisionsToRead {
    return myInscriptions.where((i) => i.hasUnreadDecision && !hiddenInscriptionIds.contains(i.id)).toList();
  }

  // ============================================================
  // HISTORY (pending + already read decisions)
  // ============================================================

  List<InscriptionModel> get historyInscriptions {
    return myInscriptions.where((i) => !i.hasUnreadDecision && !hiddenInscriptionIds.contains(i.id)).toList();
  }

  // ============================================================
  // MARK DECISION AS READ
  // ============================================================

  Future<bool> markDecisionAsRead(String inscriptionId) async {
    try {
      await _db.collection('inscriptions').doc(inscriptionId).update({
        'decisionRead': true,
        'readAt': FieldValue.serverTimestamp(),
      });

      // Optimistic local update — the realtime listener will also confirm this
      final index = myInscriptions.indexWhere((i) => i.id == inscriptionId);
      if (index != -1) {
        myInscriptions[index] = myInscriptions[index].copyWith(
          decisionRead: true,
          readAt: DateTime.now(),
        );
      }

      successMessage = 'Décision consultée avec succès.';
      errorMessage = null;
      notifyListeners();
      return true;
    } on FirebaseException catch (e) {
      errorMessage = 'Erreur lors de la mise à jour (${e.code}).';
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = 'Une erreur inattendue est survenue.';
      notifyListeners();
      return false;
    }
  }

  // ============================================================
  // CANCEL PENDING INSCRIPTION / DELETE INSCRIPTION
  // ============================================================

  Future<bool> cancelInscription(String inscriptionId) async {
    // 1. Force hide from frontend immediately
    if (!hiddenInscriptionIds.contains(inscriptionId)) {
      hiddenInscriptionIds.add(inscriptionId);
      _saveHiddenIds(); // Save persistently to SharedPreferences
      notifyListeners();
    }

    try {
      // 2. Attempt to delete from Firebase
=======
  // CANCEL PENDING INSCRIPTION
  // ============================================================

  Future<bool> cancelInscription(String inscriptionId) async {
    try {
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
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
<<<<<<< HEAD
    hiddenInscriptionIds = [];
=======
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1

    isLoading = false;
    isSubmitting = false;

    errorMessage = null;
    successMessage = null;

    notifyListeners();
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
