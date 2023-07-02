import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/profile_controller.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:tiktok_clone/views/screens/messages_screen.dart';
import 'package:tiktok_clone/views/widgets/VideoList.dart';

import '../../constants.dart';
import '../../utils/tik_tok_icons_icons.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController profileController = Get.put(ProfileController());
  int selectedIndex = 0;
  TextEditingController username = TextEditingController();

  @override
  void initState() {
    super.initState();
    profileController.updateUserId(widget.uid);
  }

  String removeSpaces(String input) {
    return input.replaceAll(' ', '');
  }

  buildAlertDialog() {
    return AlertDialog(
      title: Text("Modifier le pseudo"),
      content: TextField(
        controller: username,
        decoration: InputDecoration(labelText: "Nouveau pseudo"),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Annuler"),
        ),
        ElevatedButton(
          onPressed: () {
            print(username);
          },
          child: Text("Mettre à jour"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ProfileController(),
      builder: (controller) {
        if (controller.user.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                controller.user['name'],
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.more_vert, color: Colors.black87),
                  onPressed: () {
                    // Add your action here
                  },
                ),
              ],
            ),
            body: Container(
              color: Colors.white,
              child: Column(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: controller.user['profilePhoto'],
                                  height: 100.0,
                                  width: 100.0,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "@" +
                              controller.user['name']
                                  .toString()
                                  .removeAllWhitespace,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        // Rest of your content...
                        // ...
                        // Remove the previous container with the AppBar
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          height: 45,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              buildMenuItem(Icons.menu, selectedIndex == 0),
                              buildMenuItem(
                                  Icons.favorite_border, selectedIndex == 1),
                              buildMenuItem(
                                  Icons.lock_outline, selectedIndex == 2),
                            ],
                          ),
                        ),
                        if (selectedIndex == 0)
                          VideoList()
                        else if (selectedIndex == 1)
                          VideoList()
                        else
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 25, horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  TikTokIcons.messages,
                                  size: 80,
                                  color: Colors.black45,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "Aucune Video Privee",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _updateUsername() {
    String newUsername = username.text;

    // Mettre à jour le pseudo dans le document 'user'
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .update({'username': newUsername});

    // Mettre à jour le pseudo dans tous les documents 'video' de l'utilisateur
    FirebaseFirestore.instance
        .collection('videos')
        .where('uid', isEqualTo: widget.uid)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.update({'username': newUsername});
      });
    });
  }

  Widget buildMenuItem(IconData iconData, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = [
            Icons.menu,
            Icons.favorite_border,
            Icons.lock_outline
          ].indexOf(iconData);
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            iconData,
            color: isSelected ? Colors.black87 : Colors.black26,
          ),
          SizedBox(
            height: 7,
          ),
          Container(
            color: isSelected ? Colors.black : Colors.transparent,
            height: 2,
            width: 55,
          ),
        ],
      ),
    );
  }
}
