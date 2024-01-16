// class MyApiClient extends GetConnect {
//   Future<void> registerWithEmail() async {
//     try {
//       var headers = {'Content-Type': 'application/json'};
//       var url = Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.registerEmail);
//       Map body = {
//         'username': nameController.text,
//         'email': emailController.text.trim(),
//         'password': passwordController.text
//       };
//
//       final response = await post(url, body: jsonEncode(body), headers: headers);
//
//       if (response.statusCode == 200) {
//         final json = jsonDecode(response.body);
//         if (json['code'] == 0) {
//           var token = json['token'];
//           print(token);
//
//           final SharedPreferences? prefs = await _prefs;
//           await prefs?.setString('token', token);
//
//           nameController.clear();
//           emailController.clear();
//           passwordController.clear();
//
//           Get.dialog(
//             SimpleDialog(
//               title: Text('Error'),
//               contentPadding: EdgeInsets.all(20),
//               children: [Text(json['token'].toString())],
//             ),
//           );
//           // Go to home
//         } else {
//           throw jsonDecode(response.body)['msg'] ?? "Unknown Error Occurred";
//         }
//       }
//     } catch (e) {
//       print(e);
//       Get.back();
//       Get.dialog(
//         SimpleDialog(
//           title: Text('Error'),
//           contentPadding: EdgeInsets.all(20),
//           children: [Text(e.toString())],
//         ),
//       );
//     }
//   }
// }
