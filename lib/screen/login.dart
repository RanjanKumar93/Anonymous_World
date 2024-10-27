import 'package:anonymous_world/state/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Anonymous World',
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthStateUninitialized) {
              return const Text('Initializing...');
            } else if (state is AuthStateLoading) {
              return const CircularProgressIndicator();
            } else if (state is AuthStateError) {
              return Column(
                children: [
                  const Text("Error Entering"),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthEventLogin());
                    },
                    child: const Text('Enter'),
                  )
                ],
              );
            }
            return ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthEventLogin());
              },
              child: const Text('Enter'),
            );
          },
        ),
      ),
    );
  }
}
