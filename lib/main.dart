import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intern_assignment/bloc/vidoe/video_bloc.dart';
import 'package:intern_assignment/screens/authentication/login_screen.dart';
import 'package:intern_assignment/screens/home/home.dart';
import 'bloc/authentication/authentication_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthenticationBloc()),
        BlocProvider(create: ((context) => VideoBloc()))
      ],
      child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: ((context, streamsnapshot) {
            if (streamsnapshot.connectionState == ConnectionState.waiting) {
              return const MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              if (streamsnapshot.data == null) {
                return const MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: LoginScreen(),
                );
              } else {
                return const MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: HomeScreen(),
                );
              }
            }
          })),
    );
  }
}
