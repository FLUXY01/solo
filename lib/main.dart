import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:global_chat_app/data/auth_gate.dart';
import 'package:global_chat_app/data/auth_services.dart';
import 'package:provider/provider.dart';
import 'pages/login_or_register_page.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage remoteMessage) async {
  await Firebase.initializeApp();
  print(remoteMessage.notification!.title.toString());
}


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey:"AIzaSyCPKs475S-yC8U16yXdM-tKDJWYGyZKigE" ,
        appId: "1:4933616856:android:7ddddc4dcf13231e37c3ad",
        messagingSenderId:"4933616856	" ,
        projectId: "solo-355c8",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) => AuthServices(),child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Solo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    ),
    );
  }
}
// change 1