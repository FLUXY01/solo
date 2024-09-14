import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:global_chat_app/model/messages.dart';
import 'package:http/http.dart' as http;

class ChatServices extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

// send messages
  Future<void> sendMessage(String receiverId, String message) async {
    // get the information of the current user
    final String currentUserId = firebaseAuth.currentUser!.uid.toString();
    final String currentUserEmail = firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    // Create a new message
    Messages newMessage = Messages(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );
    //construct a chat-room id from the current user id and receiver id
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    //check condition if currentID is not equal to receiverID
    if (currentUserId != receiverId) {
      //adding a new message to the database
      await firestore
          .collection("chat_room")
          .doc(chatRoomId)
          .collection("messages")
          .add(newMessage.toMap());

      final notificationMessage = {
        "notification": {
          "title": "New Message",
          "body": "You have received a new message from $currentUserEmail"
        },
        "data": {
          "receiverId": receiverId,
          "receiverEmail": currentUserEmail,
        },
        "to": "/topics/$currentUserId",
      };
      // send the FCM Notification
      await firebaseMessaging.requestPermission();
      await firebaseMessaging.subscribeToTopic(receiverId);
      await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: <String,String>{
          "Content-Type": "application/json",
          "Authorization" :
              "key=nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDDgVpF6C0u+jSfwwjBuo7ND2RbPlaIzZUCCFVQffFsHFiYCsAh7LFOKyDi5Mb/WAzaFm9tQpIF0TatgyUTH+1dmh37sxrtIeB+VuO6uk+p4sgDML5d1A8Dk0u5TqvAhsaVFuprBqq/uDSAcmi+3DrK0BxZaq9i2k04eoCSa9PYY8QzIqMM8jgO4jAVZGVDE9Vc8rKdEeSMytw0J9/rXdOmwOnKbhqw0XYXRiOFdyNx/rE7hIDGk3sTGEPIERcVsAfTZaUR77lKpZCgDV8cDbFP4AMVZ4tWZ5jTmABB004gQzlGLYzEUR5bFviK0ne2SJFTR6RN4j+Rl8w+Ih0weRxfAgMBAAECggEAFGbQO9FRvcBAc5ePt1+3fTCpAViNATOq5A5okMDDy8tdd2hPynp/ui+H/AVxur2+gZerwxQaVt8RPKQd31QKmiT2EgkLu0k4uxZoJ1k/7POMecDBbNsvQelCErFh/PJTkMVWaxrEAMPBPtIxmhEzVWzIOJCIguFTA5zNA/qanc8EYEzyBhz1UEWsqcCbuK4vDR+OPJ41PVW0Yi64j0P/fciB7X9NS403AhwIi02vCJR8yLV1zOT7l43xJPtSjARtUqO3GJfUtBn2gpDoLulcDuJOmmTB5Kcbfk19LdKjfRDlVunzGpRDA5zLaINTo1hwtutIBYCJlUJ+/dtmce58wQKBgQD9lj+F0pfXg8+XgKvyvhB10lrArx5LwC+WUijq0Ex6/xFrj+sGNS3G0JlCASoWkH3W5depf5nFvHJohaolLOebMg5Uxgw+D0VgXkjXbyCwJPf2gX4GA+cLQoLXRnDwukvy53O+CKdNK3Ej7D/38Hy0MjL6WopFmybPFxy5/55/YQKBgQDFXZ1KaBiXrCnOd7NDkY57YSutWM3oZcgqOXiyegNH5LzeBJA5/uVIXMJEjN1NVF0g9lNlW3WENQN8ci+QDGHPOYCS87Neotnu4VOH8b5dbeWPc9tJJzFgyEI17AGgwA0exhDWT+HBnnRrRfE8G3BNTPOdAc8e11UEedge06/zvwKBgBpN0X0CITn7tDbU5AEj8fUmwr8l6xCUeNsw3oms3aIMfzQXE5vrPDpZPOx5znHUvxjhcoNkdwDp0TxCUSnWBJg2kwH8IRz23I1oeknOfyeGTipFuFrLYNXsKkJGTkTKLkKd+4WExEXe8bd2NBR135mZc2xApAMgWuA0V4h7mWdBAoGBAIjFXwL5MFGrVS1ndisU65BEvmfaapbqMdRRD3tfYnan5NpWfzwxj+KdpWKr25CDLiZxjUloIAAGXOwYlS1V51IbnyY3C85BPJV2QNSsiidkyPioaQZAys8u9/M2IcqsTGtPBsv9f40VqcfNKGdm/GQVN51Oa6ILxzba2RJD0GMxAoGAEkjKnoGXR42v4xkQeJ6exNC74i5qDzlN3Q+O6uFKnOYqJrtiHlAPso/IeOq2O4c2fnXlq4lmkG5vMYpIKI6THfkmwpjdT9pDb9+88F6TELc0xbatkrVWPlcbcw4eozfUzJxLjQiq0JojxdLF3Kdq0ILlx6WM2QF3uf3ygoB/Tbw=",
        },
        body: jsonEncode(notificationMessage),
      );
    } else {
      print("Not sending a message to the current user");
    }
  }

  //getting the message from the firestore
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return firestore
        .collection("chat_room")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
