import 'package:collingo/presentation/auth/blocs/auth/auth_cubit.dart';
import 'package:collingo/presentation/auth/blocs/auth/auth_state.dart';
import 'package:collingo/presentation/auth/components/primary_button.dart';
import 'package:collingo/presentation/auth/components/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart'; 

class EmailVerificationPage extends StatelessWidget {
  final String email;

  const EmailVerificationPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Your Email'),
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Verification email resent successfully!')),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/image/svg/email_sent.svg',
                height: 200,
              ),
              SizedBox(height: 20),
              Text(
                'A verification email has been sent to $email. Please verify your email address.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              PrimaryButton(
                text: 'Login',
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
              SizedBox(height: 10),
              SecondaryButton(
                text: 'Resend Email',
                onPressed: () {
                  BlocProvider.of<AuthCubit>(context).resendVerificationEmail(email);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
