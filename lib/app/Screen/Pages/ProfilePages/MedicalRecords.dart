import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:http/http.dart' as http;
import '../../../Controllers/MedicalRecordController.dart';

class MedicalRecordsPage extends StatelessWidget {
  final MedicalRecordsController controller = Get.put(MedicalRecordsController());
  MedicalRecordsPage({Key? key}) : super(key: key);
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  Future<String> getMimeType(String url) async {
    final response = await http.head(Uri.parse(url));
    return response.headers['content-type'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Medical Records"),
      ),
      body: Obx(() => ListView.builder(
        itemCount: controller.medicalRecords.length,
        itemBuilder: (context, index) {
          final recordUrl = controller.medicalRecords[index];
          print(recordUrl);

          return FutureBuilder<Card>(
            future: buildCard(context, recordUrl),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return snapshot.data ?? Container(); // Return the Card if available, else an empty container
              } else {
                return Container(); // Return an empty container while the Future is still loading
              }
            },
          );
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                child: Wrap(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.camera),
                      title: Text('Take a Photo'),
                      onTap: () {
                        Navigator.pop(context);
                        controller.getImage(ImageSource.camera);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.image),
                      title: Text('Choose from Gallery'),
                      onTap: () {
                        Navigator.pop(context);
                        controller.getImage(ImageSource.gallery);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.picture_as_pdf),
                      title: Text('Pick PDF or Document'),
                      onTap: () {
                        Navigator.pop(context);
                        controller.pickPdfOrDocument();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<Card> buildCard(BuildContext context, String recordUrl) async {
    final mimeType = await getMimeType(recordUrl);

    if (mimeType.toLowerCase().contains('pdf')) {
      return Card(
        elevation: 6.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: InkWell(
            onTap: () {
              _pdfViewerKey.currentState?.openBookmarkView();
            },
            child: SizedBox(
              height: 100,
              child: SfPdfViewer.network(
                recordUrl,
                key: _pdfViewerKey,
              ),
            ),
          ),
        ),
      );
    } else if (mimeType.toLowerCase().contains('image')) {
      return Card(
        elevation: 6.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: SizedBox(
            height: 100,
            child: Image.network(
              recordUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    } else {
      print(mimeType);
      return Card(
        elevation: 6.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Center(
            child: Text(
              'Unsupported File Type',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ),
      );
    }
  }
}
