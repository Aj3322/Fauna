import 'package:animal/app/Controllers/ChatController.dart';
import 'package:animal/app/Controllers/ProfileController.dart';
import 'package:animal/app/Screen/ChatDetails.dart';
import 'package:animal/app/Screen/Pages/ProfilePages/ProfilePage.dart';
import 'package:animal/app/Widget/Profile_ofOther.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../Model/Message.dart';
import '../Model/User.dart';
import '../data/Date_formate.dart';

class ChatScreen extends GetView<ChatController> {
  ChatScreen({Key? key}) : super(key: key);
  Message? _message;
  bool msg =false;
  late Users users ;
  @override
  Widget build(BuildContext context) {
    Message? _message;
    bool msg =false;
    bool userIds=false;
    return
     Scaffold(
        appBar: AppBar(
          title: const Text(
            'Chat',
          ),
          elevation: 0,
          // backgroundColor: mobileBackgroundColor,
          leadingWidth: 20,
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                // color: headerColor,
                size: 35,
              ),
              onPressed: () => Get.back()),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton(
            // backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              onPressed: () {_showBottomSheetImage(context);},
              child: const Icon(
                Icons.add,
                size: 38,
                color: Colors.white,
              )),
        ),
        body: StreamBuilder(
          stream: controller.getMyUsersId(),
          builder: (context,  snapshot) {
            return StreamBuilder(
              stream: controller.getAllUsers(snapshot.data?.docs.map((e) => e.id).toList()??[]),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {

                    users= Users.fromSnapshot((snapshot.data! as dynamic).docs[index]);

                    return  (snapshot.data! as dynamic).docs[index]['uid']==ProfileController().users.value.uid?const Divider(height: 0,):InkWell(
                      onTap: () {

                      },
                      child: Column(
                        children: [
                          ListTile(
                            onTap: (){
                              Get.back();
                             Get.off(ChatScreenDetail(user: users),transition: Transition.zoom);
                            },
                            leading: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.red,
                                    Colors.yellow,
                                    Colors.orange,
                                    Colors.redAccent
                                  ],
                                ),),
                              child: ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(12)),
                                child: SizedBox(
                                  width:45 ,
                                  height: 45,
                                  child: Image.network( (snapshot.data! as dynamic).docs[index]['image'],fit: BoxFit.cover,),

                                ),
                              ),
                            ),
                            title: Text(
                              (snapshot.data! as dynamic).docs[index]['name'],
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: StreamBuilder(
                                stream: controller.getLastMessage(users),
                                builder: (context, snapshot) {
                                  final data = snapshot.data?.docs;
                                  final list = data
                                      ?.map((e) => Message.fromJson(e.data()))
                                      .toList() ??
                                      [];
                                  if (list.isNotEmpty) {_message = list[0];
                                  if(_message!.read.isEmpty){
                                    msg= true;
                                  }
                                  }else{_message=null;}


                                  return  Text(
                                      _message != null
                                          ? _message!.type == Type.image
                                          ? 'image'
                                          : _message!.msg
                                          :'Last Massage',style: const TextStyle(fontSize: 16),
                                      maxLines: 1);
                                }),
                            trailing:  Text(
                                (snapshot.data! as dynamic).docs[index]['is_online']
                                    ? 'Online'
                                    : MyDateUtil.getLastActiveTime(
                                    context: context,
                                    lastActive:  (snapshot.data! as dynamic).docs[index]['last_active']),
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.black54)),
                          ),
                          Container(
                              padding: const EdgeInsets.symmetric(horizontal: 40),
                              child: const Divider(
                                height: 4,
                              ))
                        ],
                      ),
                    );


                  },
                );
              },
            );
          },

        )

    );
  }
  void _showBottomSheetImage(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        // backgroundColor: mobileBackgroundColor,
        builder: (_) {
          return _bodyDialog();
        });}


  Widget _bodyDialog(){
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: (snapshot.data! as dynamic).docs.length,
          itemBuilder: (context, index) {
            Users user = ProfileController().users.value;
            return  (snapshot.data! as dynamic).docs[index]['uid']==user.uid?const Text(''):InkWell(
              onTap: () {
                Get.back();
                Get.to(ProfileOfOther(Users.fromSnapshot((snapshot.data! as dynamic).docs[index])));
              },
              child: Column(
                children: [
                  ListTile(
                    leading:CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage((snapshot.data! as dynamic).docs[index]['image']),
                    ),
                    // Container(
                    //   decoration: const BoxDecoration(
                    //     borderRadius: BorderRadius.all(Radius.circular(12)),
                    //     gradient: LinearGradient(
                    //       colors: [
                    //         Colors.red,
                    //         Colors.yellow,
                    //         Colors.orange,
                    //         Colors.redAccent
                    //       ],
                    //     ),),
                    //   child: ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(12)),
                    //     child: SizedBox(
                    //       width:40 ,
                    //       height: 40,
                    //       child: Image.network( ,fit: BoxFit.cover,),
                    //
                    //     ),
                    //   ),
                    // ),
                    title: Text(
                      (snapshot.data! as dynamic).docs[index]['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle:Text((snapshot.data! as dynamic).docs[index]['about'],
                        style: const TextStyle(fontWeight: FontWeight.w400)),
                    trailing:IconButton(onPressed: (){
                      Get.back();
                      print(Users.fromSnapshot((snapshot.data! as dynamic).docs[index]));
                     Get.to(ChatScreenDetail(user: Users.fromSnapshot((snapshot.data! as dynamic).docs[index])));
                    }, icon: const Icon(Icons.message_rounded),),
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: const Divider(
                        height: 4,
                      ))
                ],
              ),
            );
          },
        );
      },
    );
  }
}