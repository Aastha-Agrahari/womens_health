import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class PregnancyPage extends StatelessWidget {
  const PregnancyPage({super.key});
  @override Widget build(BuildContext context) {
    const currentWeek = 18; const total = 40;
    return Scaffold(
      appBar: AppBar(title: const Text('Pregnancy Journey')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
          const Text('Week 18 of 40', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          ClipRRect(borderRadius: BorderRadius.circular(20), child: LinearProgressIndicator(
              value: currentWeek/total, minHeight: 14, backgroundColor: AppColors.lavender,
              valueColor: const AlwaysStoppedAnimation(AppColors.blushDeep))),
          const SizedBox(height: 12),
          const Text('Your baby is about the size of a bell pepper 🫑'),
        ]))),
        const SizedBox(height: 16),
        const Text('This week', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        const SizedBox(height: 6),
        const Text(
          'Baby\'s hearing is developing. You may feel more movement. Stay hydrated and keep up with your prenatal appointments. '
              '⚠️ This information is educational only and is not medical advice.',
          style: TextStyle(height: 1.5),
        ),
        const SizedBox(height: 16),
        Card(child: ListTile(
          leading: const Icon(Icons.event_available, color: AppColors.tealDeep),
          title: const Text('Next prenatal visit'),
          subtitle: const Text('Nov 12, 2026 • Dr. Ananya Iyer'),
        )),
        const SizedBox(height: 12),
        Card(child: ListTile(
          leading: const Icon(Icons.emergency, color: AppColors.danger),
          title: const Text('Emergency guidance'),
          subtitle: const Text('Severe bleeding, reduced fetal movement, or severe abdominal pain — seek immediate in-person care.'),
          onTap: () => showDialog(context: context, builder: (_) => AlertDialog(
            title: const Text('Emergency?'),
            content: const Text('Call your local emergency number or go to the nearest hospital immediately. '
                'This app does not provide emergency diagnosis.'),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
          )),
        )),
      ]),
    );
  }
}