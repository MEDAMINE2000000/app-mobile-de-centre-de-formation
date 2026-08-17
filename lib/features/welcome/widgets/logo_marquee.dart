import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LogoMarquee extends StatefulWidget {
  const LogoMarquee({super.key});

  @override
  State<LogoMarquee> createState() => _LogoMarqueeState();
}

class _LogoMarqueeState extends State<LogoMarquee> {
  final ScrollController _controller = ScrollController();
  Timer? _timer;

  final List<String> logos = [
    'assets/welcome/bande/image_1.png',
    'assets/welcome/bande/image_2.png',
    'assets/welcome/bande/image_3.png',
    'assets/welcome/bande/image_4.png',
    'assets/welcome/bande/image_5.png',
    'assets/welcome/bande/image_6.png',
    'assets/welcome/bande/image_7.png',
    'assets/welcome/bande/image_8.png',
    'assets/welcome/bande/image_9.png',
    'assets/welcome/bande/image_10.png',
    'assets/welcome/bande/image_11.png',
    'assets/welcome/bande/image_12.png',
    'assets/welcome/bande/image_13.png',
    'assets/welcome/bande/image_14.png',
    'assets/welcome/bande/image_15.png',
    'assets/welcome/bande/image_16.png',
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
        if (!_controller.hasClients) return;

        double next = _controller.offset + 1.2;

        if (next >= _controller.position.maxScrollExtent) {
          _controller.jumpTo(0);
        } else {
          _controller.jumpTo(next);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: SizedBox(
        height: 45, // <-- bande asgher houni
        child: ListView.builder(
          controller: _controller,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: logos.length * 100,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ), // espace asgher
              child: Image.asset(
                logos[index % logos.length],
                height: 30, // <-- logos asghar
                fit: BoxFit.contain,
              ),
            );
          },
        ),
      ),
    );
  }
}
