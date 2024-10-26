import 'package:collingo/infrastructure/dtos/auth_remote_dto.dart';
import '../../core/models/user_model.dart';

class AuthRepository {
  final AuthRemoteDTO remoteDTO;

  AuthRepository({required this.remoteDTO});

  Future<UserModel> register(String email, String name, String password) {
    return remoteDTO.register(email, name, password);
  }

  Future<UserModel> login(String email, String password) {
    return remoteDTO.login(email, password);
  }

  Future<UserModel> signInWithGoogle(String token) {
    return remoteDTO.signInWithGoogle(token);
  }

  Future<void> resendVerificationEmail(String email) {
    return remoteDTO.resendVerificationEmail(email);
  }

  Future<void> requestPasswordChange(String email) {
    return remoteDTO.requestPasswordChange(email);
  }

  Future<void> verifyResetCode(String email, String code) {
    return remoteDTO.verifyResetCode(email, code);
  }

  Future<void> resetPasswordWithCode(String email, String code, String newPassword) {
    return remoteDTO.resetPasswordWithCode(email, code, newPassword);
  }
}