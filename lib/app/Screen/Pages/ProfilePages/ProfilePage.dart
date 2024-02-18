import 'package:animal/app/Controllers/ProfileController.dart';
import 'package:animal/app/Screen/Pages/ProfilePages/PetSearch.dart';
import 'package:animal/app/Widget/DrawerWidget.dart';
import 'package:animal/config.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ProfileEdit.dart';
import 'DiscptionPage.dart';

class ProfilePage extends GetView<ProfileController> {
  ProfilePage({super.key});
   RxBool isMedical = false.obs,isAddPet = false.obs;
  final List<Info> info = [
    Info("Temperature", "65-75°F (18-24°C)", false, "assets/img_5.png"),
    Info("Ventilation", "Properly needed", true, "assets/img_4.png"),
    Info("Avoid these", " ", true, "assets/img_6.png")
  ];

  Widget textWidget(String string) {
    return Text(
      string,
      style: const TextStyle(
          fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w400),
    );
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    final width = Config.screenWidth;
    final height = Config.screenHeight;

    // return Obx(() {
    //   switch (isOpen.value) {
    //     case 1:
    //       return DescriptionPage(context,controller.petDescription[0],false);
    //     case 2:
    //       return PetSearch();
    //     case 3:
    //       return VaccineSchedulesPage();
    //     case 4:
    //       return TrackOrdersPage();
    //     case 0:
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
              centerTitle: true,
            ),
            drawer: const DrawerWidget(),
            body: SizedBox(
              height: height,
              width: width,
              child: SingleChildScrollView(
                child: Container(
                  height: height,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width! * 0.06),
                    child: Column(
                      children: [
                        Obx(
                          () => Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 35,
                                backgroundImage: NetworkImage(
                                 controller.users.value.image,
                                ),
                              ),
                              SizedBox(
                                height: height! * 0.005,
                              ),
                             Obx(() =>  Text(
                               controller.users.value.name,
                               style: const TextStyle(
                                   fontSize: 20,
                                   fontWeight: FontWeight.w400),
                             ),),
                              SizedBox(
                                height: height * 0.002,
                              ),
                              Text(
                                controller.users.value.email,
                                style: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w300),
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              FadeInUp(
                                duration: const Duration(milliseconds: 1600),
                                child: MaterialButton(
                                  onPressed: () {
                                    Get.to(()=> ProfileEditPage(),transition: Transition.zoom);
                                  },
                                  height: height * 0.05,
                                  color: Color(0xFF777B9F),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Edit Profile",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('My Pets',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Obx(() {
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5,
                                  crossAxisSpacing: 8.0,
                                  mainAxisSpacing: 8.0,
                                ),
                                itemCount: controller.users.value.petDescription.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    // Add button
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(60),
                                        color: Colors.grey[200],
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.add, size: 40, color: Colors.grey),
                                        onPressed: (){Get.to(PetSearch(),transition: Transition.leftToRight);},
                                      ),
                                    );
                                  } else {
                                    // Display selected image
                                    return InkWell(
                                      onTap: (){Get.to(DescriptionPage(context,controller.users.value.petDescription[index-1],false),transition: Transition.circularReveal);},
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        clipBehavior: Clip.hardEdge,
                                        child: Image.network(
                                          controller.users.value.petDescription[index - 1].image!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              );

                            }),
                          ],
                        ),
                        SizedBox(
                          height: height! * 0.02,
                        ),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text('My Posts',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
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
                              :Expanded(
                                child: ListView.builder(
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
                                            controller.posts[index].uid ==
                                                FirebaseAuth
                                                    .instance.currentUser!.uid
                                                ? IconButton(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (context) => Dialog(
                                                      child:
                                                      ListView(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            vertical:
                                                            16),
                                                        shrinkWrap:
                                                        true,
                                                        children: [
                                                          'Delete'
                                                        ]
                                                            .map(
                                                              (e) =>
                                                              InkWell(
                                                                onTap:
                                                                    () {
                                                                  controller.deletePost(controller.posts[index].postId,index);
                                                                  Navigator.of(context).pop();
                                                                },
                                                                child:
                                                                Container(
                                                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                                  child: Text(e),
                                                                ),
                                                              ),
                                                        )
                                                            .toList(),
                                                      ),
                                                    ));
                                              },
                                              icon: const Icon(
                                                Icons.more_horiz_outlined,
                                                color: Color(0xFFD4BEC1),
                                              ),
                                            )
                                                : Container(),
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
                                                          },
                                                          icon: controller
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
                                                          )),
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
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Text(controller
                                                  .posts[index].description),
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
                        ),
                        // SizedBox(height: height*0.15,)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
      }

  Widget _bottomSheet(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
          _textWidget("Pug", size: 31, weight: FontWeight.w400),
          const SizedBox(
            height: 10,
          ),
          Obx(
                () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    // isMedical.value = false;
                    // isMedical.refresh();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      color: isMedical.value ? null : const Color(0x2BABAEB5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Description',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 0.12,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    isMedical.value = true;
                    isMedical.refresh();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      color: isMedical.value ? const Color(0x2BABAEB5) : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Medical History',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 0.12,
                      ),
                    ),
                  ),
                ),
                // SizedBox(
                //     width: MediaQuery.of(context).size.width * 0.4,
                //     child: MaterialButton(
                //       onPressed: () {
                //         isMedical.value=false;
                //             isMedical.refresh();
                //       },
                //       color: isMedical.value ? null : const Color(0x2BABAEB5),
                //       child: const Text("Description"),
                //     )),
                // SizedBox(
                //     width: MediaQuery.of(context).size.width * 0.4,
                //     child: MaterialButton(
                //       onPressed: () {
                //         isMedical.value = true;
                //         isMedical.refresh();
                //       },
                //       color: isMedical.value ? const Color(0x2BABAEB5) : null,
                //       child: const Text("Medical History"),
                //     ))
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          _textWidget("General information", size: 14, weight: FontWeight.w600),
          const SizedBox(
            height: 10,
          ),
          _rowText("Lifespan", "12-15 years"),
          _rowText("Size", "Compact, 14-18 pounds"),
          _rowText("Strength", "Surprisingly strong for their size"),
          _rowText("Energy Level",
              "Moderate, playful bursts, followed by lazy snoozes on the couch."),
          const SizedBox(
            height: 10,
          ),
          _textWidget("Habitat requirements",
              size: 14, weight: FontWeight.w600),
          // const SizedBox(height: 10,),
          _textWidget("care must be based on the following requirements",
              size: 12,
              weight: FontWeight.w600,
              color: const Color(0xFFAAAAAA)),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
              height: 105,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: info.length,
                  itemBuilder: (context, index) => Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 105,
                    height: 105,
                    decoration: ShapeDecoration(
                      color: const Color(0x2DABAEB6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 39,
                                height: 41,
                                decoration: ShapeDecoration(
                                  color: Color(0x7CB8B7B7),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(6)),
                                ),
                                child: Image.asset(info[index].image),
                              ),
                              index == 0
                                  ? Container()
                                  : Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "assets/img_3.png"),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              )
                            ],
                          ),
                          _textWidget(
                            info[index].name,
                            weight: FontWeight.w500,
                          ),
                          _textWidget(
                            info[index].detail,
                            size: 8,
                            weight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                  ))),
          const SizedBox(height: 10,),
          _textWidget("Pet Provisions", size: 15, weight: FontWeight.w600),
          const SizedBox(height: 10,),
          Row(
            children: [
              Container(
                width: 27,
                height: 27,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/img_7.png"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              _textWidget(" Diet", size: 15, weight: FontWeight.w600),
            ],
          ),
          const SizedBox(height:10,),
          _textWidget(
              "High-quality kibble tailored for pugs, avoiding overfeeding, and managing treats carefully. Two smaller meals per day to avoid bloat, monitor weight closely.",
              size: 12,
              weight: FontWeight.w400,color: const Color(0xFFAAAAAA) ),
        ],
      ),
    );
  }

  Widget _textWidget(String data,
      {FontWeight weight = FontWeight.w300, double size = 12, Color? color}) {
    return Text(
      data,
      style: TextStyle(fontSize: size, color: color, fontWeight: weight),
    );
  }

  Widget _rowText(String data, String data2,
      {FontWeight fontWeight = FontWeight.w400, double size = 12}) {
    return Row(
      children: [
        SizedBox(
            width: 100,
            child: Text(
              data,
              style: TextStyle(
                  color: Colors.black, fontSize: size, fontWeight: fontWeight),
            )),
        Flexible(
            child: Text(
              data2,
              style: TextStyle(
                  fontSize: size, color: Color(0xFFAAAAAA), fontWeight: fontWeight),
            ))
      ],
    );
  }
}

class Info {
  String name = "";
  String image = "";
  String detail = "";
  bool info = false;

  Info(this.name, this.detail, this.info, this.image);
}