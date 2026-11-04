import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../auth/auth_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [
          const CircleAvatar(radius: 32, backgroundColor: AppColors.blush,
              child: Icon(Icons.person, size: 34, color: AppColors.blushDeep)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Text('Aisha Rahman', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            Text('+91 98765 43210', style: TextStyle(color: AppColors.inkSoft)),
            Text('Patient ID: PT-10023', style: TextStyle(color: AppColors.inkSoft, fontSize: 12)),
          ])),
        ]))),
        const SizedBox(height: 16),
        ..._tile(Icons.shield_outlined, 'Consent & Privacy'),
        ..._tile(Icons.description_outlined, 'Medical Records'),
        ..._tile(Icons.medication_outlined, 'Prescriptions'),
        ..._tile(Icons.help_outline, 'Help & Support'),
        ..._tile(Icons.logout, 'Logout', onTap: () {
          context.read<AuthCubit>().logout();
          context.go('/login');
        }),
        const SizedBox(height: 24),
        const Center(child: Text('Bloom v0.1.0 • Development build (dummy data)',
            style: TextStyle(fontSize: 12, color: AppColors.inkSoft))),
      ]),
    );
  }
  List<Widget> _tile(IconData icon, String title, {VoidCallback? onTap}) => [
    Card(child: ListTile(leading: Icon(icon, color: AppColors.lavenderDeep), title: Text(title),
        trailing: const Icon(Icons.chevron_right), onTap: onTap ?? () {})),
    const SizedBox(height: 8),
  ];
}