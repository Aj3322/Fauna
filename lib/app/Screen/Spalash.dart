import 'package:animal/app/Controllers/SharedPrifrence.dart';
import 'package:animal/app/routes/app_pages.dart';
import 'package:animal/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends GetView<SharedPrefController> {
  const SplashScreen({super.key});
  static FirebaseAuth _auth = FirebaseAuth.instance;
   determineInitialRoute(){
    // if (controller.checkFirebaseAuth()) {
    //   return Routes.HOME;
    // } else {

      if (_auth.currentUser != null) {
        print(controller.isLoggedIn.value);
        return Routes.HOME;
      } else {
        return Routes.LOGIN;
      }
    // }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () {
      Get.offNamed(determineInitialRoute());
    });

    return  Scaffold(
      body: Center(
        child: SizedBox(
          height: Config.screenHeight,
          width: Config.screenWidth,
          child: Center(
            child: Image.asset('assets/logo.png',height: 50,
            ),
          ),
        ),
      ),
    );
  }
}
//
// class CircleGradientAvatar extends StatelessWidget {
//   final String imageUrl;
//   final double radius;
//
//   const CircleGradientAvatar({
//     required this.imageUrl,
//     required this.radius,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         gradient: RadialGradient(
//           colors: [
//             Colors.orange.shade900,
//             Colors.orange.shade800,
//             Colors.orange.shade400,
//           ],
//           stops: [0.0, 0.3, 1.0], // Adjust the stops to match the colors
//         ),
//       ),
//       child: CircleAvatar(
//         backgroundColor: Colors.transparent,
//         radius: radius,
//         child: ClipOval(
//           child: Image.asset(
//             imageUrl,
//             width: radius * 2,
//             height: radius * 2,
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
