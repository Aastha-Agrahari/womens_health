import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});
  @override State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final _note = TextEditingController();
  double _pain = 2;
  String _mood = 'calm';
  final List<Map<String, dynamic>> _entries = [
    {'date':'Nov 1','mood':'anxious','pain':3,'note':'Cramping before period.'},
    {'date':'Oct 28','mood':'calm','pain':0,'note':'Felt good today.'},
  ];

  void _save() {
    setState(() {
      _entries.insert(0, {'date':'Today','mood':_mood,'pain':_pain.round(),'note':_note.text});
      _note.clear();
      _pain = 2;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Entry saved')));
  }

  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Symptom Journal')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('How are you feeling today?', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Wrap(spacing: 8, children: ['calm','tired','anxious','happy','irritable'].map((m) =>
                ChoiceChip(label: Text(m), selected: _mood == m, onSelected: (_) => setState(() => _mood = m))).toList()),
            const SizedBox(height: 12),
            Text('Pain level: ${_pain.round()}'),
            Slider(value: _pain, max: 10, divisions: 10, onChanged: (v) => setState(() => _pain = v),
                activeColor: AppColors.blushDeep),
            TextField(controller: _note, maxLines: 3,
                decoration: const InputDecoration(hintText: 'Add a note…')),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _save, child: const Text('Save entry')),
          ],
        ))),
        const SizedBox(height: 16),
        ..._entries.map((e) => Card(child: ListTile(
          leading: const Icon(Icons.note_alt_outlined, color: AppColors.lavenderDeep),
          title: Text('${e['date']} • ${e['mood']} • pain ${e['pain']}/10'),
          subtitle: (e['note'] as String).isEmpty ? null : Text(e['note']),
        ))),
      ]),
    );
  }
}