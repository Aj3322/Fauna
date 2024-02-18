
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/ProfileController.dart';

class ProfileEditPage extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
             Obx(() =>  GestureDetector(
               onTap: () async {
                 await controller.pickProfileImage();
               },
               child:Container(
                   decoration: const BoxDecoration(
                     borderRadius: BorderRadius.all(Radius.circular(50))
                   ),
                 margin: EdgeInsets.symmetric(horizontal: 120),
                 height: 90,
                 clipBehavior: Clip.hardEdge,
                 child:controller.profileImagePikAgain.value?Image.file(controller.profileImage!,fit:BoxFit.fill,): controller.profileImagePik.value?Image.file(controller.profileImage!,fit:BoxFit.fill,):  Image.network(
                    controller.profileUrl.value == ''
                       ? 'https://e7.pngegg.com/pngimages/539/474/png-clipart-dog-puppy-cartoon-cute-dog-mammal-animals.png'
                       : controller.profileUrl.value, fit: BoxFit.cover,),
               )

             ),),
              const SizedBox(height: 16),
              _buildTextField(controller.users.value.name, controller.name),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await controller.editProfile();
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, RxString value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        onChanged: (newValue) {
          value.value = newValue;
        },
      ),
    );
  }
}
