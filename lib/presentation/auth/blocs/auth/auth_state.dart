import 'package:collingo/core/models/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;
  final UserModel? user; 
  final String? email;

  AuthSuccess({required this.message, this.user, this.email}); 
}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure({required this.message});
}