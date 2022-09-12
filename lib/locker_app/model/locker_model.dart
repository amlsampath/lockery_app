import 'package:cloud_firestore/cloud_firestore.dart';

class LockerModel {
  final String id;
  final String location;
  final String fees;
  final bool isAvailable;

  const LockerModel({
    required this.id,
    required this.location,
    required this.fees,
    required this.isAvailable,
  });

  static LockerModel fromSnapshot(DocumentSnapshot snap) {
    return LockerModel(
      id: snap['id'],
      location: snap['location'],
      fees: snap['fee'],
      isAvailable: snap['isAvailable'],
    );
  }

  factory LockerModel.fromJson(Map<String, dynamic> json) {
    return LockerModel(
      id: json['id'] ?? "",
      location: json['location'] ?? "",
      fees: json['fee'] ?? "0.0",
      isAvailable: json['is_available'] ?? true,
    );
  }

  List<Object> get props => [
        id,
        location,
        fees,
        isAvailable,
      ];
}
