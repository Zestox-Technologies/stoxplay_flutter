// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:sms_autofill/sms_autofill.dart';
//
// class PhoneAuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   String? _verificationId;
//   Function(String)? onVerificationCompleted;
//   Function(String)? onVerificationFailed;
//   Function()? onCodeSent;
//
//   // Step 1: Send OTP
//   Future<void> sendOTP({
//     required String phoneNumber,
//     Function(String)? onCompleted,
//     Function(String)? onFailed,
//     Function()? onSent,
//   }) async {
//     onVerificationCompleted = onCompleted;
//     onVerificationFailed = onFailed;
//     onCodeSent = onSent;
//
//     await _auth.verifyPhoneNumber(
//       phoneNumber: phoneNumber,
//       timeout: const Duration(seconds: 60),
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         try {
//           // Auto sign-in (Android only)
//           await _auth.signInWithCredential(credential);
//           onVerificationCompleted?.call('Auto verification completed');
//         } catch (e) {
//           onVerificationFailed?.call(e.toString());
//         }
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         print('Verification failed: ${e.message}');
//         onVerificationFailed?.call(e.message ?? 'Verification failed');
//       },
//       codeSent: (String verificationId, int? resendToken) {
//         _verificationId = verificationId;
//         print('OTP sent. Verification ID: $_verificationId');
//         onCodeSent?.call();
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         _verificationId = verificationId;
//         print('Auto retrieval timeout');
//       },
//     );
//   }
//
//   // Step 2: Verify OTP
//   Future<bool> verifyOTP(String smsCode) async {
//     try {
//       if (_verificationId == null) {
//         throw Exception('No verification ID found. Please resend OTP.');
//       }
//
//       final credential = PhoneAuthProvider.credential(
//         verificationId: _verificationId!,
//         smsCode: smsCode,
//       );
//
//       await _auth.signInWithCredential(credential);
//       return true;
//     } catch (e) {
//       print('OTP verification failed: $e');
//       return false;
//     }
//   }
//
//   // Optional: Sign out
//   Future<void> signOut() async {
//     await _auth.signOut();
//   }
//
//   // Dispose SMS listener
//   void dispose() {
//     SmsAutoFill().unregisterListener();
//   }
//
//   // Get app signature for SMS autofill
//   Future<String> getAppSignature() async {
//     return await SmsAutoFill().getAppSignature;
//   }
// }
