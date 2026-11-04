import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/di/injector.dart';
import '../../../core/theme/app_colors.dart';
import '../../shared/widget/empty_state.dart';
import '../../shared/widget/status_chip.dart';
import 'appointment_repository.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});
  @override State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  List<Appointment> _all = [];
  bool _loading = true;
  String _tab = 'upcoming'; // upcoming | past | cancelled

  Future<void> _load() async {
    setState(() => _loading = true);
    final list = await sl<AppointmentRepository>().myAppointments();
    if (mounted) {
      setState(() {
        _all = list;
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  List<Appointment> get _filtered => switch (_tab) {
    'upcoming' => _all.where((a) => a.status == 'confirmed').toList(),
    'past' => _all.where((a) => a.status == 'completed').toList(),
    _ => _all.where((a) => a.status == 'cancelled').toList(),
  };

  Color _statusColor(String s) => switch (s) {
    'confirmed' => AppColors.success,
    'completed' => AppColors.tealDeep,
    'cancelled' => AppColors.danger,
    _ => AppColors.inkSoft,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Appointments')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: Column(
          children: [
            // Tabs
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  _Tab(
                    label: 'Upcoming',
                    active: _tab == 'upcoming',
                    count: _all.where((a) => a.status == 'confirmed').length,
                    onTap: () => setState(() => _tab = 'upcoming'),
                  ),
                  const SizedBox(width: 8),
                  _Tab(
                    label: 'Past',
                    active: _tab == 'past',
                    count: _all.where((a) => a.status == 'completed').length,
                    onTap: () => setState(() => _tab = 'past'),
                  ),
                  const SizedBox(width: 8),
                  _Tab(
                    label: 'Cancelled',
                    active: _tab == 'cancelled',
                    count: _all.where((a) => a.status == 'cancelled').length,
                    onTap: () => setState(() => _tab = 'cancelled'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _filtered.isEmpty
                  ? ListView(
                children: const [
                  SizedBox(height: 120),
                  EmptyState(
                    icon: Icons.event_busy,
                    title: 'Nothing here yet',
                    subtitle:
                    'Book a consultation from the Doctors tab.',
                  ),
                ],
              )
                  : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) =>
                    _AppointmentCard(a: _filtered[i], onChanged: _load),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool active;
  final int count;
  final VoidCallback onTap;
  const _Tab({
    required this.label,
    required this.active,
    required this.count,
    required this.onTap,
  });
  @override
  Widget build(_) => Expanded(
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.lavenderDeep : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active ? Colors.transparent : Colors.black12,
          ),
        ),
        child: Center(
          child: Text(
            '$label ($count)',
            style: TextStyle(
              color: active ? Colors.white : AppColors.ink,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    ),
  );
}

class _AppointmentCard extends StatelessWidget {
  final Appointment a;
  final VoidCallback onChanged;
  const _AppointmentCard({required this.a, required this.onChanged});

  Color _statusColor() => switch (a.status) {
    'confirmed' => AppColors.success,
    'completed' => AppColors.tealDeep,
    'cancelled' => AppColors.danger,
    _ => AppColors.inkSoft,
  };

  @override
  Widget build(BuildContext context) {
    final dt = DateTime.tryParse(a.date);
    final dateLabel = dt == null ? a.date : DateFormat('EEE, MMM d').format(dt);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    a.doctorName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
                StatusChip(
                  label: a.status.toUpperCase(),
                  color: _statusColor(),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              a.specialty,
              style: const TextStyle(color: AppColors.inkSoft, fontSize: 13),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 14, color: AppColors.inkSoft),
                const SizedBox(width: 4),
                Text('$dateLabel • ${a.start} – ${a.end}',
                    style: const TextStyle(fontSize: 13)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  a.mode == 'video'
                      ? Icons.videocam_outlined
                      : Icons.local_hospital_outlined,
                  size: 14,
                  color: AppColors.inkSoft,
                ),
                const SizedBox(width: 4),
                Text(
                  a.mode == 'video' ? 'Video consultation' : 'In-clinic visit',
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(width: 8),
                Text('• ₹${a.fee.toInt()}',
                    style: const TextStyle(fontSize: 13)),
              ],
            ),
            if (a.clinicName.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.place_outlined,
                      size: 14, color: AppColors.inkSoft),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      a.clinicName,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.inkSoft),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            if (a.notes != null && a.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.lavender.withOpacity(.35),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(a.notes!,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.inkSoft)),
              ),
            ],
            if (a.status == 'confirmed') ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.videocam, size: 18),
                      label: const Text('Join'),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => Scaffold(
                            appBar: AppBar(title: const Text('Video Call')),
                            body: const Center(
                              child: Text(
                                'Agora video session stub\n(wire your Agora token here)',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () async {
                      await sl<AppointmentRepository>().cancel(a.id);
                      onChanged();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Appointment cancelled')),
                      );
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}