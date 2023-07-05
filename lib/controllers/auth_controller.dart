import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/models/user.dart' as model;
import '../constants.dart';
import '../views/screens/auth/login_screen.dart';
import '../views/screens/home_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user;

  User get user => _user.value!;
  Timer? _timer;
  late double _progress;
  bool isLoading =
      false; // Nouvelle variable pour indiquer si le chargement est actif ou non

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  void showEasyLoading(Function() onComplete) async {
    isLoading =
        true; // Définit isLoading sur true lorsque le chargement commence
    _progress = 0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
      EasyLoading.showProgress(_progress,
          status: '${(_progress * 100).toStringAsFixed(0)}%');
      _progress += 0.03;

      if (_progress >= 1) {
        _timer?.cancel();
        EasyLoading.dismiss();
        isLoading =
            false; // Définit isLoading sur false lorsque le chargement est terminé
        onComplete();
      }
    });
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }

  // upload to firebase storage
  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // registering the user

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // Appelle showEasyLoading() en lui passant la fonction de rappel à exécuter après le chargement
        showEasyLoading(() async {
          await firebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
        });
      } else {
        Get.snackbar(
          'Error Logging in',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      String errorMessage = '';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'User not found.';
            break;
          case 'wrong-password':
            errorMessage = 'Wrong password.';
            break;
          case 'invalid-email':
            errorMessage = 'Invalid email address.';
            break;
          case 'user-disabled':
            errorMessage = 'User account is disabled.';
            break;
          default:
            errorMessage = 'An error occurred during login.';
            break;
        }
      } else {
        errorMessage = 'An error occurred during login.';
      }

      // Appelle showEasyLoading() en lui passant la fonction de rappel à exécuter après le chargement
      showEasyLoading(() {
        // Fonction de rappel exécutée après la fermeture du chargement
        // Affiche le snackbar d'erreur
        Get.snackbar(print
          'Error Logging in',
          errorMessage,
        );
      });
    }
  }

  void signOut() async {
    await firebaseAuth.signOut();
  }

  void registerUser(
      String username, String email, String password, File? image) async {
    try {
      if (username.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          image == null) {
        Get.snackbar(
          'Error Creating Account',
          'Please enter all the fields',
        );
        return;
      }

      showEasyLoading(() async {
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String downloadUrl = await _uploadToStorage(image);
        model.User user = model.User(
          name: username,
          email: email,
          uid: cred.user!.uid,
          profilePhoto: downloadUrl,
        );

        await firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());

        Get.snackbar(
          'Account Created',
          'Your account has been successfully created!',
        );
      });
    } catch (e) {
      String errorMessage = '';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage =
                'The email address is already in use by another account.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is not valid.';
            break;
          case 'weak-password':
            errorMessage = 'The password is too weak.';
            break;
          default:
            errorMessage = 'An error occurred while creating your account.';
            break;
        }
      } else {
        errorMessage = e.toString();
      }

      showEasyLoading(() {
        // Fonction de rappel exécutée après la fermeture du chargement
        // Affiche le snackbar d'erreur
        Get.snackbar(
          'Error Creating Account',
          errorMessage,
        );
      });
    }
  }
}
