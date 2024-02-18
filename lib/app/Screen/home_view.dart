import 'package:animal/app/Controllers/AdoptController.dart';
import 'package:animal/app/Controllers/PostController.dart';
import 'package:animal/app/Controllers/ProfileController.dart';
import 'package:animal/app/Screen/Pages/Adopted/AdoptedPages.dart';
import 'package:animal/app/Screen/Pages/HomePage.dart';
import 'package:animal/app/Screen/Pages/LocationPage.dart';
import 'package:animal/app/Screen/Pages/PostPages/PostPage.dart';
import 'package:animal/app/Screen/Pages/ProfilePages/ProfilePage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class HomeView extends GetView {
  final PageController _pageController = PageController();
  var currentPage = 0.obs;
  final Map<int, GetxController> controllers = {};

  void bindController(int index) {
    switch (index) {
      case 0:
      // Bind controller for HomePage
        Get.lazyPut<ProfileController>(() => ProfileController());
        Get.lazyPut<PostController>(() => PostController());
        break;
      case 1:
        // LocationController controller = LocationController();
        // controller.fetchData();
        break;
      case 2:
      // Bind controller for AssistancePage
        Get.lazyPut<AdoptedController>(() => AdoptedController());
        break;
      case 3:
      // Bind controller for ProfilePage
        Get.lazyPut<ProfileController>(() => ProfileController());
        break;
      case 4:
      // Bind controller for ProfilePage
        Get.lazyPut<ProfileController>(() => ProfileController());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    bindController(currentPage.value);
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (int index) {
          if (kDebugMode) {
            print('Page changed to: $index');
          }
          currentPage.value = index;
          bindController(index);
        },
        children:  [
          // Home Page
          const FeedScreen(),
          // Location Page
          LocationPage(),
          // Assistant Page
          AdoptedPage(),
          // Profile Page
          HomePage(),
          ProfilePage(),

        ],
      ),
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.home, color: Colors.blue ),
              activeIcon: FaIcon(FontAwesomeIcons.home, color: Colors.red),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.hospital, color: Colors.blue),
              activeIcon: FaIcon(FontAwesomeIcons.hospital, color: Colors.red),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pets_outlined, color: Colors.blue),
              activeIcon: Icon(Icons.pets, color: Colors.red),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.shop, color: Colors.blue),
              activeIcon: FaIcon(FontAwesomeIcons.shop, color: Colors.red),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: CircleAvatar(backgroundColor: Colors.blue ,radius: 17,),
              label: '',
            ),
          ],
          currentIndex: currentPage.value,
          onTap: (index) {
            bindController(index);
            print('Tab tapped: $index');
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          selectedItemColor: Colors.red,
        ),
      ),
    );
  }
}
