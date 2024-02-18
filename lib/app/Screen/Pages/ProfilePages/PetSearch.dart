import 'package:animal/app/Controllers/ProfileController.dart';
import 'package:animal/app/Model/PetDiscription.dart';
import 'package:animal/app/Screen/Pages/ProfilePages/DiscptionPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../config.dart';
import '../../../Widget/Colors.dart';

class PetSearch extends GetView<ProfileController> {
   PetSearch({super.key});
  RxList<PetDescription> filteredList = <PetDescription>[].obs;
  @override
  Widget build(BuildContext context) {
    Config().init(context);
    final width = Config.screenWidth;
    final height = Config.screenHeight;
    print("petSearch ${controller.petDescription.length}");
    List<PetDescription> dataList = controller.petDescription;
    // RxList<PetDescription> filteredList = <PetDescription>[].obs;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                 Get.back();
                },
                icon: const Icon(Icons.arrow_back_ios_new)),
            MaterialButton(
              onPressed: () =>_showBottomSheetImage(context),
              height: height! * 0.05,
              color: const Color(0xFF777B9F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Center(
                child: Text(
                  "Scan your Pet",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Card(
              child: TextField(
                controller: controller.text,
                onChanged: (query) {
                  filteredList.assignAll(controller.petDescription
                      .where((pet) => pet.species!
                          .toLowerCase()
                          .contains(query.toLowerCase()))
                      .toList());
                  print("FiltterList ${filteredList.length}");
                },
                onTap: () {
                  filteredList.assignAll(controller.petDescription
                      .where((pet) => pet.species!
                          .toLowerCase()
                          .contains(controller.text.text.toLowerCase()))
                      .toList());
                },
                decoration: InputDecoration(
                  labelText: 'Search by pet name',
                ),
              ),
            ),
            Expanded(
              child: Obx(() => controller.petDescription.isEmpty
                  ? Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Nothing to show.',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                              onPressed: () {}, icon: const Icon(Icons.refresh))
                        ],
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: false,
                      physics: const AlwaysScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: width! / (height * 0.8),
                        crossAxisSpacing: 8.0,
                      ),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        PetDescription pet = filteredList[index];
                        // print("${pet.image} $pet");
                        return InkWell(
                          onTap: () => showBottomSheet(
                            context: context,
                            builder: (context) =>
                                DescriptionPage(context, pet, true),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: height * 0.26,
                                width: width,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: Image.network(
                                  pet.image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                pet.species!,
                                style: const TextStyle(fontSize: 19),
                              ),
                            ],
                          ),
                        );
                      },
                    )),
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheetImage(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        backgroundColor: mobileBackgroundColor,
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              //pick profile picture label
              const Text('Pick A Image ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w500)),

              //for adding some space
              SizedBox(height: mq.height * .02),

              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //pick from gallery button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        int result =
                        await controller.pickImage(source: ImageSource.gallery);
                        if (result != null) {
                          filteredList.assign(controller.petDescription[result]);
                          print(controller.petDescription[result].species);
                        }
                      },
                      child: Image.asset('assets/Aj2.png')),

                  //take picture from camera button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        int result = await controller.pickImage(
                            source: ImageSource.camera);
                        if (result != null) {
                          filteredList.assign(controller.petDescription[result]);
                          print(controller.petDescription[result].species);
                          Get.back();
                        }
                      },
                      child: Image.asset('assets/Aj.png')),
                ],
              )
            ],
          );
        });
  }
}
