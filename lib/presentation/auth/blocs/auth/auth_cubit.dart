import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_state.dart';
import '../../../../infrastructure/repositories/auth_repository.dart';
import '../../../../core/models/user_model.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  final _storage = FlutterSecureStorage();
  String? _lastSuccessfulEmail;
  String? _verifiedCode;

  AuthCubit(this.authRepository) : super(AuthInitial());

  
  Future<void> checkAuthentication() async {
    emit(AuthLoading());
    try {
      final user = await authRepository.authenticateWithToken();
      if (user != null) {
        emit(AuthSuccess(message: 'Successfully authenticated with token!', user: user));
      } else {
        emit(AuthFailure(message: 'No valid token found. Please log in'));
      }
    } catch (e) {
      print("Authentication error: $e");
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final UserModel user = await authRepository.login(email, password);
      
      await _storage.write(key: 'isLoggedIn', value: 'true');
      
      emit(AuthSuccess(message: 'Successfully logged in!', user: user));
    } catch (e) {
      print("Login error: $e");
      emit(AuthFailure(message: e.toString())); 
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await authRepository.logout();
      emit(AuthSuccess(message: 'Successfully logged out!'));
    } catch (e) {
      print("Logout error: $e");
      emit(AuthFailure(message: 'Failed to log out.'));
    }
  }

  Future<void> register(String email, String name, String password) async {
    emit(AuthLoading());
    try {
      await authRepository.register(email, name, password);
      emit(AuthSuccess(message: 'Successfully registered! Please verify your email.', user: null));
    } catch (e) {
      print("Register error: $e"); 
      emit(AuthFailure(message: e.toString())); 
    }
  }

  Future<void> signInWithGoogle(String token) async {
    emit(AuthLoading());
    try {
      final UserModel user = await authRepository.signInWithGoogle(token);
      emit(AuthSuccess(message: 'Successfully logged in with Google!', user: user));
    } catch (e) {
      print("Google Sign-In error: $e");
      emit(AuthFailure(message: e.toString())); 
    }
  }

  Future<void> resendVerificationEmail(String email) async {
    emit(AuthLoading()); 
    try {
      await authRepository.resendVerificationEmail(email);  
      emit(AuthSuccess(message: 'Verification email sent!')); 
    } catch (e) {
      print("Resend verification error: $e"); 
      emit(AuthFailure(message: 'Failed to resend verification email.')); 
    }
  }

  Future<void> requestPasswordChange(String email) async {
    emit(AuthLoading());
    try {
      _lastSuccessfulEmail = email;
      await authRepository.requestPasswordChange(email);
      emit(AuthSuccess(message: 'Successfully sent verification code!'));
    } catch (e) {
      print('send verification code error: $e');
      emit(AuthFailure(message: 'Failed to send verification code.'));
    }
  }

  Future<void> verifyResetCode(String code) async {
    if (_lastSuccessfulEmail == null) {
      emit(AuthFailure(message: 'Email not found!'));
      return;
    }
    emit(AuthLoading());
    try {
      _verifiedCode = code;
      await authRepository.verifyResetCode(_lastSuccessfulEmail!, code);
      emit(AuthSuccess(message: 'Successfully verified code!'));
    } catch (e) {
      print('Code verification error: $e');
      emit(AuthFailure(message: 'Failed verify code'));
    }
  }

  String? get email => _lastSuccessfulEmail;
  String? get code => _verifiedCode;

  Future<void> resetPasswordWithCode(String newPassword) async {
    if (_lastSuccessfulEmail == null || _verifiedCode == null) {
      emit(AuthFailure(message: 'Couldn\'t verify email or code'));
      return;
    }
    emit(AuthLoading());
    try {
      await authRepository.resetPasswordWithCode(_lastSuccessfulEmail!, _verifiedCode!, newPassword);
      emit(AuthSuccess(message: 'Successfully reset password!'));
    } catch (e) {
      print('Code verification error: $e');
      emit(AuthFailure(message: 'Failed to reset password'));
    }
  }
}