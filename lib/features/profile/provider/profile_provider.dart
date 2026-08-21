import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:three_alfa_mobile_app/features/profile/model/profile_model.dart';

class ProfileProvider extends ChangeNotifier {
<<<<<<< HEAD
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;
  final FirebaseStorage _storage;
  final ImagePicker _picker;

  ProfileProvider({
    FirebaseFirestore? db,
    FirebaseAuth? auth,
    FirebaseStorage? storage,
    ImagePicker? picker,
  })  : _db = db ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _storage = storage ?? FirebaseStorage.instance,
        _picker = picker ?? ImagePicker();
=======
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1

  ProfileModel? profile;

  bool isLoading = false;
  bool isSaving = false;
  bool isUploadingPhoto =
      false; // separate flag so the avatar shows its own spinner
  String? errorMessage;
  String? successMessage;

  // ────────────────────────────────────────────────────
  // LOAD PROFILE
  // ────────────────────────────────────────────────────

  Future<void> loadProfile() async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      errorMessage = 'Aucun utilisateur connecté.';
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();
<<<<<<< HEAD
    final stopwatch = Stopwatch()..start();
=======
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1

    try {
      final doc = await _db.collection('users').doc(currentUser.uid).get();

      if (!doc.exists || doc.data() == null) {
        errorMessage = 'Profil introuvable.';
        return;
      }

      profile = ProfileModel.fromFirestore(doc.data()!, currentUser.uid);
    } on FirebaseException catch (e) {
      errorMessage = 'Erreur lors du chargement du profil (${e.code}).';
    } catch (e) {
      errorMessage = 'Une erreur inattendue est survenue.';
    } finally {
      isLoading = false;
      notifyListeners();
<<<<<<< HEAD
      stopwatch.stop();
      final ms = stopwatch.elapsedMilliseconds;
      final s = ms / 1000;
      debugPrint('Temps de chargement : $ms ms (${s.toStringAsFixed(2)} s)');
=======
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
    }
  }

  // ────────────────────────────────────────────────────
  // UPDATE PROFILE (text fields)
  // ────────────────────────────────────────────────────

  Future<bool> updateProfile({
    required String nom,
    required String prenom,
    required String telephone,
    required String dateNaissance,
  }) async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      errorMessage = 'Aucun utilisateur connecté.';
      notifyListeners();
      return false;
    }

    isSaving = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    try {
      final cleanNom = nom.trim();
      final cleanPrenom = prenom.trim();
      final cleanTel = telephone.trim();
      final cleanDate = dateNaissance.trim();

      // 1. Update Firestore document (source of truth for app profile data)
      await _db.collection('users').doc(currentUser.uid).update({
        'nom': cleanNom,
        'prenom': cleanPrenom,
        'telephone': cleanTel,
        'dateNaissance': cleanDate,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // 2. Keep Firebase Auth displayName in sync (only field Auth supports
      //    here — phone/birthdate aren't stored on the Auth user object).
      final newDisplayName = '$cleanPrenom $cleanNom'.trim();
      if (currentUser.displayName != newDisplayName) {
        await currentUser.updateDisplayName(newDisplayName);
        await currentUser.reload();
      }

      // 3. Update local state without needing a re-fetch
      profile = profile?.copyWith(
        nom: cleanNom,
        prenom: cleanPrenom,
        telephone: cleanTel,
        dateNaissance: cleanDate,
      );

      successMessage = 'Profil mis à jour avec succès.';
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = _mapAuthError(e.code);
      return false;
    } on FirebaseException catch (e) {
      errorMessage = 'Erreur lors de la mise à jour du profil (${e.code}).';
      return false;
    } catch (e) {
      errorMessage = 'Une erreur inattendue est survenue.';
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  // ────────────────────────────────────────────────────
  // PICK IMAGE (camera / gallery)
  // ────────────────────────────────────────────────────

  /// Opens the camera or gallery, then uploads the picked image.
  /// Returns true on success, false if cancelled or failed
  /// (in which case [errorMessage] is set — unless the user simply cancelled,
  /// in which case both messages stay null).
  Future<bool> pickAndUploadPhoto(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile == null) {
        // User cancelled the picker — not an error.
        return false;
      }

      return await uploadProfilePicture(File(pickedFile.path));
    } catch (e) {
      errorMessage = source == ImageSource.camera
          ? 'Impossible d\'accéder à la caméra.'
          : 'Impossible d\'accéder à la galerie.';
      notifyListeners();
      return false;
    }
  }

  // ────────────────────────────────────────────────────
  // UPLOAD PROFILE PICTURE (to Firebase Storage)
  // ────────────────────────────────────────────────────

  Future<bool> uploadProfilePicture(File imageFile) async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      errorMessage = 'Aucun utilisateur connecté.';
      notifyListeners();
      return false;
    }

    isUploadingPhoto = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    try {
      // 1. Upload to Firebase Storage under a per-user path.
      //    Fixed filename ('avatar.jpg') so re-uploads overwrite
      //    instead of accumulating orphaned files.
      final ref = _storage
          .ref()
          .child('profile_pictures')
          .child(currentUser.uid)
          .child('avatar.jpg');

      await ref.putFile(imageFile, SettableMetadata(contentType: 'image/jpeg'));

      final downloadUrl = await ref.getDownloadURL();

      // 2. Sync Firebase Auth (drives the AppBar avatar via user.photoURL)
      await currentUser.updatePhotoURL(downloadUrl);
      await currentUser.reload();

      // 3. Sync Firestore (source of truth for the app's own profile doc)
      await _db.collection('users').doc(currentUser.uid).update({
        'photoUrl': downloadUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // 4. Local state
      profile = profile?.copyWith(photoUrl: downloadUrl);

      successMessage = 'Photo de profil mise à jour.';
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = _mapAuthError(e.code);
      return false;
    } on FirebaseException catch (e) {
      errorMessage = 'Erreur lors du téléchargement de la photo (${e.code}).';
      return false;
    } catch (e) {
      errorMessage = 'Une erreur inattendue est survenue.';
      return false;
    } finally {
      isUploadingPhoto = false;
      notifyListeners();
    }
  }

  // ────────────────────────────────────────────────────
  // REMOVE PROFILE PICTURE
  // ────────────────────────────────────────────────────

  Future<bool> removeProfilePicture() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return false;

    isUploadingPhoto = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    try {
      // Best-effort delete from Storage — ignore if the file doesn't exist.
      try {
        await _storage
            .ref()
            .child('profile_pictures')
            .child(currentUser.uid)
            .child('avatar.jpg')
            .delete();
      } on FirebaseException catch (e) {
        if (e.code != 'object-not-found') rethrow;
      }

      await currentUser.updatePhotoURL(null);
      await currentUser.reload();

      await _db.collection('users').doc(currentUser.uid).update({
        'photoUrl': FieldValue.delete(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      profile = profile?.copyWith(photoUrl: '');
      successMessage = 'Photo de profil supprimée.';
      return true;
    } on FirebaseException catch (e) {
      errorMessage = 'Erreur lors de la suppression (${e.code}).';
      return false;
    } catch (e) {
      errorMessage = 'Une erreur inattendue est survenue.';
      return false;
    } finally {
      isUploadingPhoto = false;
      notifyListeners();
    }
  }

  // ────────────────────────────────────────────────────
  // HELPERS
  // ────────────────────────────────────────────────────

  void clearMessages() {
    errorMessage = null;
    successMessage = null;
    notifyListeners();
  }

  /// Call this after logout so the next user doesn't see stale data.
  void reset() {
    profile = null;
    isLoading = false;
    isSaving = false;
    isUploadingPhoto = false;
    errorMessage = null;
    successMessage = null;
  }

  String _mapAuthError(String code) {
    switch (code) {
      case 'requires-recent-login':
        return 'Veuillez vous reconnecter avant de modifier ces informations.';
      case 'network-request-failed':
        return 'Vérifiez votre connexion Internet.';
      default:
        return 'Erreur lors de la mise à jour. Veuillez réessayer.';
    }
  }
}
