import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthRepository {
  Future<void> requestOtp(String phone);
  Future<String> verifyOtp(String phone, String otp); // returns token
  Future<void> logout();
}

class MockAuthRepository implements AuthRepository {
  final _store = const FlutterSecureStorage();

  @override
  Future<void> requestOtp(String phone) async {
    await Future.delayed(const Duration(milliseconds: 600));
    // Dev only: OTP is always 123456
  }

  @override
  Future<String> verifyOtp(String phone, String otp) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (otp != '123456') throw Exception('Invalid OTP. Use 123456 in dev.');
    const token = 'dev.access.token';
    await _store.write(key: 'access_token', value: token);
    return token;
  }

  @override
  Future<void> logout() => _store.delete(key: 'access_token');
}