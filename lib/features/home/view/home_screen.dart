import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:three_alfa_mobile_app/core/utils/performance_monitor.dart';
=======
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1

import 'package:three_alfa_mobile_app/features/formation/view/formation_screen.dart';
import 'package:three_alfa_mobile_app/features/home/widgets/bottom_nav_bar.dart';
import 'package:three_alfa_mobile_app/features/inscription/view/inscription_screen.dart';
import 'package:three_alfa_mobile_app/features/profile/view/profile_screen.dart';
import 'package:three_alfa_mobile_app/features/welcome/view/welcome_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPageIndex = 0;

  final List<Widget> _pages = const [
    WelcomeScreen(),
    FormationScreen(),
    InscriptionScreen(), // ← جديد
    ProfileScreen(),
  ];

  @override
<<<<<<< HEAD
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PerformanceMonitor.stop('connexion', customMessage: 'Temps de connexion');
      PerformanceMonitor.stop('nav_Login_Home', customMessage: 'Temps de navigation [Login -> Home]');
    });
  }

  String _pageName(int index) {
    switch (index) {
      case 0: return 'Home';
      case 1: return 'Formation';
      case 2: return 'Inscription';
      case 3: return 'Profile';
      default: return 'Unknown';
    }
  }

  @override
=======
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentPageIndex, children: _pages),

      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentPageIndex,
        onTap: (index) {
          if (index == _currentPageIndex) return;
<<<<<<< HEAD
          
          final from = _pageName(_currentPageIndex);
          final to = _pageName(index);
          PerformanceMonitor.start('nav_${from}_$to');
=======
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1

          setState(() {
            _currentPageIndex = index;
          });
<<<<<<< HEAD
          
          PerformanceMonitor.stopOnNextFrame('nav_${from}_$to', customMessage: 'Temps de navigation [$from -> $to]');
=======
>>>>>>> d691313802b9e9f6c22ed314999a4aa60dcad9b1
        },
      ),
    );
  }
}
