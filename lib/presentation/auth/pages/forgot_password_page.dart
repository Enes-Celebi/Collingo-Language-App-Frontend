import 'package:collingo/presentation/auth/blocs/auth/auth_cubit.dart';
import 'package:collingo/presentation/auth/blocs/auth/auth_state.dart';
import 'package:collingo/presentation/auth/pages/verify_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:collingo/presentation/auth/components/primary_button.dart';
import 'package:collingo/presentation/auth/components/primary_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  bool emailError = false;
  String emailErrorMessage = '';

  @override
  void initState() {
    super.initState();

    emailController.addListener(() {
      setState(() {
        emailError = false;
        emailErrorMessage = '';
      });
    }); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => VerifyCode()),
            );
            emailController.clear();
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 150),
              Text(
                'Forgot password?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "No worries, we'll send reset instructions",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 40),
              PrimaryTextField(
                controller: emailController,
                labelText: 'Email',
                obscureText: false,
                hasError: emailError,
                errorMessage: emailErrorMessage,
              ),
              SizedBox(height: 30),
              PrimaryButton(
                text: 'Reset password',
                onPressed: () {
                  setState(() {
                    emailError = false;
                    emailErrorMessage = '';

                    if (emailController.text.isEmpty) {
                      emailError = true;
                      emailErrorMessage = "This field is required";
                    }
                  });
                  
                  if (!emailError) {
                    // Calling the Cubit to send the email for password reset
                    BlocProvider.of<AuthCubit>(context).requestPasswordChange(
                      emailController.text,  // Passing the email to the Cubit
                    );
                  }
                },
              ),
              SizedBox(height: 40),
              SvgPicture.asset(
                'assets/image/svg/forgot_password.svg',
                width: 200,
                height: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
