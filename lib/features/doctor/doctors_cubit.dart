import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'doctor_repository.dart';

// ---- STATE ----
class DoctorsState extends Equatable {
  final bool loading;
  final List<Doctor> doctors;
  final String? specialty;
  final String? city;
  final bool videoOnly;
  final String? error;

  const DoctorsState({
    this.loading = false,
    this.doctors = const [],
    this.specialty,
    this.city,
    this.videoOnly = false,
    this.error,
  });

  DoctorsState copyWith({
    bool? loading,
    List<Doctor>? doctors,
    String? specialty,
    String? city,
    bool? videoOnly,
    String? error,
  }) {
    return DoctorsState(
      loading: loading ?? this.loading,
      doctors: doctors ?? this.doctors,
      specialty: specialty ?? this.specialty,
      city: city ?? this.city,
      videoOnly: videoOnly ?? this.videoOnly,
      error: error,
    );
  }

  @override
  List<Object?> get props => [loading, doctors, specialty, city, videoOnly, error];
}

// ---- CUBIT ----
class DoctorsCubit extends Cubit<DoctorsState> {
  final DoctorRepository repo;
  DoctorsCubit(this.repo) : super(const DoctorsState());

  Future<void> load({
    String? specialty,
    String? city,
    bool videoOnly = false,
  }) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final list = await repo.discover(
        specialty: specialty,
        city: city,
        videoOnly: videoOnly,
      );
      emit(state.copyWith(
        loading: false,
        doctors: list,
        specialty: specialty,
        city: city,
        videoOnly: videoOnly,
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}