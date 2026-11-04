import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/theme/app_colors.dart';

class CyclePage extends StatefulWidget {
  const CyclePage({super.key});
  @override State<CyclePage> createState() => _CyclePageState();
}

class _CyclePageState extends State<CyclePage> {
  DateTime _focused = DateTime.now();
  DateTime? _selected;
  final List<DateTime> _periodDays = [
    DateTime(2026,10,1), DateTime(2026,10,2), DateTime(2026,10,3), DateTime(2026,10,4), DateTime(2026,10,5),
    DateTime(2026,10,29), DateTime(2026,10,30), DateTime(2026,10,31), DateTime(2026,11,1), DateTime(2026,11,2),
    DateTime(2026,9,3), DateTime(2026,9,4), DateTime(2026,9,5), DateTime(2026,9,6), DateTime(2026,9,7),
  ];

  bool _isPeriod(DateTime d) => _periodDays.any((p) =>
  p.year == d.year && p.month == d.month && p.day == d.day);

  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cycle Tracker')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(child: Padding(padding: const EdgeInsets.all(8), child: TableCalendar(
          firstDay: DateTime.utc(2025,1,1), lastDay: DateTime.utc(2027,12,31),
          focusedDay: _focused, selectedDayPredicate: (d) => isSameDay(d, _selected),
          onDaySelected: (s, f) => setState(() { _selected = s; _focused = f; }),
          calendarFormat: CalendarFormat.month,
          eventLoader: (d) => _isPeriod(d) ? ['period'] : [],
          calendarBuilders: CalendarBuilders(
            markerBuilder: (ctx, day, events) {
              if (events.isEmpty) return null;
              return Container(margin: const EdgeInsets.only(top: 22), width: 6, height: 6,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.blushDeep));
            },
          ),
        ))),
        const SizedBox(height: 16),
        _InfoTile(label: 'Average cycle length', value: '29 days'),
        _InfoTile(label: 'Average period length', value: '5 days'),
        _InfoTile(label: 'Next period expected', value: 'Nov 27, 2026'),
        const SizedBox(height: 16),
        const Text('Logs', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        const SizedBox(height: 8),
        ..._periodDays.take(5).map((d) => ListTile(
          leading: const Icon(Icons.water_drop, color: AppColors.blushDeep),
          title: Text('Period started • ${d.month}/${d.day}/${d.year}'),
          subtitle: const Text('Flow: medium'),
        )),
      ]),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label, value;
  const _InfoTile({required this.label, required this.value});
  @override Widget build(_) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(color: AppColors.inkSoft)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
      ]));
}