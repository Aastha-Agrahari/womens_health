import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:womens_health/features/appointments/appointments_page.dart';
import '../../features/appointments/booking_page.dart';
import '../../features/auth/auth_cubit.dart';
import '../../features/auth/login_page.dart';
import '../../features/auth/register_page.dart';
import '../../features/auth/welcome_page.dart';
import '../../features/cycle/cycle_page.dart';
import '../../features/doctor/doctor_details_page.dart';
import '../../features/doctor/doctors_page.dart';
import '../../features/home/home_page.dart';
import '../../features/journal/journal_page.dart';
import '../../features/notifications/notifications_page.dart';
import '../../features/pregnancy/pregnancy.dart';
import '../../features/profile/profile_page.dart';
import '../../features/splash/splash_screen.dart';


GoRouter buildRouter(AuthCubit cubit) => GoRouter(
  initialLocation: '/splash',
  redirect: (ctx, state) {
    final auth = cubit.state.authenticated;
    final path = state.matchedLocation;

    final inAuthFlow = path == '/login' ||
        path == '/register' ||
        path == '/welcome' ||
        path == '/splash';

    if (auth && inAuthFlow && path != '/splash') return '/home';
    if (!auth && !inAuthFlow) return '/login';
    return null;
  },
  routes: [
    GoRoute(
      path: '/splash',
      builder: (_, __) =>
          BlocProvider.value(value: cubit, child: const SplashPage()),
    ),
    GoRoute(
      path: '/welcome',
      builder: (_, __) => const WelcomePage(),
    ),
    GoRoute(
      path: '/register',
      builder: (_, __) => const RegisterPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (_, __) =>
          BlocProvider.value(value: cubit, child: const LoginPage()),
    ),
    GoRoute(path: '/home', builder: (_, __) => const HomePage()),
    GoRoute(path: '/doctors', builder: (_, __) => const DoctorsPage()),
    GoRoute(
      path: '/doctors/:id',
      builder: (_, s) => DoctorDetailsPage(id: s.pathParameters['id']!),
    ),
    GoRoute(
      path: '/doctors/:id/book',
      builder: (_, s) => BookingPage(doctorId: s.pathParameters['id']!),
    ),
    GoRoute(
        path: '/appointments', builder: (_, __) => const AppointmentsPage()),
    GoRoute(path: '/cycle', builder: (_, __) => const CyclePage()),
    GoRoute(
        path: '/pregnancy', builder: (_, __) => const PregnancyPage()),
    GoRoute(path: '/journal', builder: (_, __) => const JournalPage()),
    GoRoute(
      path: '/notifications',
      builder: (_, __) => const NotificationsPage(),
    ),
    GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
  ],
);