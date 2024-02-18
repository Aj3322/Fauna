import 'package:animal/app/Controllers/home_controller.dart';
import 'package:animal/app/Model/Pet.dart';
import 'package:animal/app/Screen/ChatScreen.dart';
import 'package:animal/app/Screen/Pages/HomePage.dart';
import 'package:animal/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
class DetailActivity extends GetView<HomeController> {
  final Pet pet;
  const DetailActivity(this.pet, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(height: 30,),
            Stack(
              children: [
                Container(
                  width: double.infinity ,
                  height: 221,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: NetworkImage(pet.profileUrls[0]
                      ),
                      fit: BoxFit.fill,
                    ),
                    shape:  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: CircleAvatar(
                    radius: 23,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      onPressed:()=>Get.back(),
                      icon: const Icon(Icons.arrow_back_ios_new, size: 27, color: Colors.black  ),
                    ),
                  ),
                ),

              ],
            ),

            Text(pet.name, style: _textStyle(18, FontWeight.w400)),
            Text('₹ ${pet.prize}', style: _textStyle(19.42, FontWeight.w700)),
            _descriptionText('Description', pet.description),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sold By',style:_textStyle(12, FontWeight.w400,color: Colors.blue)),
                    Text(pet.name, style: _textStyle(12, FontWeight.w400)),
                  ],
                ),
                SizedBox( width: 100,child: OutlinedButton(onPressed: (){}, child: const Text("View") ))
              ],
            ),
            Text('Details',style:_textStyle(15, FontWeight.w400,color: Colors.blue),),
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Breed name ', style:_textStyle(12, FontWeight.w400)),
                    Text('Age', style:_textStyle(12, FontWeight.w400)),
                    Text('Height', style:_textStyle(12, FontWeight.w400)),
                    Text('Color', style:_textStyle(12, FontWeight.w400)),
                  ],
                ),
                const SizedBox(width: 30,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pet.bred, style:_textStyle(12, FontWeight.w400)),
                    Text('${pet.ageInMonths} Months', style:_textStyle(12, FontWeight.w400)),
                    Text('${pet.heightInFeet} feet', style:_textStyle(12, FontWeight.w400)),
                    Text(pet.color, style:_textStyle(12, FontWeight.w400)),
                  ],
                )
              ],
            ),
            Row(
              children: [
                IconButton(onPressed: (){}, icon: const Icon(Icons.location_on_outlined,size: 27,)),
                Text(pet.address,style: _textStyle(12, FontWeight.w400),)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width*0.4,
                    height: 45,
                    child: ElevatedButton(onPressed: () {}, child: const Text("Call"))),
                SizedBox(
                    width: MediaQuery.of(context).size.width*0.40,
                    height: 45,
                    child: ElevatedButton(onPressed: () {Get.to(ChatScreen()); }, child: const Text("Chat"))),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text("Reviews", style: _textStyle(14, FontWeight.w500),),
                SizedBox(width: 138,child: OutlinedButton(onPressed: (){}, child: const Text("Write a review") ))
              ],
            ),
            Expanded(
              child: ListView.builder(itemCount: 1 ,itemBuilder: (context, index) => SizedBox( width: double.infinity,height: 75,child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10).copyWith(bottom: 0),
                    child: const Row(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.blue,
                        ),
                        SizedBox(width: 10,),
                        Text("Sahil")
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10,top: 5),
                      child: RatingBar.builder(
                        initialRating:4.5,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 17.0,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          // Handle rating update if needed
                        },
                      ),
                    ),
                  ),
                ],
              ),),),
            )
          ],
        ),
      ),
    );
  }

  TextStyle _textStyle(double fontSize, FontWeight fontWeight, {Color color = Colors.black}) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: 'Poppins',
      fontWeight: fontWeight,
      height: 0,
    );
  }

  Widget _descriptionText(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: _textStyle(14, FontWeight.w600, color: Colors.black)),
        Text(description, style: _textStyle(12, FontWeight.w400, color: const Color(0xFF404040))),
      ],
    );
  }
}
