import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app.dart';
import 'core/di/injector.dart';
import 'features/auth/auth_cubit.dart';
import 'features/auth/auth_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  final authCubit = AuthCubit(sl<AuthRepository>());
  runApp(MultiBlocProvider(providers: [
    BlocProvider.value(value: authCubit),
  ], child: App(authCubit: authCubit)));
}