import 'package:collingo/presentation/auth/blocs/auth/auth_cubit.dart';
import 'package:collingo/presentation/auth/blocs/auth/auth_state.dart';
import 'package:collingo/presentation/auth/components/secondary_button.dart';
import 'package:collingo/presentation/auth/pages/change_password_page.dart'; 
import 'package:collingo/presentation/auth/widgets/code_textfield.dart';
import 'package:flutter/material.dart';
import 'package:collingo/presentation/auth/components/primary_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyCode extends StatefulWidget {
  @override
  _VerifyCodeState createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  final TextEditingController codeController = TextEditingController();
  bool codeError = false;
  String codeErrorMessage = '';

  @override
  void initState() {
    super.initState();

    codeController.addListener(() {
      setState(() {
        codeError = false;
        codeErrorMessage = '';
      });
    });
  }

  void _onOkPressed() {
    // Check if the code is 6 digits
    if (codeController.text.length != 6 || !RegExp(r'^\d{6}$').hasMatch(codeController.text)) {
      setState(() {
        codeError = true;
        codeErrorMessage = 'Please enter a valid 6-digit code.';
      });
      return;
    }

    // If code is valid, verify and then navigate to ChangePasswordPage
    context.read<AuthCubit>().verifyResetCode(codeController.text);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final email = context.read<AuthCubit>().email;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => ChangePasswordPage()),
            );
            codeController.clear();
          } else if (state is AuthFailure) {
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
                'We\'ve sent a code to your email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                'Enter the 6-digit code sent to your $email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: screenHeight * 0.1),
              CodeTextField(
                controller: codeController,
                errorText: codeError ? codeErrorMessage : null,
              ),
              SizedBox(height: screenHeight * 0.1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: SecondaryButton(
                      text: 'Go back',
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Expanded(
                    child: PrimaryButton(
                      text: 'Continue',
                      onPressed: _onOkPressed,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}
