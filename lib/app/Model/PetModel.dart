import 'package:cloud_firestore/cloud_firestore.dart';
class PetModel {
  final String name;
  final String bred;
  final String gender;
  final double weight;
  final DateTime dob;
  final String profileUrl;
  final String petId;


  PetModel(this.name, this.bred, this.gender, this.weight, this.dob,this.profileUrl,this.petId);

  factory PetModel.fromMap(Map<String, dynamic> map) {
    return PetModel(
      map['name'] ?? '',
      map['bred'] ?? '',
      map['gender'] ?? '',
      (map['weight'] ?? 0.0).toDouble(),
      (map['dob'] ?? Timestamp.now()).toDate(),
      map['profileUrl']??'',
      map['userId']??'',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'bred': bred,
      'gender': gender,
      'weight': weight,
      'dob': dob,
      'profileUrl':profileUrl,
      'userId':petId,
    };
  }
}
