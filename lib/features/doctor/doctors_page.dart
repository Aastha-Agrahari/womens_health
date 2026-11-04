import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../shared/widget/empty_state.dart';
import '../../shared/widget/status_chip.dart';
import 'doctor_repository.dart';
import 'doctors_cubit.dart';

class DoctorsPage extends StatefulWidget {
  const DoctorsPage({super.key});
  @override State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  String? _specialty; bool _videoOnly = false;

  @override void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }
  void _load() => context.read<DoctorsCubit>().load(specialty: _specialty, videoOnly: _videoOnly);

  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find a Doctor')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            Expanded(child: TextField(
              decoration: const InputDecoration(hintText: 'Search specialty…', prefixIcon: Icon(Icons.search)),
              onSubmitted: (v) { _specialty = v; _load(); },
            )),
            const SizedBox(width: 8),
            FilterChip(
              label: const Text('Video'),
              selected: _videoOnly,
              onSelected: (v) { _videoOnly = v; _load(); },
              selectedColor: AppColors.lavender,
            ),
          ]),
        ),
        const SizedBox(height: 8),
        Expanded(child: BlocBuilder<DoctorsCubit, DoctorsState>(
          builder: (ctx, s) {
            if (s.loading) return const Center(child: CircularProgressIndicator());
            if (s.doctors.isEmpty) return const EmptyState(
                icon: Icons.search_off, title: 'No doctors found',
                subtitle: 'Try different filters or check back later.');
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: s.doctors.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _DoctorCard(d: s.doctors[i]),
            );
          },
        )),
      ]),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final Doctor d; const _DoctorCard({required this.d});
  @override Widget build(ctx) => Card(
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => ctx.push('/doctors/${d.id}'),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(d.photoUrl, width: 68, height: 68, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(width: 68, height: 68,
                    color: AppColors.blush, child: const Icon(Icons.person, color: AppColors.lavenderDeep))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Flexible(child: Text(d.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16))),
              if (d.isVerified) const Padding(padding: EdgeInsets.only(left: 4),
                  child: Icon(Icons.verified, size: 16, color: AppColors.teal)),
            ]),
            const SizedBox(height: 2),
            Text(d.specialty, style: const TextStyle(color: AppColors.inkSoft, fontSize: 13)),
            const SizedBox(height: 6),
            Row(children: [
              const Icon(Icons.star_rounded, size: 16, color: AppColors.warning),
              Text(' ${d.rating} (${d.reviewCount})', style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 10),
              Icon(Icons.work_outline, size: 14, color: AppColors.inkSoft),
              Text(' ${d.experienceYears}y', style: const TextStyle(fontSize: 12)),
            ]),
            const SizedBox(height: 6),
            Row(children: [
              StatusChip(label: '₹${d.consultationFee}', color: AppColors.tealDeep),
              const SizedBox(width: 6),
              if (d.offersVideo) StatusChip(label: 'Video', color: AppColors.lavenderDeep),
              const SizedBox(width: 6),
              if (d.offersInPerson) StatusChip(label: 'Clinic', color: AppColors.blushDeep),
            ]),
          ])),
        ]),
      ),
    ),
  );
}