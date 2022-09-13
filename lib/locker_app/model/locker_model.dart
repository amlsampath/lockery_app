import 'package:cloud_firestore/cloud_firestore.dart';

class LockerModel {
  final String id;
  final String location;
  final String fees;
  final String rack_number;
  final bool isAvailable;

  const LockerModel({
    required this.id,
    required this.location,
    required this.fees,
    required this.rack_number,
    required this.isAvailable,
  });

  static LockerModel fromSnapshot(DocumentSnapshot snap) {
    return LockerModel(
      id: snap['id'],
      location: snap['location'],
      fees: snap['fee'],
      rack_number: snap['rack_number'],
      isAvailable: snap['isAvailable'],
    );
  }

  factory LockerModel.fromJson(Map<String, dynamic> json) {
    return LockerModel(
      id: json['id'] ?? "",
      location: json['location'] ?? "",
      fees: json['fee'] ?? "0.0",
      rack_number: json['rack_number'],
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
