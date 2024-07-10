import 'package:chat_app/services/encryption_service.dart' as encryptionService;
import 'package:chat_app/widget/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final encrypter = encryptionService.EncService();

class ChatMsgWidget extends StatelessWidget{
  const ChatMsgWidget({super.key});


  @override
  Widget build(BuildContext context) {
    
    final currAppUser = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chatMsg')
            .orderBy('timeCreated', descending: true)
            .snapshots(),
        builder: (ctx, snapshots) {

          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (!snapshots.hasData || snapshots.data!.docs.isEmpty) {
            return const Scaffold(
              body: Center(
                child: Text('Start a conversation to see the messages'),
              ),
            );
          }

          if (snapshots.hasError) {
            return const Scaffold(
              body: Center(
                child: Text('SOEMTHING WENT WRONG..'),
              ),
            );
          }

          final loadedMsg = snapshots.data!.docs;

          return ListView.builder(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 40),
              itemCount: loadedMsg.length,
              reverse: true,
              itemBuilder: (ctx, index) {
                final chatMessage = loadedMsg[index].data();
                final nextChatMessage = index + 1 < loadedMsg.length
                    ? loadedMsg[index + 1].data()
                    : null;

                final currentMessageUser = chatMessage['userId'];
                final nextMessageUser =
                    nextChatMessage != null ? nextChatMessage['userId'] : null;

                final isUserSame = currentMessageUser == nextMessageUser;
                final decryptedmsg = encrypter.decrypt(chatMessage['message']);

                if (isUserSame) {
                  return MessageBubble.next(
                      message: decryptedmsg,
                      isMe: currAppUser == currentMessageUser);
                } else {
                  return MessageBubble.first(
                      userImage: chatMessage['profilePhoto'],
                      username: chatMessage['userName'],
                      message: decryptedmsg,
                      isMe: currAppUser == currentMessageUser);
                }
              });

        });
  }
}
