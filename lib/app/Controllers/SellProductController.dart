import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../Model/Pet.dart';


class SellProductController extends GetxController with StateMixin<String> {
  late TextEditingController nameController;
  late TextEditingController breedController;
  late TextEditingController genderController;
  late TextEditingController weightController;
  late TextEditingController ageController;
  late TextEditingController heightController;
  late TextEditingController colorController;
  late TextEditingController addressController;
  late TextEditingController prizeController;
  late TextEditingController descriptionController;
  RxList<File> images = <File>[].obs;
  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    breedController = TextEditingController();
    genderController = TextEditingController();
    weightController = TextEditingController();
    ageController = TextEditingController();
    heightController = TextEditingController();
    colorController = TextEditingController();
    addressController = TextEditingController();
    prizeController = TextEditingController();
    descriptionController = TextEditingController();
    change(null, status: RxStatus.success());
  }

  Future<void> sellProduct() async {
    change(null, status: RxStatus.loading()); // Set loading state
   final String uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      final List<String> downloadUrl =  await uploadImages(images.value, 'sell/$uid/');
      Pet newPet = Pet(
        name: nameController.text,
        bred: breedController.text,
        gender: genderController.text,
        weight: double.parse(weightController.text),
        ageInMonths: int.parse(ageController.text),
        heightInFeet: double.parse(heightController.text),
        profileUrls: downloadUrl,
        petId: uid ,
        color: colorController.text,
        address: addressController.text,
        prize: double.parse(prizeController.text),
        sellDate: DateTime.now(),
        description: descriptionController.text,
      );

      // Add the 'newPet' data to Firestore
      await FirebaseFirestore.instance.collection('pets').add(newPet.toMap());
      await FirebaseFirestore.instance.collection('users').doc(uid).collection('sellProduct').add(newPet.toMap());

      // Reset the text controllers
      nameController.clear();
      breedController.clear();
      genderController.clear();
      weightController.clear();
      ageController.clear();
      heightController.clear();
      colorController.clear();
      addressController.clear();
      prizeController.clear();
      descriptionController.clear();

      // Set success state
      change(null, status: RxStatus.success());
    } catch (error) {
      // Set error state
      change(null, status: RxStatus.error('Failed to sell product. Please try again.'));
      print(error.toString());
      change(null, status: RxStatus.success());
    }
  }


// Add a method to pick an image
  Future<void> pickImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Add the file and its bytes to the list
      images.value.add(File(pickedFile.path));
      // Debugging: Print the length of the images list
      print('Number of images: ${images.length}');
      images.refresh();
    }
  }


  Future<List<String>> uploadImages(List<File> images, String path) async {
    List<String> downloadUrls = [];

    for (int i = 0; i < images.length; i++) {
      final firebase_storage.Reference storageRef =
      firebase_storage.FirebaseStorage.instance.ref().child(
        "$path/image_${DateTime.now().millisecondsSinceEpoch}.jpg",
      );

      final firebase_storage.UploadTask uploadTask =
      storageRef.putFile(images[i]);

      final firebase_storage.TaskSnapshot taskSnapshot =
      await uploadTask.whenComplete(() {});

      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      downloadUrls.add(downloadUrl);
    }

    return downloadUrls;
  }


  Future<String> getImageDownloadUrl(String path) async {
    final storageRef = FirebaseFirestore.instance.collection('pets').doc(FirebaseAuth.instance.currentUser!.uid).collection(DateTime.now().toString()).doc().id;
    final downloadUrlSnapshot = await FirebaseFirestore.instance
        .collection('pets')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(DateTime.now().toString())
        .doc(storageRef)
        .get();

    final downloadUrl = downloadUrlSnapshot.get('profileUrl');
    return downloadUrl.toString(); // Make sure to convert it to String

  }
  void removeImage(int index) {
    images.value.removeAt(index);
  }
  @override
  void onClose() {
    nameController.dispose();
    breedController.dispose();
    genderController.dispose();
    weightController.dispose();
    ageController.dispose();
    heightController.dispose();
    colorController.dispose();
    addressController.dispose();
    prizeController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
