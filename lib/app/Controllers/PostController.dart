import 'package:animal/app/Screen/Pages/PostPages/PostPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../Model/Post.dart';
import '../data/StorageMethod.dart';
import 'dart:io';
class PostController extends GetxController {
  RxBool isLoading = true.obs;
  RxBool posting = false.obs;
  RxList<Post> posts = <Post>[].obs;
  RxList<File> images = <File>[].obs;
  late TextEditingController captionController= TextEditingController() ;
  @override
  void onInit() {
    getAllPostsSortedByDate();
    super.onInit();
  }
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> getAllPostsSortedByDate() async {
    try {
      isLoading.value = true;
      QuerySnapshot querySnapshot = await firestore
          .collection('posts')
          .orderBy('datePublished', descending: true)
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

  Future<void> uploadPost(
      String uid,
      String description,
      File file,
      String username,
      String profileUrl,
      ) async {
    try {
      posting.value=true;
      posting.refresh();
      String photoUrl =
      await StorageMethod().uploadImageToStorage('post', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profileUrl: profileUrl,
        likes: [],
      );
      await firestore.collection('posts').doc(postId).set(post.toJson());
      posting.value=false;
      posting.refresh();
     Get.back();
     getAllPostsSortedByDate();
     captionController.clear();
     images.clear();
    } catch (err) {
      Get.snackbar("Error", err.toString());
    }
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
        getAllPostsSortedByDate();
        posts.refresh();
      } else {
        await firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
        getAllPostsSortedByDate();
        posts.refresh();
      }
    } catch (err) {
      if (kDebugMode) {
        print(err.toString());
      }
    }
  }

  Future<String> postComment(
      String postId,
      String text,
      String uid,
      String name,
      String profilePic,
      ) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = 'Please enter text';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
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
}
