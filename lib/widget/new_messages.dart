import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMsgWidget extends StatefulWidget{
  const NewMsgWidget({super.key});
  
  @override
  State<NewMsgWidget> createState() {
    return _NewMsgWidget();
  }
}

class _NewMsgWidget extends State<NewMsgWidget>{

  final _msgcontroller = TextEditingController();


  @override
  void dispose() {
    _msgcontroller.dispose();
    super.dispose();
  }


  void _submitMsg() async {
    final enteredMsg = _msgcontroller.text;
    
    if(enteredMsg.trim().isEmpty){
      return;
    }
        
    _msgcontroller.clear();
    FocusScope.of(context).unfocus();

    final currentUser = FirebaseAuth.instance.currentUser!;

    final userData = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
    final userName = userData.data()!['username'];
    final userPhoto = userData.data()!['profilePhoto'];

    //file name is chosen by the backend. 
    FirebaseFirestore.instance.collection('chatMsg').add({
      'message' : enteredMsg,
      'timeCreated' : Timestamp.now(),
      'userId' :  currentUser.uid,
      'userName' : userName,
      'profilePhoto' : userPhoto,
    });

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 15, right: 2),
      child: Row(
        children: [
          
          
          Expanded(
            child: TextFormField(
              decoration: const InputDecoration(label: Text('Send a message')),
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              controller: _msgcontroller,
              scrollPadding: const EdgeInsets.only(right: 2),
              scrollPhysics: const BouncingScrollPhysics(
                  decelerationRate: ScrollDecelerationRate.normal),
            ),
          ),
          
          
          const SizedBox(width: 4),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.attach_file_outlined),
          ),
          const SizedBox(width: 2),
          IconButton(
            onPressed: _submitMsg,
            icon: const Icon(Icons.send),
          ),
        
        ],
      ),
    );
  }
}
