import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final DateTime loginTimestamp;

  UserModel({required this.uid, required this.loginTimestamp});

  // Factory method to create a User from Firestore document
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      uid: doc['uid'],
      // Assuming the timestamp is stored as a Firestore Timestamp and needs to be converted to DateTime
      loginTimestamp: (doc['loginTimestamp'] as Timestamp).toDate(),
    );
  }
}
