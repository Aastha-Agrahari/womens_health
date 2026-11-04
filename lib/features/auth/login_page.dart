import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../shared/widget/app_button.dart';
import 'auth_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phone = TextEditingController();
  final _otp   = TextEditingController();

  @override Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (ctx, s) {
              if (s.authenticated) ctx.go('/home');
              if (s.error != null) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(content: Text(s.error!), backgroundColor: AppColors.danger));
              }
            },
            builder: (ctx, s) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.blush, AppColors.lavender]),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(Icons.favorite_rounded, size: 42, color: AppColors.lavenderDeep),
                  ),
                  const SizedBox(height: 24),
                  Text('Welcome to Bloom', style: Theme.of(ctx).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  const Text('Your safe space for women\'s healthcare.'),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(hintText: 'Mobile number', prefixText: '+91 '),
                  ),
                  const SizedBox(height: 12),
                  if (s.otpSent) ...[
                    TextField(
                      controller: _otp,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: 'Enter OTP (dev: 123456)'),
                    ),
                    const SizedBox(height: 12),
                  ],
                  AppButton(
                    label: s.otpSent ? 'Verify & Continue' : 'Send OTP',
                    loading: s.loading,
                    onPressed: () {
                      final cubit = ctx.read<AuthCubit>();
                      s.otpSent
                          ? cubit.verify(_phone.text, _otp.text)
                          : cubit.sendOtp(_phone.text);
                    },
                  ),
                  TextButton(
                    onPressed: () => ctx.push('/register'),
                    child: const Text('New here? Create an account'),
                  ),
                  const Spacer(),
                  Center(child: Text('🔒 Your data is encrypted and private',
                      style: TextStyle(color: AppColors.inkSoft.withOpacity(.8), fontSize: 12))),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}