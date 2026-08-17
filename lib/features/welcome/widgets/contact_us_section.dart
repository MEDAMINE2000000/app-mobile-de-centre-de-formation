import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsSection extends StatelessWidget {
  const ContactUsSection({super.key});
  Future<void> _callPhone(BuildContext context, String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    await _launch(context, uri);
  }

  Future<void> _sendMail(BuildContext context, String email) async {
    final Uri uri = Uri(scheme: 'mailto', path: email);
    await _launch(context, uri);
  }

  Future<void> _openMap(BuildContext context, String address) async {
    final Uri uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}',
    );
    await _launch(context, uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _launch(
    BuildContext context,
    Uri uri, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) async {
    try {
      final bool ok = await launchUrl(uri, mode: mode);
      if (!ok && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Impossible d'ouvrir cette application"),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Erreur d'ouverture")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        children: [
          _ContactCard(
            icon: Icons.call_rounded,
            iconBg: const Color(0xFFFCE4EC),
            iconColor: const Color(0xFFE91E63),
            label: "Téléphone",
            value: "+216 28 115 606",
            onTap: () => _callPhone(context, "+21628115606"),
          ),
          Gap(1.h),
          _ContactCard(
            icon: Icons.email_rounded,
            iconBg: const Color(0xFFEDE7F6),
            iconColor: const Color(0xFF4A148C),
            label: "E-mail",
            value: "contact@threealfa.tun",
            onTap: () => _sendMail(context, "contact@threealfa.tun"),
          ),
          Gap(1.h),
          _ContactCard(
            icon: Icons.location_on_rounded,
            iconBg: const Color(0xFFE8EAF6),
            iconColor: const Color(0xFF1A1A40),
            label: "Adresse",
            value: "15 Rue Khlifa Ben Jeddou, Manar 3",
            onTap: () =>
                _openMap(context, "15 Rue Khlifa Ben Jeddou, Manar 3, 2091"),
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String value;
  final VoidCallback onTap;
  const _ContactCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 1,
      borderRadius: const BorderRadius.all(Radius.circular(14)),
      child: ListTile(
        onTap: onTap,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 2.5.w,
          vertical: 0.5.h,
        ),
        leading: Container(
          width: 11.w,
          height: 11.w,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: Icon(icon, color: iconColor, size: 5.w),
        ),
        title: Text(
          label,
          style: TextStyle(fontSize: 15.sp, color: Colors.grey),
        ),
        subtitle: Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF000027),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: Colors.grey.shade400,
          size: 6.w,
        ),
      ),
    );
  }
}
