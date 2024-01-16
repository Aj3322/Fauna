import 'package:flutter/material.dart';

class VaccineSchedulesPage extends StatelessWidget {
   VaccineSchedulesPage({super.key});
 TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Track Orders"),
      ),
      bottomNavigationBar:TextField(
        controller: textController,
        style: const TextStyle(
          color: Color(0xFFB3B3B7),
          fontSize: 12,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          height: 0.12,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFFF5F5F5),
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: 'Enter text',
          hintStyle: const TextStyle(
            color: Color(0xFFB3B3B7),
            fontSize: 12,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            height: 0.12,
          ),
        ),
      )
    );
  }
}

// Repeat similar code structure for other pages like VaccineSchedulesPage, ScheduledVisitsPage, CarePlansPage, etc.
