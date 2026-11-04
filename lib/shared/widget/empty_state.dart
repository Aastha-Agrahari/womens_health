import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class EmptyState extends StatelessWidget {
  final IconData icon; final String title; final String subtitle;
  const EmptyState({super.key, required this.icon, required this.title, required this.subtitle});
  @override Widget build(_) => Center(child: Padding(
    padding: const EdgeInsets.all(32),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 64, color: AppColors.lavenderDeep),
      const SizedBox(height: 16),
      Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18), textAlign: TextAlign.center),
      const SizedBox(height: 6),
      Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.inkSoft)),
    ]),
  ));
}