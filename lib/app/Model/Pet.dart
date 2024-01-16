import 'package:cloud_firestore/cloud_firestore.dart';

class Pet {
  final String name;
  final String bred;
  final String gender;
  final double weight;
  final int ageInMonths;
  final double heightInFeet;
  final List<String> profileUrls;
  final String petId;
  final String color;
  final String address;
  final double prize;
  final DateTime sellDate;
  final String description;

  Pet({
    required this.name,
    required this.bred,
    required this.gender,
    required this.weight,
    required this.ageInMonths,
    required this.heightInFeet,
    required this.profileUrls,
    required this.petId,
    required this.color,
    required this.address,
    required this.prize,
    required this.sellDate,
    required this.description
  });

  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      name: map['name'] ?? '',
      bred: map['bred'] ?? '',
      gender: map['gender'] ?? '',
      weight: (map['weight'] ?? 0.0).toDouble(),
      ageInMonths: map['ageInMonths'] ?? 0,
      heightInFeet: (map['heightInFeet'] ?? 0.0).toDouble(),
      profileUrls: List<String>.from(map['profileUrls'] ?? []),
      petId: map['userId'] ?? '',
      color: map['color'] ?? '',
      address: map['address'] ?? '',
      prize: map['prize']??0.0,
      sellDate: (map['sellDate'] as Timestamp).toDate() ,
      description:map['description']?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'bred': bred,
      'gender': gender,
      'weight': weight,
      'ageInMonths': ageInMonths,
      'heightInFeet': heightInFeet,
      'profileUrls': profileUrls,
      'userId': petId,
      'color': color,
      'address': address,
      'prize':prize,
      'sellDate':sellDate,
      'description':description,
    };
  }
}
