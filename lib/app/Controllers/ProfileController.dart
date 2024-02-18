import 'dart:convert';
import 'dart:io';
import 'package:animal/app/Model/Pet.dart';
import 'package:animal/app/Model/PetDiscription.dart';
import 'package:animal/app/Model/User.dart';
import 'package:animal/app/Screen/AiDetails.dart';
import 'package:animal/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';
import '../Model/Post.dart';
class ProfileController extends GetxController {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rx<ScrollController> sc = ScrollController().obs;
  final CollectionReference user =
      FirebaseFirestore.instance.collection("users");
  final Rx<Users> users = Users(
      image: "",
      about: "",
      name: "",
      createdAt: "",
      isOnline: true,
      uid: "",
      lastActive: "",
      email: "",
      pushToken: "",
      pets: [],
      petDescription: []
  ).obs;
  RxString name = ''.obs;
  RxString breed = ''.obs;
  RxString gender = ''.obs;
  RxString weight = ''.obs;
  RxString pridiction = ''.obs;
  RxString dob = ''.obs;
  RxString profileUrl = ''.obs;
  RxString petId = ''.obs;
  RxBool profileImagePik = false.obs;
  RxBool profileImagePikAgain = false.obs;
  RxBool isLoading = false.obs;
  RxList<Pet> pets = <Pet>[].obs;
  RxList<PetDescription> petDescription = <PetDescription>[].obs;
  RxList<PetDescription> petDes = <PetDescription>[].obs;
  RxList<Post> posts = <Post>[].obs;
  File? profileImage;
  final String uid = _auth.currentUser!.uid;
  TextEditingController text= TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadModel();
    fetchUserData(uid);
    loadPetDescription();
    print(uid);
  }


  Future<int> pickImage({ImageSource source=ImageSource.camera}) async {
    int i=0;
    loadPetDescription();
    final picker = ImagePicker();
    final XFile? pickedFile =
    await picker.pickImage(source:source);
    if (pickedFile != null) {
      i=await classifyImage(File(pickedFile.path));
      update(); // Trigger a rebuild to update the UI with the selected image
    }
    return i;
  }
  Future<int> classifyImage(File image) async {
    late PetDescription data  ;
    try {
      loadPetDescription();
      print("prediction");
      List? output = await Tflite.runModelOnImage(
        path: image.path,
      );
      print(output?.first["index"].toString());
        switch(output!.first["index"]){
          case 0:
          data = petDescription[0];
          print(data.description.toString());
            break;
          case 1 :
            data =  petDescription[1];
            break;
            case 3:
              data = petDescription[3];
          break;
          case 4:
            data = petDescription[4];
            break;
          case 5:
            data = petDescription[5];
            break;
          case 7:
            data =  petDescription[7];
            break;
          case 8:
            data =  petDescription[8];
            break;
          case 9:
            data =  petDescription[9];
            break;
          default:
            "Nothing match";
            // print(data.description.toString());
            data = petDescription.first;
            break;
        }
      pridiction.value = "predict = ${data.description}";
      pridiction.refresh();
      return output!.first["index"];
      // Get.to(AiDetails());
    }catch(e){
      pridiction.value = "predict = $e";
      print(e.toString());
      pridiction.refresh();
      // Get.to(AiDetails());
    }
    return 0;
  }
  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
    ).then((value) {
      print("${File("assets/labels.txt")}   $value");
    });
  }
  Future<void> SignOut() async {
    await _auth.signOut();
    Get.offNamed(Routes.SIGNUP);
  }

  Future<void> createPet(PetDescription petDescription, BuildContext context) async {
    try {
      String petId = const Uuid().v1();

      // Fetch the current user data
      DocumentSnapshot<Object?> snapshot = await user.doc(uid).get();
      Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;

      if (userData != null) {
        // Add the new petDescription to the existing list
        List<PetDescription> petDescriptions = List<PetDescription>.from((userData['petDescription'] ?? []).map((desc) => PetDescription.fromMap(desc)));
        petDescriptions.add(petDescription);

        // Update the user document with the modified petDescription list
        await user.doc(uid).update({
          "petDescription": petDescriptions.map((desc) => desc.toMap()).toList(),
        });

        print("Pet created: ${petDescription.species}");
        fetchUserData(uid);
        Navigator.of(context).pop();
        update();
      }
    } catch (error) {
      print('Error creating pet: $error');
    }
  }


  Future<void> fetchUserData(String uid) async {
    // try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await user.doc(uid).get() as DocumentSnapshot<Map<String, dynamic>>;
      Map<String, dynamic>? userData = snapshot.data();
      if (userData != null) {
        Users fetchedUser = Users.fromMap(userData);
        users.value = fetchedUser;
        getAllPostsSortedByDate();
        update();
      }
    // } catch (error) {
    //   print('Error fetching user data: $error');
    // }
  }

  Future<void> editProfile() async {
    // Upload profile image if it's selected
    if (profileImage != null) {
      final String imagePath = 'users/$uid/profile_image.jpg';
      await uploadImage(profileImage!, imagePath);
      profileUrl.value = await getDownloadUrl('users/$uid/profile_image.jpg');
    }
    print(profileUrl.value);
    Users usersUpated = Users(
        image: profileUrl.value,
        about: "",
        name: name.value,
        createdAt: users.value.createdAt,
        isOnline: true,
        uid: uid,
        lastActive: "",
        email: users.value.email,
        pushToken: '',
        pets: users.value.pets,
        petDescription: users.value.petDescription
    );

    var result = await user.doc(uid).update(usersUpated.toJson());
    fetchUserData(uid);
    users.refresh();
    Get.back();
  }

  Future<String> getDownloadUrl(String path) async {
    final storageRef =
        firebase_storage.FirebaseStorage.instance.ref().child(path);
    return await storageRef.getDownloadURL();
  }

  Future<void> uploadImage(File image, String path) async {
    try {
      if (io.Platform.isAndroid || io.Platform.isIOS) {
        // Mobile platforms
        final firebase_storage.Reference storageRef =
            firebase_storage.FirebaseStorage.instance.ref().child(path);
        final firebase_storage.UploadTask uploadTask =
            storageRef.putFile(image);
        final firebase_storage.TaskSnapshot taskSnapshot =
            await uploadTask.whenComplete(() {});
        final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        profileUrl.value = downloadUrl;
        update();
        print('Image uploaded successfully. Download URL: $downloadUrl');
      } else if (io.Platform.isLinux ||
          io.Platform.isMacOS ||
          io.Platform.isWindows) {
        // Desktop platforms
        final firebase_storage.Reference storageRef =
            firebase_storage.FirebaseStorage.instance.ref().child(path);
        final firebase_storage.UploadTask uploadTask =
            storageRef.putFile(image);
        final firebase_storage.TaskSnapshot taskSnapshot =
            await uploadTask.whenComplete(() {});
        final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        profileUrl.value = downloadUrl;
        update();
        print('Image uploaded successfully. Download URL: $downloadUrl');
      }
    } catch (error) {
      print('Error uploading image: $error');
    }
  }

  Future<void> pickProfileImage({ImageSource source=ImageSource.gallery}) async {
    // Implement your logic for picking an image from the gallery
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: source);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      // classifyImage(profileImage!);
      if (!profileImagePik.value) {
        profileImagePik.value = true;
        profileImagePikAgain.value = false;
      } else {
        profileImagePikAgain.value = true;
        profileImagePik.value = false;
      }
      update(); // Trigger a rebuild to update the UI with the selected image
    }
  }
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> getAllPostsSortedByDate() async {
    try {
      isLoading.value = true;
      QuerySnapshot querySnapshot = await firestore
          .collection("posts")
          .where("uid", isEqualTo: uid)
          // .orderBy('datePublished', descending: true)
          .get();

      List<Post> fetchedPosts = querySnapshot.docs
          .map((doc) => Post.fromSnap(doc))
          .toList();
      posts.value = fetchedPosts;
      print(posts.length);
    } catch (err) {
      if (kDebugMode) {
        print(err.toString());
      }
    } finally {
      isLoading.value = false;
      update();
    }
  }
  Future<String> deletePost(String postId,int index) async {
    String res = 'Some error occurred';
    try {
      await firestore.collection('posts').doc(postId).delete();
      res = 'success';
      posts.removeAt(index);
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> loadPetDescription() async{
     String jsonString = await rootBundle.loadString('assets/AnimalData.json');
     // print(jsonString);
     List<dynamic> jsonList = json.decode(jsonString);

     List<PetDescription> animalList = jsonList.map((json) => PetDescription.fromJson(json)).toList();
     petDescription.value = animalList;

  }
}
