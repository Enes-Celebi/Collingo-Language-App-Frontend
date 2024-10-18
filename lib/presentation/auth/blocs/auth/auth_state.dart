import 'package:collingo/core/models/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;
  final UserModel? user; 

  AuthSuccess({required this.message, this.user}); 
}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure({required this.message});
}