
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/app_pages.dart';

class LogInController extends GetxController with StateMixin{
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void onInit() {
    change(null, status: RxStatus.success());
    super.onInit();
  }

  Future<void> LoginWithEmail() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password:  passwordController.text,
      );
      User? user = userCredential.user;
      if (user != null) {
        final SharedPreferences? prefs = await _prefs;
        await prefs?.setString('token', user.uid);
        emailController.clear();
        passwordController.clear();
        Get.toNamed(Routes.HOME); // Change this to your home route
      } else {
        throw 'Login failed';
      }
    } on FirebaseAuthException catch (error) {
      String errorMessage = _mapFirebaseErrorToMessage(error.code);
      change(null, status: RxStatus.error(errorMessage));
      Get.dialog(
        SimpleDialog(
          title: Text('Error'),
          contentPadding: EdgeInsets.all(20),
          children: [Text(errorMessage)],
        ),
      );
      change(null, status: RxStatus.success());
    } catch (e) {
      print(e);
      Get.dialog(
        SimpleDialog(
          title: Text('Error'),
          contentPadding: EdgeInsets.all(20),
          children: [Text(e.toString())],
        ),
      );
    }
  }
  }


  String _mapFirebaseErrorToMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'user-disabled':
        return 'The user corresponding to the given email has been disabled.';
      default:
        return 'An unexpected error occurred. Please try again later.';
    }
  }

