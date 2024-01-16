import 'package:flutter/material.dart';
import 'package:get/get.dart';
class TrackOrdersPage extends GetView {
  const TrackOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Track Orders"),
      ),
      body: Column(
        children: [
          Divider(thickness: 2, color: Colors.black),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Track Orders"),
                  Icon(
                    Icons.navigate_next,
                    size: 30,
                  )
                ],
              ),
            ),
          ),
          Divider(thickness: 2, color: Colors.black),
        ],
      ),
    );
  }
}
