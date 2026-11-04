import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hi, Aisha 👋'),
          actions: [
            IconButton(icon: const Icon(Icons.notifications_none), onPressed: () => context.push('/notifications')),
            IconButton(icon: const Icon(Icons.person_outline), onPressed: () => context.push('/profile')),
          ]),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [AppColors.blush, AppColors.lavender]),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Your health, your pace.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            const Text('Book a verified gynecologist, track your cycle, or chat privately.'),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: () => context.push('/doctors'),
              icon: const Icon(Icons.search),
              label: const Text('Find a doctor'),
            ),
          ]),
        ),
        const SizedBox(height: 20),
        GridView.count(
          crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.15,
          children: const [
            _QuickTile(icon: Icons.calendar_month, label: 'Appointments', route: '/appointments', color: AppColors.lavenderDeep),
            _QuickTile(icon: Icons.water_drop, label: 'Cycle', route: '/cycle', color: AppColors.blushDeep),
            _QuickTile(icon: Icons.pregnant_woman, label: 'Pregnancy', route: '/pregnancy', color: AppColors.tealDeep),
            _QuickTile(icon: Icons.note_alt, label: 'Journal', route: '/journal', color: AppColors.warning),
          ],
        ),
        const SizedBox(height: 20),
        const Text('Upcoming', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        const SizedBox(height: 8),
        Card(child: ListTile(
          leading: const CircleAvatar(backgroundColor: AppColors.blush, child: Icon(Icons.videocam, color: AppColors.blushDeep)),
          title: const Text('Dr. Ananya Iyer'),
          subtitle: const Text('Nov 4 • 10:00 AM • Video'),
          trailing: StatusChipMini(label: 'Confirmed'),
        )),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.lavender.withOpacity(.35), borderRadius: BorderRadius.circular(14)),
          child: const Row(children: [
            Icon(Icons.shield_outlined, size: 18, color: AppColors.lavenderDeep),
            SizedBox(width: 8),
            Expanded(child: Text('This app does not diagnose. Only verified doctors provide consultations.',
                style: TextStyle(fontSize: 12))),
          ]),
        ),
      ]),
    );
  }
}

class _QuickTile extends StatelessWidget {
  final IconData icon; final String label, route; final Color color;
  const _QuickTile({required this.icon, required this.label, required this.route, required this.color});
  @override Widget build(ctx) => Card(
    child: InkWell(borderRadius: BorderRadius.circular(20), onTap: () => ctx.push(route),
        child: Padding(padding: const EdgeInsets.all(14), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: color.withOpacity(.15), borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, color: color)),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
            ]))),
  );
}

class StatusChipMini extends StatelessWidget {
  final String label;
  const StatusChipMini({super.key, required this.label});
  @override Widget build(_) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: AppColors.success.withOpacity(.15), borderRadius: BorderRadius.circular(20)),
    child: const Text('Confirmed', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.success)),
  );
}