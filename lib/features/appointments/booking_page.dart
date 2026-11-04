import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/di/injector.dart';
import '../../../core/theme/app_colors.dart';
import 'appointment_repository.dart';

class BookingPage extends StatefulWidget {
  final String doctorId;
  const BookingPage({super.key, required this.doctorId});
  @override State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  List<Slot> _slots = []; Slot? _selected; bool _busy = false;

  @override void initState() {
    super.initState();
    sl<AppointmentRepository>().getSlots(widget.doctorId).then((s) {
      if (mounted) setState(() => _slots = s);
    });
  }

  Future<void> _book() async {
    if (_selected == null) return;
    setState(() => _busy = true);
    await sl<AppointmentRepository>().book(
        slot: _selected!, doctorId: widget.doctorId, doctorName: widget.doctorId);
    if (!mounted) return;
    setState(() => _busy = false);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment confirmed ✓'), backgroundColor: AppColors.success));
    context.go('/appointments');
  }

  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select a Slot')),
      body: _slots.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ..._slots.map((s) {
            final label = '${DateFormat('MMM d').format(DateTime.parse(s.date))} • ${s.start} – ${s.end}';
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: _selected?.id == s.id ? AppColors.lavenderDeep : Colors.black12)),
                tileColor: Colors.white,
                leading: Icon(s.mode == 'video' ? Icons.videocam_outlined : Icons.local_hospital_outlined,
                    color: AppColors.tealDeep),
                title: Text(label),
                subtitle: Text(s.mode == 'video' ? 'Video consultation' : 'In-clinic visit'),
                trailing: s.available ? const Icon(Icons.check_circle, color: AppColors.success)
                    : const Text('Full', style: TextStyle(color: AppColors.danger)),
                enabled: s.available,
                onTap: () => setState(() => _selected = s),
              ),
            );
          }),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _selected == null || _busy ? null : _book,
            child: _busy ? const SizedBox(height: 20, width: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Confirm Appointment'),
          ),
        ],
      ),
    );
  }
}