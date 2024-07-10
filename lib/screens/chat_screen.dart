import 'package:chat_app/widget/chat_messages.dart';
import 'package:chat_app/widget/new_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreeen extends StatefulWidget {
  const ChatScreeen({super.key});

  @override
  State<ChatScreeen> createState() => _ChatScreeenState();
}

class _ChatScreeenState extends State<ChatScreeen> {

  void permissionForNotification() async {
    final fcm = FirebaseMessaging.instance;
    final perNotif = await fcm.requestPermission();

    final token = await fcm.getToken();

    print(perNotif);
    print(token);

    await fcm.subscribeToTopic('chatApp');
  }

  @override
  void initState() {
    super.initState();
    permissionForNotification();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chat Screen'),
          backgroundColor: Colors.green[50],
          foregroundColor: const Color.fromARGB(255, 0, 19, 2),
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout_rounded),
            ),
          ],
        ),
        body: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: ChatMsgWidget()),
            NewMsgWidget(),
          ],
        ),
      ),
    );
  }
}
