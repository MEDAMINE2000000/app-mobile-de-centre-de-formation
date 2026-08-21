import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  User? user;

  // ── Admin state ──
  bool isAdmin = false;

  // Router refresh — user identity changes
  final ValueNotifier<User?> routerRefresh = ValueNotifier<User?>(null);
  // Router refresh — admin status changes (toggled, not compared by value)
  final ValueNotifier<bool> adminRefresh = ValueNotifier<bool>(false);

  StreamSubscription<User?>? _authSubscription;

<<<<<<< HEAD
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthProvider({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance {
    _authSubscription = _auth.authStateChanges().listen((
=======
  AuthProvider() {
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
      firebaseUser,
    ) async {
      _setUser(firebaseUser);

      if (firebaseUser != null) {
        await refreshUser();
        await checkUserRole();
      } else {
        isAdmin = false;
        _bumpAdminRefresh();
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    routerRefresh.dispose();
    adminRefresh.dispose();
    super.dispose();
  }

  void _setUser(User? u) {
    user = u;
    routerRefresh.value = u;
    notifyListeners();
  }

  void _bumpAdminRefresh() {
    // ValueNotifier only notifies when the value actually changes,
    // so we toggle a dummy bool to force GoRouter to re-evaluate redirects.
    adminRefresh.value = !adminRefresh.value;
    notifyListeners();
  }

  // ────────────────────────────────────────────────────
  // FIRESTORE ROLE CHECK
  // ────────────────────────────────────────────────────

  /// Reads the user's role from their Firestore document at users/{uid}.
  /// Sets [isAdmin] to true only when the document's `role` field is 'admin'.
  Future<void> checkUserRole() async {
<<<<<<< HEAD
    final firebaseUser = _auth.currentUser;
=======
    final firebaseUser = FirebaseAuth.instance.currentUser;
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1

    if (firebaseUser == null) {
      isAdmin = false;
      _bumpAdminRefresh();
      return;
    }

<<<<<<< HEAD
    // Super Admin recognised immediately by email — no Firestore read needed
    if (firebaseUser.email == 'medhammi198@gmail.com') {
      isAdmin = true;
      _bumpAdminRefresh();
      return;
    }

    try {
      final doc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          .timeout(const Duration(seconds: 8));

      if (doc.exists) {
        final role = doc.data()?['role'] as String? ?? 'user';
        isAdmin = role == 'admin' || role == 'super_admin';
=======
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (doc.exists) {
        final data = doc.data();
        isAdmin = data?['role'] == 'admin';
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
      } else {
        isAdmin = false;
      }

      debugPrint('========== ADMIN CHECK ==========');
      debugPrint('UID: ${firebaseUser.uid}');
      debugPrint('EMAIL: ${firebaseUser.email}');
      debugPrint('ROLE: ${doc.data()?['role']}');
      debugPrint('IS ADMIN: $isAdmin');
      debugPrint('=================================');
    } catch (e) {
      debugPrint('CHECK USER ROLE ERROR: $e');
      isAdmin = false;
    }

    _bumpAdminRefresh();
  }

  // ────────────────────────────────────────────────────
  // LOGIN
  // ────────────────────────────────────────────────────

  Future<bool> login(String email, String password) async {
<<<<<<< HEAD
    final stopwatch = Stopwatch()..start();
=======
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
<<<<<<< HEAD
      // 10-second timeout to avoid infinite loading spinner
      final credential = await _auth
          .signInWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw FirebaseAuthException(
              code: 'network-request-failed',
              message: 'La connexion a pris trop de temps.',
            ),
          );

      _setUser(credential.user);

      // Run both in parallel to speed up the login process
      await Future.wait([refreshUser(), checkUserRole()]);

      stopwatch.stop();
      final ms = stopwatch.elapsedMilliseconds;
      final s = ms / 1000;
      debugPrint('Temps de connexion : $ms ms (${s.toStringAsFixed(2)} s)');
=======
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      _setUser(credential.user);

      await refreshUser();
      await checkUserRole();
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1

      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = _mapAuthError(e.code);
      return false;
    } catch (e) {
<<<<<<< HEAD
      debugPrint('LOGIN ERROR: $e');
      errorMessage = 'Une erreur inattendue est survenue. Réessayez.';
=======
      print('LOGIN ERROR: $e');
      errorMessage = 'Une erreur inattendue est survenue.';
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ────────────────────────────────────────────────────
  // REGISTER
  // ────────────────────────────────────────────────────

  Future<bool> register({
    required String nom,
    required String prenom,
    required String telephone,
    required String dateNaissance,
    required String email,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
<<<<<<< HEAD
      final credential = await _auth
=======
      final credential = await FirebaseAuth.instance
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      _setUser(credential.user);

      if (user == null) {
        errorMessage = 'Impossible de créer le compte.';
        return false;
      }

      final uid = user!.uid;

      // ── role: 'user' is ALWAYS forced here. Authorization is determined
      // by reading users/{uid}.role from Firestore. Security Rules reject
      // any client attempt to write role != 'user' on their own document. ──
<<<<<<< HEAD
      await _firestore.collection('users').doc(uid).set({
=======
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
        'uid': uid,
        'nom': nom.trim(),
        'prenom': prenom.trim(),
        'email': email.trim(),
        'telephone': telephone.trim(),
        'dateNaissance': dateNaissance.trim(),
        'role': 'user',
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('USER SAVED IN FIRESTORE');

      await user!.sendEmailVerification();

      print('VERIFICATION EMAIL SENT');

      return true;
    } on FirebaseAuthException catch (e) {
      print('REGISTER AUTH ERROR: ${e.code}');
      errorMessage = _mapAuthError(e.code);
      return false;
    } on FirebaseException catch (e) {
      print('FIRESTORE ERROR: ${e.code}');
      errorMessage = 'Erreur lors de l\'enregistrement des données.';
      return false;
    } catch (e) {
      print('REGISTER ERROR: $e');
      errorMessage = 'Une erreur inattendue est survenue.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ────────────────────────────────────────────────────
  // EMAIL VERIFICATION
  // ────────────────────────────────────────────────────

  Future<bool> sendEmailVerification() async {
    try {
<<<<<<< HEAD
      final currentUser = _auth.currentUser;
=======
      final currentUser = FirebaseAuth.instance.currentUser;
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1

      if (currentUser == null) {
        errorMessage = 'Aucun utilisateur connecté.';
        notifyListeners();
        return false;
      }

      await currentUser.sendEmailVerification();

      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = _mapAuthError(e.code);
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = 'Impossible d\'envoyer l\'email de vérification.';
      notifyListeners();
      return false;
    }
  }

  // ────────────────────────────────────────────────────
  // CHECK EMAIL VERIFICATION
  // ────────────────────────────────────────────────────

  Future<bool> checkEmailVerification() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
<<<<<<< HEAD
      final currentUser = _auth.currentUser;
=======
      final currentUser = FirebaseAuth.instance.currentUser;
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1

      if (currentUser == null) {
        _setUser(null);
        errorMessage = 'Aucun utilisateur connecté.';
        return false;
      }

      await currentUser.reload();

<<<<<<< HEAD
      _setUser(_auth.currentUser);
=======
      _setUser(FirebaseAuth.instance.currentUser);
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1

      if (user == null) {
        return false;
      }

      if (user!.emailVerified) {
        await checkUserRole();
        return true;
      }

      errorMessage = 'Votre email n\'est pas encore vérifié.';
      return false;
    } on FirebaseAuthException catch (e) {
      print('VERIFICATION ERROR: ${e.code}');
      errorMessage = _mapAuthError(e.code);

      if (e.code == 'user-not-found') {
        _setUser(null);
<<<<<<< HEAD
        await _auth.signOut();
=======
        await FirebaseAuth.instance.signOut();
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
      }

      return false;
    } catch (e) {
      print('CHECK VERIFICATION ERROR: $e');
      errorMessage = 'Erreur lors de la vérification. Réessayez.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ────────────────────────────────────────────────────
  // REFRESH USER
  // ────────────────────────────────────────────────────

  Future<void> refreshUser() async {
<<<<<<< HEAD
    final firebaseUser = _auth.currentUser;
=======
    final firebaseUser = FirebaseAuth.instance.currentUser;
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1

    if (firebaseUser == null) {
      _setUser(null);
      return;
    }

    try {
      await firebaseUser.reload();

<<<<<<< HEAD
      _setUser(_auth.currentUser);
=======
      _setUser(FirebaseAuth.instance.currentUser);
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1

      print('REFRESHED USER: $user');
    } on FirebaseAuthException catch (e) {
      print('REFRESH USER ERROR: ${e.code}');

      if (e.code == 'user-not-found') {
        _setUser(null);
<<<<<<< HEAD
        await _auth.signOut();
=======
        await FirebaseAuth.instance.signOut();
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
      } else {
        errorMessage = _mapAuthError(e.code);
        notifyListeners();
      }
    } catch (e) {
      print('REFRESH USER UNKNOWN ERROR: $e');
    }
  }

  // ────────────────────────────────────────────────────
  // FORGOT PASSWORD
  // ────────────────────────────────────────────────────

  Future<bool> forgotPassword(String email) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
<<<<<<< HEAD
      await _auth.sendPasswordResetEmail(email: email.trim());
=======
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1

      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = _mapAuthError(e.code);
      return false;
    } catch (e) {
      print('FORGOT PASSWORD ERROR: $e');
      errorMessage = 'Une erreur inattendue est survenue.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ────────────────────────────────────────────────────
  // LOGOUT
  // ────────────────────────────────────────────────────

  Future<void> logout() async {
    try {
<<<<<<< HEAD
      await _auth.signOut();
=======
      await FirebaseAuth.instance.signOut();
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1

      isAdmin = false;
      _setUser(null);
      errorMessage = null;

      notifyListeners();
    } catch (e) {
      print('LOGOUT ERROR: $e');
    }
  }

  // ────────────────────────────────────────────────────
  // ERROR MAPPING
  // ────────────────────────────────────────────────────

  String _mapAuthError(String code) {
    switch (code) {
      case 'user-not-found':
<<<<<<< HEAD
        return "Ce compte n'existe pas. Vérifiez votre adresse e-mail ou créez un compte.";
=======
        return "Aucun compte n'est associé à cet e-mail.";
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
      case 'wrong-password':
        return 'Mot de passe incorrect.';
      case 'invalid-email':
        return "L'adresse e-mail est invalide.";
      case 'invalid-credential':
<<<<<<< HEAD
        return "Les informations d'identification sont invalides. Vérifiez votre adresse e-mail ou votre mot de passe.";
=======
        return 'Identifiants incorrects.';
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
      case 'user-disabled':
        return 'Ce compte a été désactivé.';
      case 'too-many-requests':
        return 'Trop de tentatives. Réessayez plus tard.';
      case 'email-already-in-use':
        return 'Cet e-mail est déjà utilisé.';
      case 'weak-password':
        return 'Le mot de passe est trop faible.';
      case 'network-request-failed':
        return 'Vérifiez votre connexion Internet.';
      case 'operation-not-allowed':
        return 'Cette méthode de connexion n\'est pas activée.';
      case 'requires-recent-login':
        return 'Veuillez vous reconnecter avant cette opération.';
      default:
        return 'Erreur de connexion. Veuillez réessayer.';
    }
  }
}
