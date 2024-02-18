import 'package:animal/app/Controllers/PostController.dart';
import 'package:animal/app/Screen/Pages/PostPages/PostPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPostScreen extends GetView<PostController> {
  const AddPostScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create a new Post',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow
              .visible, // or TextOverflow.ellipsis if you want ellipsis (...) on overflow
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Colors.grey.shade200))),
                child: TextField(
                  controller: controller.captionController,
                  decoration: const InputDecoration(
                      hintText: "Caption",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none),
                ),
              ),
              Obx(() =>
              controller.images.isNotEmpty?SizedBox(height: 350,width: double.infinity,child: Image.file(controller.images.first),):const SizedBox() ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.white),
                      onPressed: () {controller.pickImage();},
                      child: const Text(
                        "Add Image",
                        style: TextStyle(color: Colors.black),
                      ))),
              Obx(() =>
              MaterialButton(
                onPressed: () {controller.uploadPost(FirebaseAuth.instance.currentUser!.uid, controller.captionController.text, controller.images.first, "Ajay","https://blogs.microsoft.com/wp-content/uploads/prod/2022/10/Image-Create-in-Bing1233-694-size.png" );},
                height: 50,
                color: Colors.orange[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child:Center(
                  child:controller.posting.value?const CircularProgressIndicator(): const Text(
                    "Post",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
