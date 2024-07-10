
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/new.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

  runApp(const MyApp());
}


final appTheme = ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(214, 48, 58, 203), ),
        useMaterial3: true,
      );

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreeen();
          }

          if (snapshot.hasData) {
            return const ChatScreeen();
          }
          return const NewAuthScreen();
        },
      ),
    );
  }
}
