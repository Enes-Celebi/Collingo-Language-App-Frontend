import 'package:collingo/presentation/home/pages/home_page.dart';
import 'package:collingo/presentation/themes/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collingo/presentation/auth/blocs/auth/auth_cubit.dart';
import 'package:collingo/presentation/auth/blocs/auth/auth_state.dart';
import 'package:collingo/presentation/auth/components/primary_button.dart';
import 'package:collingo/presentation/auth/components/primary_text_field.dart';
import 'package:collingo/presentation/auth/components/google_sign_in_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool emailError = false;
  bool passwordError = false;

  String emailErrorMessage = '';
  String passwordErrorMessage = '';

  @override
  void initState() {
    super.initState();

    emailController.addListener(() {
      setState(() {
        emailError = false;
        emailErrorMessage = '';
      });
    });

    passwordController.addListener(() {
      setState(() {
        passwordError = false;
        passwordErrorMessage = '';
      });
    });
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
              MaterialPageRoute(
                builder: (context) => HomePage(username: state.user!.name),
              ),
            );
          } else if (state is AuthFailure) {
            setState(() {
              if (state.message.contains("Invalid password")) {
                passwordError = true;
                passwordErrorMessage = state.message;
              } else if (state.message.contains("Invalid user")) {
                emailError = true;
                emailErrorMessage = state.message;
              } else {
                emailError = true; 
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
                  'Log in',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 70),

              PrimaryTextField(
                controller: emailController,
                labelText: 'Email',
                obscureText: false,
                hasError: emailError,
                errorMessage: emailErrorMessage,
              ),
              SizedBox(height: 20),

              PrimaryTextField(
                controller: passwordController,
                labelText: 'Password',
                obscureText: true,
                hasError: passwordError,
                errorMessage: passwordErrorMessage,
              ),
              SizedBox(height: 30),

              PrimaryButton(
                text: 'Login',
                onPressed: () {
                  setState(() {
                    emailError = false;
                    passwordError = false;
                    emailErrorMessage = '';
                    passwordErrorMessage = '';

                    if (emailController.text.isEmpty) {
                      emailError = true;
                      emailErrorMessage = "This field is required";
                    }

                    if (passwordController.text.isEmpty) {
                      passwordError = true;
                      passwordErrorMessage = "This field is required";
                    }
                  });

                  if (!emailError && !passwordError) {
                    BlocProvider.of<AuthCubit>(context).login(
                      emailController.text,
                      passwordController.text,
                    );
                  }
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
                    Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/register');
                      },
                      child: Text(
                        'Create one',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              PrimaryButton(
                text: 'Toggle Theme',
                onPressed: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}