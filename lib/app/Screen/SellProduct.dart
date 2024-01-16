
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/SellProductController.dart';

class SellProductPage extends GetView<SellProductController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sell Pet Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Product Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              buildTextField('Name', controller.nameController),
              buildTextField('Breed', controller.breedController),
              buildTextField('Gender', controller.genderController),
              buildTextField('Weight', controller.weightController),
              buildTextField('Age in Months', controller.ageController),
              buildTextField('Height in Feet', controller.heightController),
              buildTextField('Color', controller.colorController),
              buildTextField('Address', controller.addressController),
              buildTextField('Prize', controller.prizeController),
              buildTextField('Description', controller.descriptionController),
              const SizedBox(height: 16),
              buildImagePicker(), // Added image picker
              const SizedBox(height: 16),
             controller.obx((state) =>  ElevatedButton(
               onPressed: () {
                 controller.sellProduct();
               },
               child: const Text('Sell Product'),
             ),)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(controller: controller),
        ],
      ),
    );
  }

  Widget buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Product Images', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Obx(() {
          return
            GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: controller.images.value.length + 1, // Plus one for the add button
            itemBuilder: (context, index) {
              if (index == controller.images.value.length) {
                // Add button
                return InkWell(
                  onTap: () => controller.pickImage(),
                  child: Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.add, size: 40, color: Colors.grey),
                  ),
                );
              } else {
                // Display selected image
                return Stack(
                  children: [
                    Image.file(controller.images.value[index], fit: BoxFit.cover),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () => controller.removeImage(index),
                        child: const CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.red,
                          child: Icon(Icons.close, size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          );
        }),
      ],
    );
  }
}
