
import 'package:animal/app/Controllers/AdoptController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class DonatePage extends GetView<AdoptedController> {
  const DonatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Flexible(
          child:Text(
            'Create a new Post',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          ),
        ) ,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField('Name', controller.nameController),
              buildTextField('Description', controller.descriptionController),
              buildTextField('Breed', controller.breedController),
              buildTextField('Age in Months', controller.ageController),
              buildTextField('Gender', controller.genderController),
              // buildTextField('Weight', controller.weightController),
              // buildTextField('Height in Feet', controller.heightController),
              buildTextField('Color', controller.colorController),
              // buildTextField('Address', controller.addressController),
              // buildTextField('Prize', controller.prizeController),

              const SizedBox(height: 16),
              buildImagePicker(), // Added image picker
              const SizedBox(height: 16),
              controller.obx((state) =>  Center(
                child: SizedBox(width: 300,
                  child:
                  ElevatedButton(onPressed: (){controller.postProduct();},style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)), child: const Text("Post",style: TextStyle(color: Colors.black),)),
                ),
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
          SizedBox(
            height: 57, // Adjusted height
            child: label == 'Gender'
                ? DropdownButtonFormField<String>(
              value: 'Select the Gender',
              items: ['Select the Gender', 'Male', 'Female', 'Other']
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ),
              )
                  .toList(),
              onChanged: (String? value) {
                controller.text = value ?? '';
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(28))),
                hintText: label,
                hintStyle: const TextStyle(fontSize: 14),
              ),
            )
                : TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(28))),
                hintText: label,
                hintStyle: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }




  Widget buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Images', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                          child:  CircleAvatar(
                            radius: 10,
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
