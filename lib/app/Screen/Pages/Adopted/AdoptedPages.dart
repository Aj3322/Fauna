import 'package:animal/app/Controllers/AdoptController.dart';
import 'package:animal/app/Screen/Detail.dart';
import 'package:animal/app/Screen/Pages/Adopted/Donate.dart';
import 'package:animal/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Model/Pet.dart';

class AdoptedPage extends GetView<AdoptedController> {
  const AdoptedPage({Key? key}) : super(key: key);
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
        if (AdoptedPage.isDetail.value) {
          AdoptedPage.isDetail.value = false;
          AdoptedPage.isDetail.refresh();
          return false; // Prevent default behavior (pop the route)
        }
        return true; // Allow default behavior (pop the route)
      },
      child: Obx(() => isDetail.value
          ?
      // DetailActivity(dataList[indexOfPet])
      const DonatePage()
          : Container(
        margin: EdgeInsets.symmetric(horizontal: width! * 0.04)
            .copyWith(top: height! * 0.04),
        height: height,
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height * 0.07,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Find Your New Friend',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                   ElevatedButton(onPressed: (){AdoptedPage.isDetail.value=true; AdoptedPage.isDetail.refresh();},style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)), child: const Text("Post",style: TextStyle(color: Colors.black),)),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Obx(() => controller.PetData.isEmpty
                  ? Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Nothing to show.',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(onPressed: (){controller.fetchData();}, icon: const Icon(Icons.refresh))
                  ],
                ),
              )
                  : GridView.builder(
                shrinkWrap: false,
                physics: const AlwaysScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                      Container(
                        height: height * 0.26,
                        width: width,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Image.network(
                          dataList[index].profileUrls[0],
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        pet.name,
                        style: const TextStyle(fontSize: 19),
                      ),
                    ],
                  );
                },
              )),
            ),
          ],
        ),
      )
      ),
    );
  }
}
