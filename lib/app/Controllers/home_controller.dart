import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../Model/Pet.dart';

class HomeController extends GetxController {
  final count = 0.obs;
  final RxList<Pet> PetData = <Pet>[].obs;
  @override
  Future<void> onInit() async {
    super.onInit();
    fetchData();
  }

  @override
  void onReady() {
    super.onReady();
  }
  void fetchData() async {
    // Fetch data and update the list
    List<Pet> newData = await getAllSoldProducts();
    List<Pet> data = await getAllPets();
    PetData.assignAll(data);
    update();
  }

  void addToFavorites() {
    // Replace this logic with the actual implementation of adding the pet to the user's account
    // print('Pet added to favorites!');
  }

  Future<List<Pet>> getAllSoldProducts() async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      // Query the Firestore collection and sort by sell date
      QuerySnapshot<Map<String, dynamic>> querySnapshot = (await FirebaseFirestore.instance
          .collection('pets')
          .doc(uid)
          .collection(DateTime.now().toString())
          .doc(uid)
          .get()) as QuerySnapshot<Map<String, dynamic>>;

      // Convert the query snapshot into a list of Pet objects
      List<Pet> soldProducts = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return Pet.fromMap(data);
      }).toList();
      print(soldProducts);
      return soldProducts;
    } catch (error) {
      print('Error getting sold products: $error');
      // Handle the error, throw an exception, or return an empty list
      return [];
    }
  }
  Future<List<Pet>> getAllPets() async {
    try {
      // Query the entire 'pets' collection
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('pets')
          .get();

      // Convert the query snapshot into a list of Pet objects
      List<Pet> pets = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        print("data $data");
        return Pet.fromMap(data);
      }).toList();
      print("data $pets");
      print(pets);
      return pets;
    } catch (error) {
      print('Error getting pets: $error');
      // Handle the error, throw an exception, or return an empty list
      return [];
    }
  }

  @override
  void onClose() {
    super.onClose();
  }


}
