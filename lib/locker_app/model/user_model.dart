import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String user_id;
  final String token;

  const UserModel({
    required this.user_id,
    required this.token,
  });

  static UserModel fromSnapshot(DocumentSnapshot snap) {
    return UserModel(
      user_id: snap['user_id'],
      token: snap['token'],
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      user_id: json['id'] ?? "",
      token: json['token'] ?? "",
    );
  }
}
