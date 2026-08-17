import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentPageIndex, children: _pages),

      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentPageIndex,
        onTap: (index) {
          if (index == _currentPageIndex) return;

          setState(() {
            _currentPageIndex = index;
          });
        },
      ),
    );
  }
}
