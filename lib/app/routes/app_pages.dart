import 'package:animal/app/Bindings/AdoptionBinding.dart';
import 'package:animal/app/Bindings/LocationBinding.dart';
import 'package:animal/app/Bindings/LogInBinding.dart';
import 'package:animal/app/Bindings/NetworkBinding.dart';
import 'package:animal/app/Bindings/SellProductBinding.dart';
import 'package:animal/app/Bindings/SignUpBinding.dart';
import 'package:animal/app/Controllers/ProfileController.dart';
import 'package:animal/app/Screen/Detail.dart';
import 'package:animal/app/Screen/LogIn.dart';
import 'package:animal/app/Screen/Pages/Adopted/AdoptedPages.dart';
import 'package:animal/app/Screen/Pages/HomePage.dart';
import 'package:animal/app/Screen/Pages/LocationPage.dart';
import 'package:animal/app/Screen/Pages/PostPages/PostPage.dart';
import 'package:animal/app/Screen/Pages/ProfilePages/ProfilePage.dart';
import 'package:animal/app/Screen/SellProduct.dart';
import 'package:animal/app/Screen/SignUp.dart';
import 'package:animal/app/Screen/home_view.dart';
import 'package:animal/app/Widget/Text.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import '../Bindings/ProfileBinding.dart';
import '../Screen/Spalash.dart';
import '../Bindings/home_binding.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
        name: _Paths.SPLASH, // Add the splash screen route
        page: () => SplashScreen(),
        transition: Transition.zoom,
        binding: NetworkBinging()),
    GetPage(
        name: _Paths.HOME,
        page: () => const FeedScreen(),
        binding: HomeBinding(),
        transition: Transition.leftToRight,
    ),
    GetPage(
        name: _Paths.LOGIN,
        page: () => LogIn(),
        binding: LogInBinding(),
        transition: Transition.rightToLeft),
    GetPage(
        name: _Paths.SIGNUP,
        page: () => SignUp(),
        binding: SignUpBinding(),
        transition: Transition.zoom),
    GetPage(
        name: _Paths.PROFILE,
        page: () => ProfilePage(),
        binding: ProfileBinding(),
        transition: Transition.zoom),
    GetPage(
      name: _Paths.SELLPRODUCT,
      page: () => SellProductPage(),
      binding: SellProductBinding(),
      transition: Transition.zoom,
    ),
    // GetPage(
    //   name: _Paths.DETAILACTIVITY,
    //   page: () => DetailActivity(),
    //   transition: Transition.zoom,
    // ),
    GetPage(
      name: _Paths.ADOPTION,
      page: () => const AdoptedPage(),
      binding: AdoptionBinding(),
      transition: Transition.zoom,
    ),
    GetPage(
      name: _Paths.LOCATION,
      page: () => LocationPage(),
      binding: LocationBinding(),
      transition: Transition.zoom,
    ),
    GetPage(
      name: _Paths.MARKETPLACE,
      page: () => const HomePage(),
      binding: LocationBinding(),
      transition: Transition.zoom,
    ),
  ];
}
