import 'dart:ffi';

import 'package:animal/app/Bindings/ChatBinding.dart';
import 'package:animal/app/Controllers/PostController.dart';
import 'package:animal/app/Screen/ChatScreen.dart';
import 'package:animal/app/Screen/Pages/PostPages/AddPost.dart';
import 'package:animal/app/Widget/DrawerWidget.dart';
import 'package:animal/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class FeedScreen extends GetView<PostController> {
  const FeedScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Config().init(context);
    var width = Config.screenWidth;
    var height = Config.screenHeight;
    return Scaffold(
        drawer: const DrawerWidget(),
              appBar: AppBar(
                title: Image.asset("assets/logo.png",height: 40),
                actions: [
                  IconButton(
                      onPressed: () {
                        Get.to(AddPostScreen(),transition: Transition.circularReveal);
                      },
                      icon: const Icon(Icons.add,
                          size: 30, color: Colors.black)),
                  IconButton(
                      onPressed: () {
                        Get.to(ChatScreen(),transition: Transition.circularReveal,binding: ChatBindings());
                      },
                      icon: const FaIcon(FontAwesomeIcons.paperPlane),
                      // const Icon(Icons.chat_bubble_outline)
                  )
                ],
              ),
              body:
              Obx(
                () => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : controller.posts.isEmpty
                        ? Center(
                            child: Column(
                              children: [
                                const Text(
                                  'Nothing to show.',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                    onPressed: () {
                                      controller.getAllPostsSortedByDate();
                                    },
                                    icon: const Icon(Icons.refresh))
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: controller.posts.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Container(
                                    width: width,
                                    height: height! * 0.08,
                                    // color: Colors.red,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.blue,
                                          backgroundImage: NetworkImage(
                                              controller
                                                  .posts[index].profileUrl),
                                        ),
                                        SizedBox(width: 16),
                                        Text(
                                          controller.posts[index].username,
                                          style: const TextStyle(
                                            color: Color(0xFF1D1B20),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            height: 0.01,
                                            letterSpacing: 0.15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: height * 0.4,
                                    width: width,
                                    // color: Colors.red,
                                    child: Image.network(
                                      controller.posts[index].postUrl,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Container(
                                    height: height * 0.1,
                                    // color: Colors.blue,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 34,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        controller.likePost(
                                                            controller
                                                                .posts[index]
                                                                .postId,
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid,
                                                            controller
                                                                .posts[index]
                                                                .likes);
                                                      },
                                                      icon: Obx(()=>controller
                                                          .posts[index]
                                                          .likes
                                                          .contains(
                                                          FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                          ? const Icon(
                                                        Icons.favorite,
                                                        color:
                                                        Colors.red,
                                                      )
                                                          : const Icon(
                                                        Icons
                                                            .favorite_border,
                                                        size: 28,
                                                      )),),
                                                  IconButton(
                                                      onPressed: () {},
                                                      icon: const Icon(
                                                        Icons
                                                            .chat_bubble_outline,
                                                        size: 28,
                                                      ))
                                                ],
                                              ),
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                    Icons
                                                        .bookmark_border_outlined,
                                                    size: 28,
                                                  ))
                                            ],
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Text(controller
                                                .posts[index].description),
                                          ),
                                        ),
                                        const Divider(
                                          color: Colors.black26,
                                          height: 2,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              );
                            }),
              ),
            );
  }
}
