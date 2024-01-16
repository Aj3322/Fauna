import 'package:animal/app/Controllers/home_controller.dart';
import 'package:animal/app/Screen/Detail.dart';
import 'package:animal/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Model/Pet.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);
  static RxBool isDetail = false.obs;
  static int indexOfPet = 0;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    var width = Config.screenWidth;
    var height = Config.screenHeight;
    List<Pet> dataList = controller.PetData;
    return WillPopScope(
      onWillPop: () async {
        if (HomePage.isDetail.value) {
          HomePage.isDetail.value = false;
          HomePage.isDetail.refresh();
          return false; // Prevent default behavior (pop the route)
        }
        return true; // Allow default behavior (pop the route)
      },
      child: Obx(() => isDetail.value
          ? DetailActivity(dataList[indexOfPet])
          : Container(
              margin: EdgeInsets.symmetric(horizontal: width! * 0.04)
                  .copyWith(top: height! * 0.04),
              height: height,
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: height * 0.06,
                    alignment: Alignment.center,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "MarketPlace",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.search, size: 25, color: Colors.black38),
                            SizedBox(width: 5),
                            Icon(Icons.bookmark,
                                size: 25, color: Colors.black38),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(() => controller.PetData.isEmpty
                        ? const Center(
                            child: Text(
                              'Nothing to show.',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          )
                        : GridView.builder(
                            shrinkWrap: false,
                            physics: const AlwaysScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: width / (height * 0.8),
                              crossAxisSpacing: 8.0,
                            ),
                            itemCount: dataList.length,
                            itemBuilder: (context, index) {
                              Pet pet = dataList[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      indexOfPet = index;
                                      isDetail.value = true;
                                      isDetail.refresh();
                                    },
                                    child: Container(
                                      height: height * 0.26,
                                      width: width,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                      child: Image.network(
                                        dataList[index].profileUrls[0],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '\$ ${pet.prize}',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      pet.bred,
                                      style: const TextStyle(
                                          fontSize: 16.0, color: Colors.black),
                                    ),
                                  ),
                                ],
                              );
                            },
                          )),
                  ),
                ],
              ),
            )),
    );
  }
}
