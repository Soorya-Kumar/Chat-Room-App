import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/widget/image_picked_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

final _firebaseAuth = FirebaseAuth.instance;
final _firebaseStorage = FirebaseStorage.instance;

class NewAuthScreen extends StatefulWidget {
  const NewAuthScreen({super.key});

  @override
  State<NewAuthScreen> createState() {
    return _NewAuthScreen();
  }
}

class _NewAuthScreen extends State<NewAuthScreen> {

  final _formkey = GlobalKey<FormState>();
  var _isloginmode = true;
  var _isauth = false;
  var _enteredemail = '';
  var _enteredpassword = '';
  var _enteredusername = '';
  File? _enteredImage;

  void _submit() async {
    final isValid = _formkey.currentState!.validate();

    if (!isValid) {
      return;
    }

    if (!_isloginmode && _enteredImage == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please pick an image'),
        ),
      );
      return;
    }

    _formkey.currentState!.save();

    try {

      setState(() {
        _isauth = true;
      });

      if (_isloginmode) {
        await _firebaseAuth.signInWithEmailAndPassword(
            email: _enteredemail, password: _enteredpassword);
      }

      if (!_isloginmode) {
        final userCredentials = await _firebaseAuth.createUserWithEmailAndPassword(
            email: _enteredemail, password: _enteredpassword);

        final stoargeRef = _firebaseStorage.ref().child('user_images').child('${userCredentials.user!.uid}.jpg');
        await stoargeRef.putFile(_enteredImage!);
      
        final imageUrl = await stoargeRef.getDownloadURL();

        //File name is chosen by us. using doc.
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'username': _enteredusername,
          'email': _enteredemail,
          'profilePhoto': imageUrl,
        });
      }
    
    } on FirebaseAuthException catch (error) {
      
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ??
              'Authentication Failed. Try again after some time..'),
        ),
      );

      setState(() {
        _isauth = false;
      });

    }

    print(_enteredemail);
    print(_enteredpassword);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF3558AE),
        
        body: Center(
          child: SingleChildScrollView(
            
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                
                if (_isloginmode)
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/chat.jpg'),
                    radius: 85,
                  ),

                if (_isloginmode)
                  const SizedBox(height: 20),
                if (_isloginmode)
                  Text(
                    'Welcome to the Chat Room !!',
                    style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.onPrimary),
                  ),
                if (_isloginmode)
                  Text(
                    'Login to continue',
                    style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.onPrimary),
                  ),
                if (_isloginmode)
                  const SizedBox(height: 40),

                if (!_isloginmode)
                  ImagePickerWidget(passingSelectedImage: (image) {
                    _enteredImage = image;
                  }),
                
                
                Card(
                  margin: const EdgeInsets.fromLTRB(20, 30, 30, 20),
                  surfaceTintColor: Theme.of(context).colorScheme.primaryContainer,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          
                          children: [
                                                        

                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Email'),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    !value.contains('@') ||
                                    !value.contains('.com')) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _enteredemail = newValue!;
                              },
                            ),
                            
                            
                            if (!_isloginmode)
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Username'),
                                autocorrect: false,
                                enableSuggestions: false,
                                textCapitalization: TextCapitalization.none,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.trim().length < 2) {
                                    return 'Must have atleast 2 characters';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  _enteredusername = newValue!;
                                },
                              ),
                            
                            
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Password'),
                              obscureText: true,
                              autocorrect: false,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length < 7 ||
                                    !value.contains(
                                        RegExp(r'[!@#$%^&*(),.?":{}|<>]')) ||
                                    !value.contains(RegExp(r'[A-Z]')) ||
                                    !value.contains(RegExp(r'[0-9]'))) {
                                  return 'Password must be atleast 7 characters long annd must contain a uppercase letter, a number and a special character';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _enteredpassword =
                                    value; // set _enteredpassword here
                              },
                            ),
                            
                         
                            if (!_isloginmode)
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Confirm Password',
                                ),
                                obscureText: true,
                                autocorrect: false,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the confirmed password';
                                  }
                                  if (value != _enteredpassword) {
                                    return 'Password and confirmed password must be the same';
                                  }
                                  return null;
                                },
                              ),

                            const SizedBox(height: 20),

                            if (_isauth) const CircularProgressIndicator(),
                            
                            if (!_isauth)
                              ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.secondary,
                                  foregroundColor:
                                      Theme.of(context).colorScheme.onSecondary,
                                ),
                                child: Text(_isloginmode ? 'Login' : 'Signup'),
                              ),
                            
                            if (!_isauth)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isloginmode = !_isloginmode;
                                  });
                                },
                                child: Text(_isloginmode
                                    ? 'Don\'t have an account? Signup'
                                    : 'Already have an account? Login'),
                              ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
