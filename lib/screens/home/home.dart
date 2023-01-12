import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intern_assignment/bloc/authentication/authentication_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context, listen: false)
                    .add(LogoutEvent());
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: const Center(
        child: Text('This is home Screen'),
      ),
    );
  }
}
