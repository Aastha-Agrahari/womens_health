import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:equatable/equatable.dart';

class Doctor extends Equatable {
  final String id, name, specialty, qualifications, clinicName, city, about, photoUrl;
  final int experienceYears, consultationFee;
  final double rating; final int reviewCount;
  final bool isVerified, offersVideo, offersInPerson;
  const Doctor({required this.id, required this.name, required this.specialty,
    required this.qualifications, required this.experienceYears, required this.rating,
    required this.reviewCount, required this.consultationFee, required this.clinicName,
    required this.city, required this.about, required this.photoUrl, required this.isVerified,
    required this.offersVideo, required this.offersInPerson});
  factory Doctor.fromJson(Map<String, dynamic> j) => Doctor(
    id: j['id'], name: j['name'], specialty: j['specialty'],
    qualifications: j['qualifications'], experienceYears: j['experienceYears'],
    rating: (j['rating'] as num).toDouble(), reviewCount: j['reviewCount'],
    consultationFee: j['consultationFee'], clinicName: j['clinicName'], city: j['city'],
    about: j['about'], photoUrl: j['photoUrl'], isVerified: j['isVerified'],
    offersVideo: j['offersVideo'], offersInPerson: j['offersInPerson'],
  );
  @override List<Object?> get props => [id];
}

abstract class DoctorRepository {
  Future<List<Doctor>> discover({String? specialty, String? city, bool? videoOnly});
  Future<Doctor> getById(String id);
}

class MockDoctorRepository implements DoctorRepository {
  List<Doctor>? _cache;
  Future<List<Doctor>> _load() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/dummy/doctors.json');
    _cache = (json.decode(raw) as List).map((e) => Doctor.fromJson(e)).toList();
    return _cache!;
  }
  @override
  Future<List<Doctor>> discover({String? specialty, String? city, bool? videoOnly}) async {
    await Future.delayed(const Duration(milliseconds: 350));
    var list = await _load();
    if (specialty != null && specialty.isNotEmpty) list = list.where((d) => d.specialty == specialty).toList();
    if (city != null && city.isNotEmpty) list = list.where((d) => d.city == city).toList();
    if (videoOnly == true) list = list.where((d) => d.offersVideo).toList();
    return list;
  }
  @override
  Future<Doctor> getById(String id) async => (await _load()).firstWhere((d) => d.id == id);
}