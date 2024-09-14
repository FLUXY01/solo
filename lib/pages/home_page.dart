import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:global_chat_app/data/auth_services.dart';
import 'package:global_chat_app/notification/notification_services.dart';
import 'package:provider/provider.dart';

import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.getDeviceToken().then((value){
      print("Device Token: $value");
    });

    notificationServices.firebaseMessageInit(context);
  }

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // SignOut Method
  void signOut() {
    final authServices = Provider.of<AuthServices>(context, listen: false);
    authServices.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(onPressed: signOut, icon: const Icon(Icons.logout),color: Colors.black,)
        ],
        title: const Text(
          "Home Page",
        ),
      ),
      body: buildUserList(),
    );
  }

  //Show all available users except the currently logged one

  Widget buildUserList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("users").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("error");
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("loading...");
        } else {
          return ListView(
            children: snapshot.data!.docs
                .map<Widget>(
                  (doc) => buildUserListItem(doc),
                )
                .toList(),
          );
        }
      },
    );
  }

  Widget buildUserListItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data =
        documentSnapshot.data()! as Map<String, dynamic>;
    if (firebaseAuth.currentUser!.email != data["email"]) {
      return ListTile(
        title: Text(data['email']),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverUserID: data["uid"],
                receiverUserEmail: data["email"],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
