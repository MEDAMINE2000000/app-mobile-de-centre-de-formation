import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:three_alfa_mobile_app/features/auth/forgot password/forgot_password_screen.dart';
import 'package:three_alfa_mobile_app/features/auth/login/login_screen.dart';
import 'package:three_alfa_mobile_app/features/auth/register/register_screen.dart';
import 'package:three_alfa_mobile_app/features/auth/email_verification/email_verification_screen.dart';
import 'package:three_alfa_mobile_app/features/auth/provider/auth_provider.dart';

import 'package:three_alfa_mobile_app/features/home/view/home_screen.dart';
import 'package:three_alfa_mobile_app/features/formation/view/formation_screen.dart';

import 'package:three_alfa_mobile_app/features/profile/view/profile_screen.dart';
import 'package:three_alfa_mobile_app/features/inscription/view/inscription_screen.dart';

import 'package:three_alfa_mobile_app/features/admin/view/admin_dashboard_screen.dart';
import 'package:three_alfa_mobile_app/features/admin/view/manage_inscriptions_screen.dart';
import 'package:three_alfa_mobile_app/features/admin/view/admin_placeholder_screen.dart';
<<<<<<< HEAD
import 'package:three_alfa_mobile_app/features/admin/view/manage_users_screen.dart';
import 'package:three_alfa_mobile_app/features/admin/view/user_details_screen.dart';
import 'package:three_alfa_mobile_app/features/admin/model/user_admin_model.dart';

import 'package:three_alfa_mobile_app/features/welcome/view/welcome_screen.dart';
import 'package:three_alfa_mobile_app/features/admin/view/admin_statistics_screen.dart';

GoRouter appRouter(AuthProvider authProvider) {
  return GoRouter(
    // Utilisateur commence par le Welcome
=======

import 'package:three_alfa_mobile_app/features/welcome/view/welcome_screen.dart';

GoRouter appRouter(AuthProvider authProvider) {
  return GoRouter(
    // المستخدم غير المتصل يبدأ من Welcome.
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
    initialLocation: '/welcome',

    refreshListenable: Listenable.merge([
      authProvider.routerRefresh,
      authProvider.adminRefresh,
    ]),

    redirect: (context, state) {
      final user = authProvider.user;
      final path = state.matchedLocation;

      final isAdminPath = path == '/admin' || path.startsWith('/admin/');

      const authPaths = {
        '/login',
        '/register',
        '/forgot-password',
        '/send-otp',
        '/reset-password',
      };

      debugPrint('======================================');
      debugPrint(
        'USER: ${user?.uid} | '
        'EMAIL: ${user?.email} | '
        'VERIFIED: ${user?.emailVerified} | '
        'ADMIN: ${authProvider.isAdmin} | '
        'PATH: $path',
      );
      debugPrint('======================================');

      // ─────────────────────────────────────────────
      // 1. المستخدم غير متصل
      // ─────────────────────────────────────────────
      if (user == null) {
<<<<<<< HEAD
        // يسمح له بصفحات التسجيل والدخول وWelcome
        if (authPaths.contains(path) ||
            path == '/welcome') {
=======
        // يسمح له بصفحات التسجيل والدخول وWelcome.
        if (authPaths.contains(path) || path == '/welcome') {
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
          return null;
        }

        // يمنعه من Home/Profile/Admin...
<<<<<<< HEAD
        return '/login';
=======
        return '/welcome';
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
      }

      // ─────────────────────────────────────────────
      // 2. المستخدم متصل لكن Email غير مفعّل
      // ─────────────────────────────────────────────
      if (!user.emailVerified) {
        if (path == '/verify-email') {
          return null;
        }

        return '/verify-email';
      }

      // ─────────────────────────────────────────────
      // 3. حماية صفحات Admin
      // ─────────────────────────────────────────────
      if (isAdminPath) {
        if (!authProvider.isAdmin) {
          return '/';
        }

        return null;
      }

      // ─────────────────────────────────────────────
      // 4. Admin موجود في Home
      // يحدث هذا إذا اكتملت Admin Claims بعد تسجيل الدخول
      // ─────────────────────────────────────────────
      if (authProvider.isAdmin && path == '/') {
        return '/admin';
      }

      // ─────────────────────────────────────────────
<<<<<<< HEAD
      // 5. مستخدم متصل يحاول الرجوع إلى Login/Register/Welcome
=======
      // 5. مستخدم متصل يحاول الرجوع إلى Login/Register
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
      // ─────────────────────────────────────────────
      if (authPaths.contains(path) ||
          path == '/verify-email' ||
          path == '/welcome') {
        if (authProvider.isAdmin) {
          return '/admin';
        }

        return '/';
      }

      // لا يوجد redirect.
      return null;
    },

    routes: [
      // ─────────────────────────────────────────────
      // Welcome
      // ─────────────────────────────────────────────
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),

      // ─────────────────────────────────────────────
      // User routes
      // ─────────────────────────────────────────────
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),

      GoRoute(
        path: '/formation',
        builder: (context, state) => const FormationScreen(),
      ),

      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),

      GoRoute(
        path: '/my-inscriptions',
        builder: (context, state) => const InscriptionScreen(),
      ),

      // ─────────────────────────────────────────────
      // Authentication routes
      // ─────────────────────────────────────────────
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      GoRoute(
        path: '/verify-email',
        builder: (context, state) => const EmailVerificationScreen(),
      ),

      // ─────────────────────────────────────────────
      // Admin routes
      // ─────────────────────────────────────────────
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboardScreen(),
      ),

      GoRoute(
        path: '/admin/inscriptions',
        builder: (context, state) => const ManageInscriptionsScreen(),
      ),

      GoRoute(
        path: '/admin/users',
<<<<<<< HEAD
        builder: (context, state) => const ManageUsersScreen(),
      ),

      GoRoute(
        path: '/admin/users/:uid',
        builder: (context, state) {
          final user = state.extra as UserAdminModel;
          return UserDetailsScreen(user: user);
        },
=======
        builder: (context, state) =>
            const AdminPlaceholderScreen(title: 'Gestion des utilisateurs'),
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
      ),

      GoRoute(
        path: '/admin/formations',
        builder: (context, state) => const ManageInscriptionsScreen(),
      ),

      GoRoute(
        path: '/admin/notifications',
        builder: (context, state) =>
            const AdminPlaceholderScreen(title: 'Notifications'),
      ),

      GoRoute(
        path: '/admin/settings',
        builder: (context, state) =>
            const AdminPlaceholderScreen(title: 'Paramètres'),
      ),
<<<<<<< HEAD

      GoRoute(
        path: '/admin/statistics',
        builder: (context, state) => const AdminStatisticsScreen(),
      ),
=======
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
    ],
  );
}
