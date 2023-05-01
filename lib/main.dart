import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/auth/profile.auth.dart';
import 'package:tiktok_clone/view/addvideo.screens.dart';
import 'package:tiktok_clone/view/mainview.screens.dart';
import 'firebase_options.dart';

Future<void> main () async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tik-Tok Clone',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black38),
        useMaterial3: true,
      ),
      home: const mainView(),
    );
  }
}
