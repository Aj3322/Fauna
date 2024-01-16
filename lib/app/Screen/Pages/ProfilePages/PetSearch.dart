import 'package:animal/app/Controllers/ProfileController.dart';
import 'package:animal/app/Model/PetDiscription.dart';
import 'package:animal/app/Screen/Pages/ProfilePage.dart';
import 'package:animal/app/Screen/Pages/ProfilePages/DiscptionPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../config.dart';
import '../../../Model/Pet.dart';
class PetSearch extends GetView<ProfileController> {
  const PetSearch({super.key});

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    final width = Config.screenWidth;
    final height = Config.screenHeight;
    print("petSearch ${controller.petDescription.length}");
    List<PetDescription> dataList = controller.petDescription;
    RxList<PetDescription> filteredList = <PetDescription>[].obs;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(onPressed: (){ProfilePage().isOpen.value=0;ProfilePage().isOpen.refresh();}, icon: const Icon(Icons.arrow_back_ios_new)),
            MaterialButton(
              onPressed: () async {
                int  result = await controller.pickImage(source: ImageSource.gallery);
                if (result != null) {
                 filteredList.assign(controller.petDescription[result]);
                 print(controller.petDescription[result].species);
                }
              },

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
                      .where((pet) =>
                      pet.species!.toLowerCase().contains(query.toLowerCase()))
                      .toList());
                  print("FiltterList ${filteredList.length}");
                },
                onTap:(){
                  filteredList.assignAll(controller.petDescription
                      .where((pet) =>
                      pet.species!.toLowerCase().contains(controller.text.text.toLowerCase()))
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
                          onTap: ()=>showBottomSheet(context: context, builder: (context) => DescriptionPage(context,pet,true),),
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
}
