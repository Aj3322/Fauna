import 'package:animal/app/Model/User.dart';
import 'package:animal/app/Widget/DrawerWidget.dart';
import 'package:animal/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ProfileOfOther extends StatelessWidget {
  final Users users;
  ProfileOfOther(this.users,{super.key});
  RxBool isMedical = false.obs,isAddPet = false.obs;
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(
                          users.image,
                        ),
                      ),
                      SizedBox(
                        height: height! * 0.005,
                      ),
                       Text(
                        users.name,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: height * 0.002,
                      ),
                      Text(
                        users.email,
                        style: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w300),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('My Pets',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: users.petDescription.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: (){
                              // Get.to(DescriptionPage(context,controller.users.value.petDescription[index-1],false),transition: Transition.circularReveal);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Image.network(
                                users.petDescription[index].image!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}