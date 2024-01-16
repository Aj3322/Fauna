import 'package:animal/app/Controllers/ProfileController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class AiDetails extends GetView<ProfileController> {
  const AiDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(width: double.infinity,child: Text(controller.pridiction.value)),
      ),
    );
  }
}
