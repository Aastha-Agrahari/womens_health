import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widget/app_button.dart';

/// Registration is intentionally lightweight in dev:
/// - collects profile details locally (no backend yet)
/// - sends OTP (mock: 123456)
/// - on success, marks as authenticated via AuthCubit
/// All fields are wired so swapping to a real API is a 1-line change.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _otp = TextEditingController();
  DateTime? _dob;
  String _pregnant = 'no';
  bool _stepOtp = false;
  bool _loading = false;

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() { _loading = false; _stepOtp = true; });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP sent. Use 123456 (dev).')),
    );
  }

  Future<void> _verify() async {
    if (_otp.text != '123456') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP. Use 123456 in dev.')),
      );
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    // In real app: POST /auth/register → token → AuthCubit.authenticated = true
    context.go('/home');
  }

  Future<void> _pickDob() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _dob = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create your account')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SizedBox(height: 8),
              if (!_stepOtp) ...[
                Text(
                  'Tell us a bit about you',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _name,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Full name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (v) =>
                  (v == null || v.trim().length < 3) ? 'Enter your name' : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    labelText: 'Mobile number',
                    prefixText: '+91 ',
                    counterText: '',
                    prefixIcon: Icon(Icons.phone_iphone),
                  ),
                  validator: (v) =>
                  (v == null || v.length != 10) ? 'Enter 10-digit number' : null,
                ),
                const SizedBox(height: 14),
                InkWell(
                  onTap: _pickDob,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date of birth',
                      prefixIcon: Icon(Icons.cake_outlined),
                    ),
                    child: Text(
                      _dob == null
                          ? 'Select your birth date'
                          : DateFormat('MMM d, yyyy').format(_dob!),
                      style: TextStyle(
                        color: _dob == null ? AppColors.inkSoft : AppColors.ink,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Are you currently pregnant?',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ChoiceChip(
                      label: const Text('No'),
                      selected: _pregnant == 'no',
                      onSelected: (_) => setState(() => _pregnant = 'no'),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Yes'),
                      selected: _pregnant == 'yes',
                      onSelected: (_) => setState(() => _pregnant = 'yes'),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text("I'd rather not say"),
                      selected: _pregnant == 'skip',
                      onSelected: (_) => setState(() => _pregnant = 'skip'),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                AppButton(
                  label: 'Continue',
                  loading: _loading,
                  onPressed: _sendOtp,
                ),
              ] else ...[
                Text(
                  'Verify your number',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text('A 6-digit code was sent to +91 ${_phone.text}'),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _otp,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22, letterSpacing: 10),
                  decoration: const InputDecoration(
                    hintText: '••••••',
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => setState(() => _stepOtp = false),
                  child: const Text('Change number'),
                ),
                const SizedBox(height: 16),
                AppButton(
                  label: 'Verify & create account',
                  loading: _loading,
                  onPressed: _verify,
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    'Dev OTP: 123456',
                    style: TextStyle(fontSize: 12, color: AppColors.inkSoft),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              const Text(
                'By continuing you agree to our Terms & Privacy Policy. '
                    'We never share your medical data.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.inkSoft),
              ),
            ],
          ),
        ),
      ),
    );
  }
}