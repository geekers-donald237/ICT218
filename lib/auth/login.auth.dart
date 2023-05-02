// id google cloud = tiktokclone-385212.
// firebase register id = tiktokclone-1fc21
// Platform  Firebase App Id
// android   1:851549237006:android:289c27d9163f91a630715f
// ios       1:851549237006:ios:5ceb661fa6ba2e0530715f
// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  String? _userName;
  String? _userUid;

  Future<UserCredential?> _signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
    await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
        await _auth.signInWithCredential(credential);
        setState(() {
          _userName = userCredential.user?.displayName;

          _userUid = userCredential.user?.uid;
        });
        return userCredential;
      } catch (e) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('ERREUR'),
            content: const Text('recommencer'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  // Fermer le pop-up
                  Navigator.of(context).pop();
                },
                child: const Text('Réessayer'),
              ),
            ],
          ),
        );
        // print(e.toString());
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 100,
        backgroundColor: Color.fromARGB(0, 1, 2, 3),
        title: const Text(
          'LOGIN',
          style: TextStyle(
            color: Color.fromARGB(255, 243, 104, 104),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0), // hauteur de la bordure basse
          child: Container(
            color: Colors.white,
            height: 1.0,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.vertical(bottom: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: Offset(0, 10),
                  )
                ],
                border: Border(
                  // top: BorderSide(width: 2.0, color: Colors.blue),
                ),
              ),
              child: ElevatedButton.icon(
                icon: Image.asset(
                  'assets/g-logo.png',
                  width: 60,
                  height: 60,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 243, 104, 104),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                label: const Text(
                  'Se connecter avec Google',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                onPressed: () async {
                  final UserCredential? userCredential =
                  await _signInWithGoogle();

                  if (userCredential != null) {
                    // Connexion réussie, faire quelque chose ici...
                    //  setState(() {
                    //  String _userName = userCredential.user?.displayName ?? '';
                    // });

                    // Afficher un pop-up pour indiquer que la connexion a réussi

                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Login success'),
                        content: Text(
                            'Vous êtes maintenant connecté en tant que $_userName '
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              // Fermer le pop-up et continuer
                              Navigator.of(context).pop();
                            },
                            child: const Text('Continuer'),
                          ),
                        ],
                      ),
                    );
                    //print(userCredential.user?.uid);
                  } else {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Login Failed'),
                        content:
                        const Text('verifier votre connexion et reesayer'),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              // Fermer le pop-up et continuer
                              Navigator.of(context).pop();
                            },
                            child: const Text('Reesayer'),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Future<void> _handleSignIn() async {

//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   try {
//     await _googleSignIn.signIn();
//   } catch (error) {
//     print(error);
//   }
// }

// Future<void> _handleSignIn() async {
//   try {
//     await _googleSignIn.signIn();
//   } catch (error) {
//     print(error);
//   }
// }


// ecouter les chagement sur le login et recuper les info si disponible
// FirebaseAuth.instance.authStateChanges().listen((User? user) {
//   if (user == null) {
//     print('User is currently signed out!');
//   } else {
//     print('User UID: ${user.uid}');
//   }
// });