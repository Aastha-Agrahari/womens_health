import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widget/app_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              // Illustration
              Container(
                height: 220,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.blush, AppColors.lavender],
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: const Center(
                  child: Icon(
                    Icons.local_hospital_rounded,
                    size: 88,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Care that fits\nyour life',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Consult verified gynecologists, track your cycle, '
                    'and keep your health records safe — all in one place.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.inkSoft.withOpacity(.9),
                  height: 1.5,
                ),
              ),
              const Spacer(),
              AppButton(
                label: 'Create new account',
                onPressed: () => context.push('/register'),
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'I already have an account',
                outlined: true,
                onPressed: () => context.push('/login'),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.shield_outlined,
                      size: 16, color: AppColors.inkSoft),
                  SizedBox(width: 6),
                  Text(
                    'Your data is encrypted & private',
                    style: TextStyle(fontSize: 12, color: AppColors.inkSoft),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}