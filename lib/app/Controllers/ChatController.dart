import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../Model/Message.dart';
import '../Model/User.dart';

class ChatController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User get user => _auth.currentUser!;
  Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_users')
        .snapshots();
  }
  // for getting all users from firestore database
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
      List<String> userIds) {
    log('\nUserIds: $userIds');

    return _firestore
        .collection('users')
        .where('uid',
        whereIn: userIds.isEmpty
            ? ['']
            : userIds) //because empty list throws an error
    // .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      Users user) {
    return _firestore
        .collection('chats/${getConversationID(user.uid)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }
  FirebaseAuth auth = FirebaseAuth.instance;

  // for accessing cloud firestore database
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for accessing firebase storage
  FirebaseStorage storage = FirebaseStorage.instance;

  // FirebaseMessaging messaging =FirebaseMessaging.instance;




  // chats (collection) --> conversation_id (doc) --> messages (collection) --> message (doc)

  // useful for getting conversation id
  String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // for getting all messages of a specific conversation from firestore database
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      Users user) {
    return firestore
        .collection('chats/${getConversationID(user.uid)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  Future<void> sendFirstMessage(
      Users chatUser, String msg, Type type) async {
    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_users')
        .doc(chatUser.uid)
        .set({});
    await firestore
        .collection('users')
        .doc(chatUser.uid)
        .collection('my_users')
        .doc(user.uid)
        .set({}).then((value) => sendMessage(chatUser, msg, type));
  }

  // for sending message
  Future<void> sendMessage(
      Users chatUser, String msg, Type type) async {
    //message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send
    final Message message = Message(
        toId: chatUser.uid,
        msg: msg,
        read: '',
        type: type,
        fromId: user.uid,
        sent: time);

    final ref = firestore
        .collection('chats/${getConversationID(chatUser.uid)}/messages/');
    await ref.doc(time).set(message.toJson());
        // .then((value) => AuthMethods.sendPushNotification(chatUser,type==Type.text? msg:'Photo'));
  }

  //update read status of message
  Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  //send chat image
  Future<void> sendChatImage(Users chatUser, File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = storage.ref().child(
        'images/${getConversationID(chatUser.uid)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }

  //delete message
  Future<void> deleteMessage(Message message) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .delete();

    if (message.type == Type.image) {
      await storage.refFromURL(message.msg).delete();
    }
  }

  Future<void> deleteMessageUser(Message message) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .delete();

    if (message.type == Type.image) {
      await storage.refFromURL(message.msg).delete();
    }
  }
  // Future<void> updateUserInfo() async {
  //   await _firestore.collection('users').doc(user.uid).update({
  //     'name': me.username,
  //     'about': me.bio,
  //   });
  // }
  // Future<void> sendPushNotification(
  //     Users chatUser, String msg) async {
  //   try {
  //     final body = {
  //       "to": chatUser.pushToken,
  //       "notification": {
  //         "title": me.username, //our name should be send
  //         "body": msg,
  //         "android_channel_id": "chats"
  //       },
  //       // "data": {
  //       //   "some_data": "User ID: ${me.id}",
  //       // },
  //     };
  //
  //     var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //         headers: {
  //           HttpHeaders.contentTypeHeader: 'application/json',
  //           HttpHeaders.authorizationHeader:
  //           'key=AAAAUAQ0LcQ:APA91bFUjFf2Qc1jnAuJcZXSxxL0ZY-XtkOcH01Lu5JlhmEUMBmIKC6YNH9Pid4bzc_OEP_0VN4t2GIRM93HUDWtmFjjbiW3awLLn-IRMdPi3sc2y4OTvf6zneGv-UHFqHwXbVXF92Pm'
  //         },
  //         body: jsonEncode(body));
  //     log('Response status: ${res.statusCode}');
  //     log('Response body: ${res.body}');
  //   } catch (e) {
  //     log('\nsendPushNotificationE: $e');
  //   }
  // }
  // Future<void> updateActiveStatus(bool isOnline) async {
  //   await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
  //     'isOnline': isOnline,
  //     'lastActive': DateTime.now().millisecondsSinceEpoch.toString(),
  //     'pushToken': me.pushToken,
  //   }).then((value) => log('Updated Token: ${me.pushToken}'));
  // }
}