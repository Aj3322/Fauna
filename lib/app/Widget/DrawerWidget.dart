import 'package:animal/app/Controllers/ProfileController.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';

class DrawerWidget extends GetView<ProfileController> {
  const DrawerWidget({super.key});


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(controller.users.value.name),
                  accountEmail: Text(controller.users.value.email),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(
                      controller.users.value.image,
                    ),
                  ),
                  onDetailsPressed: (){Get.back();Get.toNamed(Routes.PROFILE);},
                ),
                ListTile(
                  title: const Text(' Home'),
                  leading: const Icon(FontAwesomeIcons.home),
                  onTap: () {
                    Get.back();
                    Get.toNamed(Routes.HOME);
                  },
                ),
                ListTile(
                  title: const Text(' Service'),
                  leading: const Icon(FontAwesomeIcons.hospital),
                  onTap: () {
                    Get.back();
                    Get.toNamed(Routes.LOCATION);
                  },
                ),
                ListTile(
                  title: const Text('Adoption Forum'),
                  leading: const Icon(Icons.pets_outlined, size: 30),
                  onTap: () {
                    Get.toNamed(Routes.ADOPTION);
                  },
                ),
                ListTile(
                  title: const Text('Marketplace'),
                  leading: const Icon(Icons.shopping_bag_outlined, size: 30),
                  onTap: () {
                    Get.back();
                    Get.toNamed(Routes.MARKETPLACE);
                  },
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('LogOut'),
            leading: const Icon(Icons.logout),
            onTap: () {
              controller.SignOut();
            },
          ),
        ],
      ),
    );
  }
}
