import 'dart:developer';
import 'dart:io';
import 'package:animal/app/Controllers/ChatController.dart';
import 'package:animal/app/Screen/ChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../Model/Message.dart';
import '../Model/User.dart';
import '../Widget/Colors.dart';
import 'MessageCard.dart';
class ChatScreenDetail extends GetView<ChatController> {
  final Users user;
  ChatScreenDetail({super.key, required this.user});
  List<Message> _list = [];
  String? _image;
  final _textController = TextEditingController();
  //showEmoji -- for storing value of showing or hiding emoji
  //isUploading -- for checking if image is uploading or not?
  RxBool _showEmoji = false.obs, _isUploading = false.obs;
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          //if emojis are shown & back button is pressed then hide emojis
          //or else simple close current screen on back button click
          onWillPop: () {
            if (_showEmoji.value) {
             _showEmoji.value = false;
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              // backgroundColor: mobileBackgroundColor,
              title: Text(
                user.name,
                style: const TextStyle(
                  // color: headerColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    // color: headerColor,
                    size: 35,
                  ),
                  onPressed: () {
                   Get.back();
                  }),
              leadingWidth: 20,
            ),

            // backgroundColor:mobileBackgroundColor,

            //body
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: controller.getAllMessages(user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                      //if data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const SizedBox();

                      //if some or all data is loaded then show it
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          _list = data
                              ?.map((e) => Message.fromJson(e.data()))
                              .toList() ??
                              [];

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                                reverse: true,
                                itemCount: _list.length,
                                padding: EdgeInsets.only(top: mq.height * .01),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return MessageCard(message: _list[index],photoUrl: user.image,);
                                });
                          } else {
                            return const Center(
                              child: Text('Say Hii! 👋',
                                  style: TextStyle(fontSize: 20,)),
                            );
                          }
                      }
                    },
                  ),
                ),
                //progress indicator for showing uploading
               Obx(() =>  _isUploading.value?
          const Align(
          alignment: Alignment.centerRight,
          child: Padding(
              padding:
              EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: CircularProgressIndicator(strokeWidth: 2))):Container()),

                //chat input filed
                Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Row(
                    children: [
                      //input field & buttons
                      Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          // color: textColor,
                          child: Row(
                            children: [
                              //emoji button
                              IconButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    _showEmoji.value = !_showEmoji.value;
                                  },
                                  icon: const Icon(Icons.emoji_emotions,
                                      size: 25)),

                              Expanded(
                                  child: TextField(
                                    controller: _textController,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    onTap: () {},
                                    decoration: const InputDecoration(
                                        hintText: 'Type Something...',
                                        // hintStyle: TextStyle(color: primaryColor),
                                        border: InputBorder.none),
                                  )),

                              //pick image from gallery button
                              IconButton(
                                  onPressed: () {_showBottomSheetImage(context);},
                                  icon: const Icon(Icons.image,
                                      color: headerColor, size: 26)),

                              //take image from camera button
                              IconButton(
                                  onPressed: () {
                                    if (_textController.text.isNotEmpty) {
                                      if (_list.isEmpty) {
                                        //on first message (add user to my_user collection of chat user)
                                       controller.sendFirstMessage(
                                            user, _textController.text, Type.text);
                                      } else {
                                        //simply send message
                                        controller.sendMessage(
                                            user, _textController.text, Type.text);
                                      }
                                      _textController.text = '';
                                    }
                                    _textController.text = '';
                                  },
                                  icon: const Icon(Icons.send,
                                      color: headerColor, size: 26)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // //show emojis on keyboard emoji button click & vice versa
                // _showEmoji.value?
                //   SizedBox(
                //     height: mq.height * .35,
                //     child: EmojiPicker(
                //       textEditingController: _textController,
                //       config: Config(
                //         bgColor: const Color.fromARGB(255, 234, 248, 255),
                //         columns: 8,
                //         emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                //       ),
                //     ),
                //   )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheetImage(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        backgroundColor: mobileBackgroundColor,
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
            EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              //pick profile picture label
              const Text('Pick A Image ',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: primaryColor,fontSize: 20, fontWeight: FontWeight.w500)),

              //for adding some space
              SizedBox(height: mq.height * .02),

              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //pick from gallery button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 70);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          _isUploading.value = true;
                          _isUploading.refresh();
                          Navigator.pop(context);
                          await controller.sendChatImage(
                              user, File(image.path));
                          _isUploading.value = false;
                          _isUploading.refresh();
                          // for hiding bottom sheet

                        }
                      },
                      child: Image.asset('assets/Aj2.png')),

                  //take picture from camera button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 70);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                         _isUploading.value = true;
                          _isUploading.refresh();
                          Navigator.pop(context);
                          await controller.sendChatImage(
                              user, File(image.path));
                          _isUploading.value = false;
                          _isUploading.refresh();

                        }
                      },
                      child: Image.asset('assets/Aj.png')),
                ],
              )
            ],
          );
        });}
}