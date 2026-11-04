import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.85, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));

    Future.delayed(const Duration(milliseconds: 2200), _route);
  }

  void _route() {
    if (!mounted) return;
    final auth = context.read<AuthCubit>().state;
    if (auth.authenticated) {
      context.go('/home');
    } else {
      context.go('/welcome');
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.blush, AppColors.lavender, AppColors.warmWhite],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.55),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_rounded,
                      size: 64,
                      color: AppColors.lavenderDeep,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Bloom',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Women's healthcare, gently.",
                    style: TextStyle(color: AppColors.inkSoft),
                  ),
                  const SizedBox(height: 40),
                  const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: AppColors.lavenderDeep,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}