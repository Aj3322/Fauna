import 'package:animal/app/Controllers/ProfileController.dart';
import 'package:animal/app/Model/PetDiscription.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import 'ProfilePage.dart';

class DescriptionPage extends GetView<ProfileController> {
  BuildContext context1;
  PetDescription petDescription;
  bool isPetSearch;
  DescriptionPage(this.context1,this.petDescription,this.isPetSearch, {super.key});
  final RxBool isMedical = false.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height*0.25,
              child: Image.network(petDescription.image!,fit: BoxFit.cover,),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _textWidget(petDescription.species!, size: 31, weight: FontWeight.w400),
                    const SizedBox(
                      height: 10,
                    ),
                    Obx(
                          () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              isMedical.value = false;
                              isMedical.refresh();
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
                          isPetSearch?Container():
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
                    Obx(()=>isMedical.value ? _medicalRecord(context1): _bottomSheet(context1)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomSheet(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _textWidget("General information", size: 14, weight: FontWeight.w600),
        const SizedBox(
          height: 10,
        ),
        _rowText("Lifespan", petDescription.lifeSpan!),
        _rowText("Height", petDescription.heights!),
        _rowText("Strength", "Surprisingly strong for their size"),
        _rowText("Characteristics",
            petDescription.characterstics!),
        _rowText("Color",
            petDescription.colors!),
        const SizedBox(
          height: 10,
        ),
        _textWidget("About",
            size: 14, weight: FontWeight.w600),
        // const SizedBox(height: 10,),
        _textWidget(petDescription.description!,
            size: 12,
            weight: FontWeight.w400,
            color: const Color(0xFFAAAAAA)),
        _widgetRowData("assets/img_7.png", "Diet"),
        const SizedBox(
          height: 10,
        ),
        _textWidget(petDescription.diet!,
            size: 12,
            weight: FontWeight.w400,
            color: const Color(0xFFAAAAAA)),
        const SizedBox(
          height: 10,
        ),
        _widgetRowData("assets/img_9.png", "Home Care"),
        const SizedBox(
          height: 10,
        ),
        _textWidget(petDescription.homeCare!,
            size: 12,
            weight: FontWeight.w400,
            color: const Color(0xFFAAAAAA)),

        const SizedBox(
          height: 10,
        ),
        _widgetRowData("assets/img_10.png", "Exercise"),
        const SizedBox(
          height: 10,
        ),
        _textWidget(petDescription.exercises!,
            size: 12,
            weight: FontWeight.w400,
            color: const Color(0xFFAAAAAA)),
        const SizedBox(
          height: 10,
        ),
        _widgetRowData("assets/img_11.png", "Frequent Concerns"),
        const SizedBox(
          height: 10,
        ),
        _textWidget(petDescription.frequentConcern!,
            size: 12,
            weight: FontWeight.w400,
            color: const Color(0xFFAAAAAA)),
        const SizedBox(
          height: 10,
        ),
        _widgetRowData("assets/img_12.png", "Warning symptoms"),
        const SizedBox(
          height: 10,
        ),
        _textWidget(petDescription.warningSymptoms!,
            size: 12,
            weight: FontWeight.w400,
            color: const Color(0xFFAAAAAA)),
        const SizedBox(
          height: 10,
        ),
        isPetSearch?Align(alignment: Alignment.center,child: SizedBox(width: MediaQuery.of(context).size.width*0.8 , child: ElevatedButton(onPressed: (){print(petDescription.species); controller.createPet(petDescription,context);},child: Text("Add Pet"),),)):Container()
      ],
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
  Widget _widgetRowData(String imagePath,String data){
    return  Row(
      children: [
        Container(
          width: 27,
          height: 27,
          decoration:BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(width: 5,),
        _textWidget(data, size: 15, weight: FontWeight.w600),
      ],
    );
  }
  Widget _medicalRecord(BuildContext context){
    print("medical Record");
   double width= MediaQuery.of(context).size.width;
    return Expanded(
      child: ListView.builder(itemCount :4 ,itemBuilder: (context, index) => index==0?InkWell(
        onTap: (){
        },
        child: Container(
          width: width*0.8,
          height: 44,
          decoration: ShapeDecoration(
            color: const Color(0x2BABAEB5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          alignment: Alignment.center,
          child: const Text(
            'Add  a new document',
            style: TextStyle(
              color: Color(0xFFB8B7B7),
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              height: 0.12,
            ),
          ),
        ),
      ):
      Container(
        margin: const EdgeInsets.only(top: 10),
        width: 100,
        height: 70,
        decoration: ShapeDecoration(
          color: const Color(0x2BABAEB5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(width: 10,),
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/img_8.png"),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 15,),
           SizedBox(
              width: 120,
              child: Text(
                'Medical record $index',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  height: 0.12,
                ),
              ),
            ),
        ],
      ),
      )
    ),
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
