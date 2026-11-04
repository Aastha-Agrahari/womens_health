
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:womens_health/features/auth/auth_cubit.dart';
import 'package:womens_health/features/auth/auth_repository.dart';
import 'package:womens_health/features/auth/login_page.dart';

// Fake repository for testing
class FakeAuthRepository implements AuthRepository {
  @override
  Future<void> requestOtp(String phone) async {
    return;
  }

  @override
  Future<String> verifyOtp(String phone, String otp) async {
    if (otp != '123456') {
      throw Exception('Invalid OTP');
    }
    return 'test.access.token';
  }

  @override
  Future<void> logout() async {
    return;
  }
}

void main() {
  testWidgets('Bloom Login page loads successfully',
          (WidgetTester tester) async {

        await tester.pumpWidget(
          BlocProvider<AuthCubit>(
            create: (_) => AuthCubit(FakeAuthRepository()),
            child: const MaterialApp(
              home: LoginPage(),
            ),
          ),
        );

        expect(find.text('Welcome to Bloom'), findsOneWidget);
        expect(find.text('Send OTP'), findsOneWidget);
        expect(find.text('Your safe space for women\'s healthcare.'),
            findsOneWidget);
      });
}
