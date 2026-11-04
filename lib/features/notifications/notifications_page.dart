import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});
  @override State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> _items = [];
  @override void initState() {
    super.initState();
    rootBundle.loadString('assets/dummy/notifications.json').then((raw) {
      if (mounted) setState(() => _items = List<Map<String, dynamic>>.from(json.decode(raw)));
    });
  }
  @override Widget build(_) => Scaffold(
    appBar: AppBar(title: const Text('Notifications')),
    body: ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final n = _items[i];
        return Card(child: ListTile(
          leading: CircleAvatar(backgroundColor: AppColors.lavender.withOpacity(.5),
              child: Icon(n['type'] == 'appointment' ? Icons.event_available : Icons.water_drop,
                  color: AppColors.lavenderDeep)),
          title: Text(n['title'], style: TextStyle(fontWeight: n['isRead'] == true ? FontWeight.w500 : FontWeight.w800)),
          subtitle: Text(n['body']),
        ));
      },
    ),
  );
}