import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';
import '../../../../infrastructure/repositories/auth_repository.dart';
import '../../../../core/models/user_model.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  String? _lastSuccessfulEmail;

  AuthCubit(this.authRepository) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final UserModel user = await authRepository.login(email, password);
      emit(AuthSuccess(message: 'Successfully logged in!', user: user));
    } catch (e) {
      print("Login error: $e");
      emit(AuthFailure(message: e.toString())); 
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
      emit(AuthFailure(message: 'Email no tfound!'));
      return;
    }
    emit(AuthLoading());
    try {
      await authRepository.verifyResetCode(_lastSuccessfulEmail!, code);
      emit(AuthSuccess(message: 'Successfully verified code!'));
    } catch (e) {
      print('Code verification error: $e');
      emit(AuthFailure(message: 'Failed verify code'));
    }
  }

  String? get email => _lastSuccessfulEmail;
}