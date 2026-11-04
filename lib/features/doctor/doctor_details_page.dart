import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/di/injector.dart';
import '../../../core/theme/app_colors.dart';
import 'doctor_repository.dart';

class DoctorDetailsPage extends StatefulWidget {
  final String id;
  const DoctorDetailsPage({super.key, required this.id});
  @override State<DoctorDetailsPage> createState() => _DoctorDetailsPageState();
}

class _DoctorDetailsPageState extends State<DoctorDetailsPage> {
  Doctor? _doctor;
  @override void initState() {
    super.initState();
    sl<DoctorRepository>().getById(widget.id).then((d) { if (mounted) setState(() => _doctor = d); });
  }
  @override Widget build(BuildContext context) {
    if (_doctor == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final d = _doctor!;
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 220, pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(fit: StackFit.expand, children: [
              Image.network(d.photoUrl, fit: BoxFit.cover),
              const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Colors.transparent, AppColors.warmWhite]))),
            ]),
          ),
        ),
        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(d.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800))),
              if (d.isVerified) const Icon(Icons.verified, color: AppColors.teal),
            ]),
            Text(d.specialty, style: const TextStyle(color: AppColors.inkSoft)),
            const SizedBox(height: 8),
            Text(d.qualifications),
            const SizedBox(height: 16),
            Row(children: [
              _Stat(label: 'Rating', value: '${d.rating}'),
              _Stat(label: 'Experience', value: '${d.experienceYears} yrs'),
              _Stat(label: 'Fee', value: '₹${d.consultationFee}'),
            ]),
            const SizedBox(height: 20),
            const Text('About', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 6),
            Text(d.about, style: const TextStyle(color: AppColors.inkSoft, height: 1.5)),
            const SizedBox(height: 20),
            Text(d.clinicName, style: const TextStyle(fontWeight: FontWeight.w700)),
            Text(d.city, style: const TextStyle(color: AppColors.inkSoft)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.calendar_month_rounded),
              label: const Text('View Available Slots'),
              onPressed: () => context.push('/doctors/${d.id}/book'),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.blush.withOpacity(.4), borderRadius: BorderRadius.circular(14)),
              child: const Row(children: [
                Icon(Icons.info_outline, size: 18, color: AppColors.tealDeep),
                SizedBox(width: 8),
                Expanded(child: Text(
                  'This app does not provide automated diagnosis. Consultations and prescriptions are issued only by verified doctors.',
                  style: TextStyle(fontSize: 12),
                )),
              ]),
            ),
          ]),
        )),
      ]),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label, value;
  const _Stat({required this.label, required this.value});
  @override Widget build(_) => Expanded(child: Column(children: [
    Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
    Text(label, style: const TextStyle(color: AppColors.inkSoft, fontSize: 12)),
  ]));
}