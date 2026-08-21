import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:three_alfa_mobile_app/core/routes/app_router.dart';

import 'package:three_alfa_mobile_app/features/auth/provider/auth_provider.dart';
import 'package:three_alfa_mobile_app/features/inscription/provider/inscription_provider%20.dart';
import 'package:three_alfa_mobile_app/features/profile/provider/profile_provider.dart';

import 'features/admin/provider/admin_provider.dart';

<<<<<<< HEAD
import 'package:three_alfa_mobile_app/core/utils/performance_monitor.dart';

void main() async {
  PerformanceMonitor.start('startup');
=======
void main() async {
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => InscriptionProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: const MyApp(),
    ),
  );
<<<<<<< HEAD

  WidgetsBinding.instance.addPostFrameCallback((_) {
    PerformanceMonitor.stop('startup', customMessage: 'Temps de démarrage');
  });
=======
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter(authProvider),
        );
      },
    );
  }
}
