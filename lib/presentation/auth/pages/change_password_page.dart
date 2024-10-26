import 'package:collingo/presentation/auth/blocs/auth/auth_cubit.dart';
import 'package:collingo/presentation/auth/blocs/auth/auth_state.dart';
import 'package:collingo/presentation/auth/components/primary_button.dart';
import 'package:collingo/presentation/auth/components/primary_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isPasswordError = false;
  bool isConfirmPasswordError = false;

  String passwordErrorMessage = '';
  String confirmPasswordErrorMessage = '';

  @override
  void initState() {
    super.initState();

    passwordController.addListener(() {
      setState(() {
        isPasswordError = false;
        passwordErrorMessage = '';
      });
    });

    confirmPasswordController.addListener(() {
      setState(() {
        isConfirmPasswordError = false;
        confirmPasswordErrorMessage = '';
      });
    });
  }

  void _onResetPasswordPressed() {
    setState(() {
      isPasswordError = passwordController.text.isEmpty;
      passwordErrorMessage = 'This field is required';

      isConfirmPasswordError = confirmPasswordController.text.isEmpty;
      confirmPasswordErrorMessage = 'This field is required';

      isConfirmPasswordError = confirmPasswordController.text.isEmpty || passwordController.text != confirmPasswordController.text;
      confirmPasswordErrorMessage = passwordController.text != confirmPasswordController.text
        ? 'Passwords do not match'
        : 'This field is required';
    });

    if (!isPasswordError && !isConfirmPasswordError) {
      context.read<AuthCubit>().resetPasswordWithCode(passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          }
        ),
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushReplacementNamed(context, '/login');
            passwordController.clear();
            confirmPasswordController.clear();
          }
          else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Enter your new password',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              PrimaryTextField(
                controller: passwordController, 
                labelText: 'New password', 
                obscureText: false
              ),
              SizedBox(height: screenHeight * 0.01),
              PrimaryTextField(
                controller: confirmPasswordController, 
                labelText: 'Confirm new password', 
                obscureText: false
              ),
              SizedBox(height: screenHeight * 0.1),
              PrimaryButton(
                text: 'Reset password', 
                onPressed: _onResetPasswordPressed
              )
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}