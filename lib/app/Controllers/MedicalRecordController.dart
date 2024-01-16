import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MedicalRecordsController extends GetxController {
  RxList<String> medicalRecords = <String>[].obs;
  var selectedImagePath = ''.obs;
  var selectedImageSize = ''.obs;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Future<void> onInit() async {
    super.onInit();
    _getRecord();
  }

  Future<void> addMedicalRecord(File file ,String path) async {
    final reference = await _uploadFile(file,path);
    await _addRecordToFirestore(reference);
    medicalRecords.add(reference);
  }

  Future<void> removeMedicalRecord(String recordUrl) async {
    await _removeRecordFromFirestore(recordUrl);
    await _removeFile(recordUrl);
    medicalRecords.remove(recordUrl);
  }

  Future<String> _uploadFile(File file , String path) async {
    final Reference reference =
    _storage.ref().child(path);
    final UploadTask uploadTask = reference.putFile(file);
    await uploadTask.whenComplete(() => null);
    return reference.getDownloadURL();
  }

  Future<void> _addRecordToFirestore(String reference) async {
    await FirebaseFirestore.instance
        .collection('your_collection')
        .add({'recordUrl': reference,"type":"pdf"});
  }

  Future<void> _getRecord() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('your_collection')
          .get();

      List<String> records = querySnapshot.docs
          .map((DocumentSnapshot<Map<String, dynamic>> doc) => doc.data()?['recordUrl'] ?? '')
          .where((record) => record.isNotEmpty)
          .cast<String>()
          .toList();
      print(records);
      medicalRecords.assignAll(records);
      medicalRecords.refresh();
    } catch (e) {
      // Handle errors
      print("Error fetching records: $e");
    }
  }

  Future<void> _removeRecordFromFirestore(String recordUrl) async {
    await FirebaseFirestore.instance
        .collection('your_collection')
        .where('recordUrl', isEqualTo: recordUrl)
        .get()
        .then((snapshot) {
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  Future<void> _removeFile(String recordUrl) async {
    await _storage.refFromURL(recordUrl).delete();
  }

  void getImage(ImageSource imageSource) async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      selectedImagePath.value=pickedFile.path;
        File file = File(selectedImagePath.value);
        await addMedicalRecord(file ,'medical_records/${DateTime.now()}.png');
      selectedImageSize.value="${((File(selectedImagePath.value).lengthSync()/1024/1024)).toStringAsFixed(2)} Mb";
    } else {
      Get.snackbar('Error', 'No image selected',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> pickPdfOrDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      File file = File(result.files.first.path!);
      await addMedicalRecord(file ,'medical_records/${DateTime.now()}.pdf');
    }
  }
}
