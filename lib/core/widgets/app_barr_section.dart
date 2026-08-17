import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:three_alfa_mobile_app/core/constants/app_colors.dart';

import 'package:three_alfa_mobile_app/core/widgets/shared_button.dart';

class AppBarrSection extends StatelessWidget implements PreferredSizeWidget {
  const AppBarrSection({super.key});

  @override
  Size get preferredSize => Size.fromHeight(85.h * 0.09);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.navy),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 5,
          toolbarHeight: 85.h * 0.09,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.appBarColorGradient,
            ),
          ),
          title: Image.asset('assets/welcome/three_alfa_logo.png', scale: 4),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 4.w),
              child: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  final user = snapshot.data;
                  print(user);
                  // ── Authenticated → CircleAvatar ──
                  if (user != null) {
                    return GestureDetector(
                      onTap: () {
                        context.push('/profile');
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.purple,
                        backgroundImage: user.photoURL != null
                            ? NetworkImage(user.photoURL!)
                            : null,
                        child: user.photoURL == null
                            ? const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 22,
                              )
                            : null,
                      ),
                    );
                  }

                  // ── Not authenticated → Login button ──
                  return SharedButton(
                    onPressed: () {
                      context.push('/login');
                    },
                    label: 'connexion',
                    icon: Icons.login_rounded,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
