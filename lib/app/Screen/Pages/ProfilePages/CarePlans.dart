import 'package:flutter/material.dart';

class CarePlanPage extends StatelessWidget {
  const CarePlanPage({super.key});

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
          // Add additional content specific to Track Orders page
          // You can customize the UI for this page here
        ],
      ),
    );
  }
}

// Repeat similar code structure for other pages like VaccineSchedulesPage, ScheduledVisitsPage, CarePlansPage, etc.
