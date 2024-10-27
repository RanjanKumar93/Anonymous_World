import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FirebaseFirestore _firebaseFirestore;

  HomeBloc({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore,
        super(HomeStateInitial()) {
    on<HomeEventFetchUsers>((event, emit) async {
      emit(HomeStateLoading());
      try {
        // Fetch users from Firestore
        QuerySnapshot querySnapshot = await _firebaseFirestore.collection('users').get();
        // Extract user UIDs from the documents
        List<String> users = querySnapshot.docs.map((doc) => doc['uid'].toString()).toList();
        emit(HomeStateLoaded(users));
      } catch (e) {
        emit(HomeStateError());
      }
    });
  }
}
