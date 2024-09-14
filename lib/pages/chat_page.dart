import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:global_chat_app/chat/chat_services.dart';
import 'package:global_chat_app/components/chat_bubble.dart';
import 'package:global_chat_app/components/my_email_field.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;

  const ChatPage(
      {super.key,
      required this.receiverUserEmail,
      required this.receiverUserID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final ChatServices chatServices = ChatServices();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await chatServices.sendMessage(
          widget.receiverUserID, messageController.text);
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserEmail),
      ),
      body: Column(
        children: [
          Expanded(child: buildMessageList()),

          //user Input
          buildMessageInput(),
        ],
      ),
    );
  }

  Widget buildMessageList() {
    return StreamBuilder(
      stream: chatServices.getMessages(
          widget.receiverUserID, firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        } else {
          return ListView(
            children: snapshot.data!.docs
                .map((document) => buildMessageItem(document))
                .toList(),
          );
        }
      },
    );
  }

  // build message item
  Widget buildMessageItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    var alignment = (data["senderId"] == firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: (data["sender"] == firebaseAuth.currentUser!.uid)
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(data["senderEmail"]),
          (data["senderId"] == firebaseAuth.currentUser!.uid)
              ? ChatBubble(message: data["message"], color: Colors.deepPurple)
              : ChatBubble(message: data["message"], color: Colors.blue),
        ],
      ),
    );
  }

  Widget buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: MyEmailField(
              hintText: "Send Your Message",
              isObsecureText: false,
              controller: messageController),
        ),
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(Icons.send,color: Colors.black,),
          iconSize: 50.0,
        )
      ],
    );
  }
}
