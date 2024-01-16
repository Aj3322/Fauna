import 'package:animal/app/Bindings/ProfileBinding.dart';
import 'package:animal/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AssistancePage extends GetView<ProfileBinding> {
  AssistancePage({super.key});
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    var width = Config.screenWidth;
    var height = Config.screenHeight;
    final List<String> dataList = [
      'Recommendations',
      'Clinics near you ',
      'Item 3',
      'Item 4',
      'Item 5',
      // Add more items as needed
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: width! * 0.04).copyWith(top: height! * 0.04),
      height: height,
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: height * 0.025,
            margin: EdgeInsets.only(top: 15),
            child: const Text('Hey Lara!'),
          ),
          const Text(
            "How can I help you today?",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            height: height! * 0.045,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Items',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                print('Search query: $value');
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true, // Add this line
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical, // Add this line
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                return Container(
                  height: height! * 0.25,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dataList[index],
                        style: TextStyle(fontSize: 20),
                      ),
                      Container(
                        height: height * 0.2,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Image.asset(
                          'assets/img.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
