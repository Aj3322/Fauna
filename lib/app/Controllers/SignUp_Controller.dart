import 'package:animal/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/User.dart';
class SignUpController extends GetxController with StateMixin<User?>{
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> registerWithEmail() async {
    print('registering with email');
    change(null, status: RxStatus.loading());
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString(),
      );
      final User? user = userCredential.user;
      if (user != null) {
        change(user, status: RxStatus.success());
        _storeUserData(user.uid);
        nameController.clear();
        emailController.clear();
        passwordController.clear();
        Get.offNamed(Routes.HOME);
      } else {
        throw 'Registration failed';
      }
    } catch (e) {
      print(e);

      // Clear the loading state
      change(null, status: RxStatus.success());

      Get.back();
      Get.dialog(
        SimpleDialog(
          title: const Text('Error'),
          contentPadding: const EdgeInsets.all(20),
          children: [Text(e.toString())],
        ),
      );
    }
  }

  Future<void> _storeUserData(String userId) async {
    final CollectionReference users = FirebaseFirestore.instance.collection('users');
    Users user = Users(
      image: 'https://firebasestorage.googleapis.com/v0/b/animal-5e97a.appspot.com/o/Avatar1.jpg?alt=media&token=37654600-486d-4405-bf60-b460d4a1d1f7',
      about: '',
      name: nameController.text.toString(),
      createdAt: DateTime.now().toString(),
      isOnline: false,
      uid: userId,
      lastActive: '',
      email: emailController.text.toString(),
      pushToken: '',
      pets: [],
      petDescription: []
    );
    Map<String, dynamic> userData = user.toJson();
    // Add user data to Firestore
    await users.doc(userId).set(userData);
  }
  @override
  void onInit() {
    change(null, status: RxStatus.success());
    super.onInit();
  }
}
