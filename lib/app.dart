import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injector.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/auth_cubit.dart';
import 'features/doctor/doctor_repository.dart';
import 'features/doctor/doctors_cubit.dart';

class App extends StatefulWidget {
  final AuthCubit authCubit;
  const App({super.key, required this.authCubit});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final _router = buildRouter(widget.authCubit);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DoctorsCubit(sl<DoctorRepository>())),
      ],
      child: MaterialApp.router(
        title: 'Bloom',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        routerConfig: _router,
      ),
    );
  }
}