import 'package:collingo/presentation/themes/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http; 
import 'infrastructure/dtos/auth_remote_dto.dart'; 
import 'infrastructure/repositories/auth_repository.dart';
import 'presentation/auth/blocs/auth/auth_cubit.dart';
import 'presentation/auth/pages/login_page.dart';
import 'presentation/auth/pages/registration_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final http.Client httpClient = http.Client();

    final AuthRemoteDTO authRemoteDTO = AuthRemoteDTO(client: httpClient);

    final AuthRepository authRepository = AuthRepository(remoteDTO: authRemoteDTO);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(authRepository),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(), 
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Language Learning App',
            theme: themeState.themeData,
            initialRoute: '/login',
            routes: {
              '/login': (context) => LoginPage(),
              '/register': (context) => RegistrationPage(),
            },
          );
        },
      ),
    );
  }
}