import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../../features/appointments/appointment_repository.dart';
import '../../features/auth/auth_repository.dart';
import '../../features/doctor/doctor_repository.dart';
import '../config/app_config.dart';
import '../network/api_client.dart';


final sl = GetIt.instance;

Future<void> configureDependencies() async {
  sl.registerLazySingleton<Dio>(() => buildDio(AppConfig.apiBaseUrl));

  if (AppConfig.useMockData) {
    sl.registerLazySingleton<AuthRepository>(() => MockAuthRepository());
    sl.registerLazySingleton<DoctorRepository>(() => MockDoctorRepository());
    sl.registerLazySingleton<AppointmentRepository>(() => InMemoryAppointmentRepository());
  } else {
    // register real repositories using sl<Dio>()
  }
}