// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class PetSearchScreen extends StatelessWidget {
//   final RxList<PetDescription> petDescriptions;
//
//   PetSearchScreen({required this.petDescriptions});
//
//   @override
//   Widget build(BuildContext context) {
//     RxList<PetDescription> filteredList = <PetDescription>[].obs;
//
//     return
//       Scaffold(
//       appBar: AppBar(
//         title: Text('Pet Search'),
//       ),
//       body:
//       Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               onChanged: (query) {
//                 // Filter the list based on the search query
//                 filteredList.assignAll(petDescriptions
//                     .where((pet) =>
//                     pet.name!.toLowerCase().contains(query.toLowerCase()))
//                     .toList());
//               },
//               decoration: InputDecoration(
//                 labelText: 'Search by pet name',
//               ),
//             ),
//             SizedBox(height: 16),
//             Expanded(
//               child: Obx(() {
//                 if (filteredList.isEmpty) {
//                   return Center(
//                     child: Text('No matching pets found.'),
//                   );
//                 }
//
//                 return ListView.builder(
//                   itemCount: filteredList.length,
//                   itemBuilder: (context, index) {
//                     PetDescription pet = filteredList[index];
//
//                     return ListTile(
//                       title: Text(pet.name ?? ''),
//                       // Add more details or actions as needed
//                     );
//                   },
//                 );
//               }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }





// Expanded(
//   child: Obx(() => controller.petDescription.isEmpty
//       ? Center(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 'Nothing to show.',
//                 style: TextStyle(
//                     fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               IconButton(
//                   onPressed: () {}, icon: const Icon(Icons.refresh))
//             ],
//           ),
//         )
//
//       : GridView.builder(
//           shrinkWrap: false,
//           physics: const AlwaysScrollableScrollPhysics(),
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             childAspectRatio: width! / (height * 0.8),
//             crossAxisSpacing: 8.0,
//           ),
//           itemCount: dataList.length,
//           itemBuilder: (context, index) {
//             PetDescription pet = dataList[index];
//             print("${pet.image} $pet");
//             return InkWell(
//               onTap: ()=>showBottomSheet(context: context, builder: (context) => DescriptionPage(context,pet,true),),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     height: height * 0.26,
//                     width: width,
//                     decoration: const BoxDecoration(
//                       borderRadius:
//                           BorderRadius.all(Radius.circular(15)),
//                     ),
//                     clipBehavior: Clip.hardEdge,
//                     child: Image.network(
//                       pet.image!,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     pet.species!,
//                     style: const TextStyle(fontSize: 19),
//                   ),
//                 ],
//               ),
//             );
//           },
//         )),
// ),