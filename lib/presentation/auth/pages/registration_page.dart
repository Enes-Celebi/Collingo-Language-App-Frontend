import 'package:collingo/presentation/auth/blocs/auth/auth_cubit.dart';
import 'package:collingo/presentation/auth/blocs/auth/auth_state.dart';
import 'package:collingo/presentation/auth/components/google_sign_in_service.dart';
import 'package:collingo/presentation/auth/components/primary_button.dart';
import 'package:collingo/presentation/auth/components/primary_text_field.dart';
import 'package:collingo/presentation/auth/pages/email_verification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isNameError = false;
  bool isEmailError = false;
  bool isPasswordError = false;
  bool isConfirmPasswordError = false;
  
  String nameErrorMessage = '';
  String emailErrorMessage = '';
  String passwordErrorMessage = '';
  String confirmPasswordErrorMessage = '';

  @override
  void initState() {
    super.initState();

    nameController.addListener(() {
      setState(() {
        isNameError = false;
        nameErrorMessage = '';
      });
    });

    emailController.addListener(() {
      setState(() {
        isEmailError = false;
        emailErrorMessage = '';
      });
    });

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

  void _validateAndRegister(BuildContext context) {
    setState(() {
      isNameError = nameController.text.isEmpty;
      nameErrorMessage = 'This field is required';

      isEmailError = emailController.text.isEmpty;
      emailErrorMessage = 'This field is required';

      isPasswordError = passwordController.text.isEmpty;
      passwordErrorMessage = 'This field is required';

      isConfirmPasswordError = confirmPasswordController.text.isEmpty || passwordController.text != confirmPasswordController.text;
      confirmPasswordErrorMessage = passwordController.text != confirmPasswordController.text
          ? 'Passwords do not match'
          : 'This field is required';
    });

    if (!isNameError && !isEmailError && !isPasswordError && !isConfirmPasswordError) {
      BlocProvider.of<AuthCubit>(context).register(
        emailController.text,
        nameController.text,
        passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => EmailVerificationPage(email: emailController.text))
            );
          }
          else if (state is AuthFailure) {
            setState(() {
              isEmailError = false;
              isPasswordError = false;
              isConfirmPasswordError = false;

              if (state.message.contains('email')) {
                isEmailError = true;
                emailErrorMessage = state.message;
              } else if (state.message.contains('Password must')) {
                isPasswordError = true;
                passwordErrorMessage = state.message;
              } else {
                isEmailError = true; 
                emailErrorMessage = state.message;
              }
            });
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 150),
                child: Text(
                  'Sign up',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 70),

              PrimaryTextField(
                controller: nameController,
                labelText: 'Name',
                obscureText: false,
                hasError: isNameError,
                errorMessage: nameErrorMessage,
              ),
              SizedBox(height: 20),

              PrimaryTextField(
                controller: emailController,
                labelText: 'Email',
                obscureText: false,
                hasError: isEmailError,
                errorMessage: emailErrorMessage,
              ),
              SizedBox(height: 20),

              PrimaryTextField(
                controller: passwordController,
                labelText: 'Password',
                obscureText: true,
                hasError: isPasswordError,
                errorMessage: passwordErrorMessage,
              ),
              SizedBox(height: 20),

              PrimaryTextField(
                controller: confirmPasswordController,
                labelText: 'Confirm Password',
                obscureText: true,
                hasError: isConfirmPasswordError,
                errorMessage: confirmPasswordErrorMessage,
              ),
              SizedBox(height: 30),

              PrimaryButton(
                text: 'Register',
                onPressed: () {
                  _validateAndRegister(context);
                },
              ),
              SizedBox(height: 20),

              Row(
                children: [
                  Expanded(child: Divider(thickness: 1, color: Colors.grey[400])),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text("or", style: TextStyle(color: Colors.grey[600])),
                  ),
                  Expanded(child: Divider(thickness: 1, color: Colors.grey[400])),
                ],
              ),
              SizedBox(height: 20),

              PrimaryButton(
                text: 'Continue with Google',
                onPressed: () => GoogleSignInService().signInWithGoogle(context),
              ),
              SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Text(
                        'Log in',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}