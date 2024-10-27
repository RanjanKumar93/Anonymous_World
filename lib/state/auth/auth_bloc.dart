import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  AuthBloc(
      {required FirebaseAuth firebaseAuth,
      required FirebaseFirestore firebaseFirestore})
      : _firebaseAuth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore,
        super(AuthStateUninitialized()) {
    on<AuthEventCheck>((event, emit) async {
      await Future.delayed(const Duration(seconds: 3));
      try {
        final user = _firebaseAuth.currentUser;

        if (user != null) {
          emit(AuthStateAuthenticated(user.uid));
        } else {
          emit(AuthStateLogout());
        }
      } catch (e) {
        emit(AuthStateError());
      }
    });

    on<AuthEventLogin>((event, emit) async {
      emit(AuthStateLoading());
      try {
        final userCredential = await FirebaseAuth.instance.signInAnonymously();
        emit(AuthStateAuthenticated(userCredential.user?.uid ?? 'Unknown'));

        if (userCredential.user != null) {
          try {
            await _firebaseFirestore
                .collection('users')
                .doc(userCredential.user?.uid)
                .set({
              'uid': userCredential.user?.uid,
              'loginTimestamp':
                  FieldValue.serverTimestamp(), // Store the login time
            });

            // Future.delayed(const Duration(days: 1), () async {
            //   // Log out user and delete their Firestore data
            //   await _firebaseAuth.signOut();
            //   await _firebaseFirestore
            //       .collection('users')
            //       .doc(userCredential.user?.uid)
            //       .delete();
            //   emit(AuthStateLogout());
            // });
          } catch (e) {
            throw Exception(e);
          }
        }
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "operation-not-allowed":
            emit(AuthStateError());
            break;
          default:
            emit(AuthStateError());
            break;
        }
      }
    });

    // on<AuthEventLogin>((event, emit) async {
    //   emit(AuthStateLoading());
    //   try {
    //     final userCredential = await FirebaseAuth.instance.signInAnonymously();
    //     emit(AuthStateAuthenticated(userCredential.user?.uid ?? 'Unknown'));
    //     if (userCredential.user != null) {
    //       try {
    //         await _firebaseFirestore
    //             .collection('users')
    //             .doc(userCredential.user?.uid)
    //             .set({
    //           'uid': userCredential.user?.uid,
    //         });
    //       } catch (e) {
    //         throw Exception(e);
    //       }
    //     }
    //   } on FirebaseAuthException catch (e) {
    //     switch (e.code) {
    //       case "operation-not-allowed":
    //         emit(AuthStateError());
    //         break;
    //       default:
    //         emit(AuthStateError());
    //         break;
    //     }
    //   }
    // });
    on<AuthEventLogout>((event, emit) async {
      // Handle logout
      emit(AuthStateLoading());
      try {
        final user = _firebaseAuth.currentUser;
        if (user != null) {
          // Delete the user from Firestore before logging out
          await _firebaseFirestore.collection('users').doc(user.uid).delete();
        }

        // Sign out the user from Firebase Authentication
        await _firebaseAuth.signOut();
        emit(AuthStateLogout());
      } catch (e) {
        emit(AuthStateError());
      }
    });
  }
}
