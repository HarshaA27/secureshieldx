import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  FirebaseAuth? get _auth {
    try {
      return FirebaseAuth.instance;
    } catch (e) {
      debugPrint('FirebaseAuth instance unavailable: $e');
      return null;
    }
  }

  User? get currentUser => _auth?.currentUser;

  Stream<User?> get authStateChanges => _auth?.authStateChanges() ?? Stream.value(null);

  /// Triggers Firebase Phone Number Verification & sends SMS OTP
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) onCodeSent,
    required Function(String verificationId) onCodeAutoRetrievalTimeout,
    required Function(FirebaseAuthException exception) onVerificationFailed,
    required Function(PhoneAuthCredential credential) onVerificationCompleted,
  }) async {
    final auth = _auth;
    if (auth == null) {
      debugPrint('Firebase Auth disabled. Simulating OTP dispatch for $phoneNumber.');
      onCodeSent('dummy_ver_id_12345', 1234);
      return;
    }

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          debugPrint('Firebase Auth: Verification completed automatically.');
          try {
            await auth.signInWithCredential(credential);
          } catch (_) {}
          onVerificationCompleted(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          debugPrint('Firebase Auth Error: ${e.code} - ${e.message}');
          onVerificationFailed(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          debugPrint('Firebase Auth: SMS OTP code sent to $phoneNumber.');
          onCodeSent(verificationId, resendToken);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          debugPrint('Firebase Auth: Code auto retrieval timed out.');
          onCodeAutoRetrievalTimeout(verificationId);
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      debugPrint('Firebase Auth verifyPhoneNumber exception: $e');
      onCodeSent('dummy_ver_id_12345', 1234);
    }
  }

  /// Verifies OTP code entered by user with Firebase PhoneAuthCredential
  Future<UserCredential?> signInWithOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final auth = _auth;
    if (auth == null || verificationId == 'dummy_ver_id_12345') {
      debugPrint('Simulating OTP verification for offline / fallback mode.');
      return null;
    }

    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    return await auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await _auth?.signOut();
  }
}
