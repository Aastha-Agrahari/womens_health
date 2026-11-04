import 'package:equatable/equatable.dart';
import 'dart:collection';

class Slot extends Equatable {
  final String id, date, start, end, mode;
  final bool available;
  const Slot({
    required this.id,
    required this.date,
    required this.start,
    required this.end,
    required this.mode,
    required this.available,
  });
  factory Slot.fromJson(Map<String, dynamic> j) => Slot(
    id: j['id'],
    date: j['date'],
    start: j['start'],
    end: j['end'],
    mode: j['mode'],
    available: j['available'],
  );
  @override
  List<Object?> get props => [id];
}

class Appointment extends Equatable {
  final String id,
      doctorId,
      doctorName,
      specialty,
      clinicName,
      date,
      start,
      end,
      mode,
      status;
  // status: confirmed | completed | cancelled
  final double fee;
  final String? notes;

  const Appointment({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.specialty,
    required this.clinicName,
    required this.date,
    required this.start,
    required this.end,
    required this.mode,
    required this.status,
    required this.fee,
    this.notes,
  });

  @override
  List<Object?> get props => [id, status];
}

abstract class AppointmentRepository {
  Future<List<Slot>> getSlots(String doctorId);
  Future<Appointment> book({
    required Slot slot,
    required String doctorId,
    required String doctorName,
  });
  Future<List<Appointment>> myAppointments();
  Future<void> cancel(String id);
}

class InMemoryAppointmentRepository implements AppointmentRepository {
  // Seed once. This gives the appointment screen real content immediately.
  static final List<Appointment> _appointments = [
    Appointment(
      id: 'ap_seed_1',
      doctorId: 'doc_001',
      doctorName: 'Dr. Ananya Iyer',
      specialty: 'Obstetrics & Gynecology',
      clinicName: "Bloom Women's Clinic, Indiranagar",
      date: '2026-11-04',
      start: '10:00',
      end: '10:20',
      mode: 'video',
      status: 'confirmed',
      fee: 800,
      notes: 'Follow-up for PCOS review.',
    ),
    Appointment(
      id: 'ap_seed_2',
      doctorId: 'doc_004',
      doctorName: 'Dr. Fatima Khan',
      specialty: 'General Gynecology',
      clinicName: 'CareWell Clinic, Hyderabad',
      date: '2026-11-12',
      start: '18:00',
      end: '18:20',
      mode: 'video',
      status: 'confirmed',
      fee: 600,
      notes: 'Contraception counselling.',
    ),
    Appointment(
      id: 'ap_seed_3',
      doctorId: 'doc_002',
      doctorName: 'Dr. Meera Nair',
      specialty: 'Reproductive Endocrinology',
      clinicName: 'Aster Fertility Centre, Kochi',
      date: '2026-10-20',
      start: '09:30',
      end: '09:50',
      mode: 'video',
      status: 'completed',
      fee: 1000,
      notes: 'Fertility workup review.',
    ),
    Appointment(
      id: 'ap_seed_4',
      doctorId: 'doc_001',
      doctorName: 'Dr. Ananya Iyer',
      specialty: 'Obstetrics & Gynecology',
      clinicName: "Bloom Women's Clinic, Indiranagar",
      date: '2026-09-15',
      start: '11:00',
      end: '11:20',
      mode: 'in_person',
      status: 'completed',
      fee: 800,
      notes: 'Annual well-woman checkup.',
    ),
    Appointment(
      id: 'ap_seed_5',
      doctorId: 'doc_003',
      doctorName: 'Dr. Priya Sharma',
      specialty: 'Gynecologic Oncology',
      clinicName: 'Sunrise Multispecialty, Mumbai',
      date: '2026-08-30',
      start: '14:00',
      end: '14:20',
      mode: 'in_person',
      status: 'cancelled',
      fee: 1500,
      notes: 'Cancelled by patient.',
    ),
  ];

  static final Map<String, List<Slot>> _slotCache = {
    'doc_001': const [
      Slot(id:'s1',date:'2026-11-04',start:'10:00',end:'10:20',mode:'video',available:true),
      Slot(id:'s2',date:'2026-11-04',start:'10:20',end:'10:40',mode:'video',available:true),
      Slot(id:'s3',date:'2026-11-05',start:'16:00',end:'16:20',mode:'in_person',available:true),
    ],
    'doc_002': const [
      Slot(id:'s6',date:'2026-11-04',start:'09:30',end:'09:50',mode:'video',available:true),
    ],
    'doc_003': const [
      Slot(id:'s8',date:'2026-11-07',start:'11:00',end:'11:20',mode:'in_person',available:true),
    ],
    'doc_004': const [
      Slot(id:'s9',date:'2026-11-04',start:'18:00',end:'18:20',mode:'video',available:true),
    ],
  };

  @override
  Future<List<Slot>> getSlots(String doctorId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _slotCache[doctorId] ?? [];
  }

  @override
  Future<Appointment> book({
    required Slot slot,
    required String doctorId,
    required String doctorName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final ap = Appointment(
      id: 'ap_${DateTime.now().millisecondsSinceEpoch}',
      doctorId: doctorId,
      doctorName: doctorName,
      specialty: 'Consultation',
      clinicName: 'Booked via app',
      date: slot.date,
      start: slot.start,
      end: slot.end,
      mode: slot.mode,
      status: 'confirmed',
      fee: 0,
    );
    _appointments.insert(0, ap);
    return ap;
  }

  @override
  Future<List<Appointment>> myAppointments() async {
    await Future.delayed(const Duration(milliseconds: 200));
    // Sort: confirmed first (upcoming), then completed, then cancelled — newest date first within each
    final list = List<Appointment>.from(_appointments);
    int rank(String s) => switch (s) {
      'confirmed' => 0,
      'completed' => 1,
      _ => 2,
    };
    list.sort((a, b) {
      final r = rank(a.status).compareTo(rank(b.status));
      if (r != 0) return r;
      return b.date.compareTo(a.date);
    });
    return UnmodifiableListView(list);
  }

  @override
  Future<void> cancel(String id) async {
    final i = _appointments.indexWhere((a) => a.id == id);
    if (i >= 0) {
      final a = _appointments[i];
      _appointments[i] = Appointment(
        id: a.id,
        doctorId: a.doctorId,
        doctorName: a.doctorName,
        specialty: a.specialty,
        clinicName: a.clinicName,
        date: a.date,
        start: a.start,
        end: a.end,
        mode: a.mode,
        status: 'cancelled',
        fee: a.fee,
        notes: a.notes,
      );
    }
  }
}