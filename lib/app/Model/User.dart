import 'package:cloud_firestore/cloud_firestore.dart';
import 'Pet.dart';
import 'PetDiscription.dart';

class Users {
  final String image;
  final String about;
  final String name;
  final String createdAt;
  final bool isOnline;
  final String uid;
  final String lastActive;
  final String email;
  final String pushToken;
  final List<Pet> pets;
  final List<PetDescription> petDescription; // Corrected class name here

  Users({
    required this.image,
    required this.about,
    required this.name,
    required this.createdAt,
    required this.isOnline,
    required this.uid,
    required this.lastActive,
    required this.email,
    required this.pushToken,
    required this.pets,
    required this.petDescription, // Added this line
  });
  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      image: map['image'] ?? '',
      about: map['about'] ?? '',
      name: map['name'] ?? '',
      createdAt: map['created_at'] ?? '',
      isOnline: map['is_online'] ?? false,
      uid: map['uid'] ?? '',
      lastActive: map['last_active'] ?? '',
      email: map['email'] ?? '',
      pushToken: map['push_token'] ?? '',
      pets: List<Pet>.from((map['pets'] ?? []).map((pet) => Pet.fromMap(pet))),
      petDescription: List<PetDescription>.from((map['petDescription'] ?? []).map((pet) => PetDescription.fromMap(pet))),
    );
  }


  factory Users.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Users(
      image: data['image'] ?? '',
      about: data['about'] ?? '',
      name: data['name'] ?? '',
      createdAt: data['created_at'] ?? '',
      isOnline: data['is_online'] ?? false,
      uid: data['uid'] ?? '',
      lastActive: data['last_active'] ?? '',
      email: data['email'] ?? '',
      pushToken: data['push_token'] ?? '',
      pets: List<Pet>.from((data['pets'] ?? []).map((pet) => Pet.fromMap(pet))),
      petDescription: List<PetDescription>.from((data['petDescription'] ?? []).map((desc) => PetDescription.fromJson(desc))), // Adjusted this line
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'about': about,
      'name': name,
      'created_at': createdAt,
      'is_online': isOnline,
      'uid': uid,
      'last_active': lastActive,
      'email': email,
      'push_token': pushToken,
      'pets': pets.map((pet) => pet.toMap()).toList(),
      'pet_description': petDescription.map((desc) => desc.toJson()).toList(), // Adjusted this line
    };
  }
}
