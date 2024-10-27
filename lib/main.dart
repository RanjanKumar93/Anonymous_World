import 'package:anonymous_world/routes/routes.dart';
import 'package:anonymous_world/state/auth/auth_bloc.dart';
import 'package:anonymous_world/state/home/home_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:go_router/go_router.dart';
import 'firebase_options.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseInstance = FirebaseAuth.instance;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            lazy: false,
            create: (context) =>
                AuthBloc(firebaseAuth: firebaseInstance, firebaseFirestore: db)
                  ..add(AuthEventCheck())),
        BlocProvider(
            lazy: false, create: (context) => HomeBloc(firebaseFirestore: db)),
      ],
      child: MaterialApp.router(
        title: 'Anonymous World',
        theme: ThemeData.dark(),
        routerConfig: routerConfig,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              routerState.changeAuthState(state);
            },
            child: child,
          );
        },
      ),
    );
  }
}
