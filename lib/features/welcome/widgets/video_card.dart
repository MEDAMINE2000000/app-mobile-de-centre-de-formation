import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class VideoCard extends StatelessWidget {
  final String thumbnailAsset;
  final String title;
  final String duration;
  final VoidCallback onTap;

  const VideoCard({
    super.key,
    required this.thumbnailAsset,
    required this.title,
    required this.duration,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2.5.w),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Thumbnail
            Image.asset(thumbnailAsset, fit: BoxFit.cover),

            Positioned(
              bottom: 1.5.w,
              left: 1.5.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.65),
                  borderRadius: BorderRadius.circular(1.5.w),
                ),
                child: Text(
                  duration,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            Center(
              child: Container(
                width: 11.w,
                height: 11.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9B4DFF), Color(0xFFE0459D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
