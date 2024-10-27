import 'package:collingo/presentation/auth/blocs/auth/auth_state.dart';
import 'package:collingo/presentation/auth/pages/forgot_password_page.dart';
import 'package:collingo/presentation/themes/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'infrastructure/dtos/auth_remote_dto.dart';
import 'infrastructure/repositories/auth_repository.dart';
import 'presentation/auth/blocs/auth/auth_cubit.dart';
import 'presentation/auth/pages/login_page.dart';
import 'presentation/auth/pages/registration_page.dart';
import 'presentation/home/pages/home_page.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final http.Client httpClient = http.Client();
  final AuthRemoteDTO authRemoteDTO = AuthRemoteDTO(client: httpClient);
  final AuthRepository authRepository = AuthRepository(remoteDTO: authRemoteDTO);

  runApp(MyApp(authRepository: authRepository)); 
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;

  const MyApp({super.key, required this.authRepository}); 
  
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(authRepository)..checkAuthentication(), 
        ),
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
      ],
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          return MaterialApp(
            title: 'Language Learning App',
            theme: context.watch<ThemeCubit>().state.themeData,
            home: _getHomeWidget(authState), 
            routes: {
              '/login': (context) => LoginPage(),
              '/register': (context) => RegistrationPage(),
              '/forgotPassword': (context) => ForgotPasswordPage(),
            },
          );
        },
      ),
    );
  }

  Widget _getHomeWidget(AuthState authState) {
    if (authState is AuthSuccess) {
      return HomePage(username: authState.user?.name);
    } else {
      return LoginPage(); 
    }
  }
}
