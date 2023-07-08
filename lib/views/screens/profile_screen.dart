import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/profile_controller.dart';
import 'package:tiktok_clone/views/widgets/VideoList.dart';

import '../../constants.dart';
import '../../utils/tik_tok_icons_icons.dart';
import '../widgets/profile_video.dart';

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
            profileController.updateUsername(username.text, widget.uid);
            Navigator.pop(context);
          },
          child: Text("Mettre à jour"),
        ),
      ],
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return buildAlertDialog();
      },
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
                centerTitle: true,
                backgroundColor: Colors.white,
                title: Text(
                  controller.user['name'],
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                actions: [
                  PopupMenuButton<int>(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.black,
                    ),
                    onSelected: (value) {
                      if (value == 0) {
                      } else if (value == 1) {
                      } else {
                        authController.signOut();
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return <PopupMenuEntry<int>>[
                        PopupMenuItem<int>(
                          value: 0,
                          child: Text("My Account",
                              style: TextStyle(color: Colors.white)),
                        ),
                        PopupMenuItem<int>(
                          value: 1,
                          child: Text("Settings",
                              style: TextStyle(color: Colors.white)),
                        ),
                        PopupMenuItem<int>(
                          value: 2,
                          child: Text("Logout",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ];
                    },
                    color: Colors.black,
                  )
                ],
              ),
              body: SingleChildScrollView(
                child: Container(
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
                                      color: Colors
                                          .red, // Remplacez cette couleur par celle souhaitée
                                      width:
                                          2.0, // Ajustez l'épaisseur de la bordure si nécessaire
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
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      controller.user['following'],
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Following",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black87),
                                    ),
                                  ],
                                ),
                                Container(
                                  color: Colors.black54,
                                  width: 1,
                                  height: 15,
                                  margin: EdgeInsets.symmetric(horizontal: 15),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      controller.user['followers'],
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Followers",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black87),
                                    ),
                                  ],
                                ),
                                Container(
                                  color: Colors.black54,
                                  width: 1,
                                  height: 15,
                                  margin: EdgeInsets.symmetric(horizontal: 15),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      controller.user['likes'],
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Likes",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black87),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 140,
                                  height: 47,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.black12)),
                                  child: Center(
                                    child: InkWell(
                                      onTap: () {
                                        if (widget.uid ==
                                            authController.user.uid) {
                                          _showAlertDialog(context);
                                        } else {
                                          controller.followUser();
                                        }
                                      },
                                      child: Text(
                                        widget.uid == authController.user.uid
                                            ? 'Modifier le  profil'
                                            : controller.user['isFollowing']
                                                ? 'Unfollow'
                                                : 'Follow',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  width: 45,
                                  height: 47,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.black12)),
                                  child: Center(
                                    child: Icon(
                                      Icons.bookmark_remove_outlined,
                                      color: Colors.black87,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Container(
                              height: 45,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black12)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  buildMenuItem(Icons.menu, selectedIndex == 0),
                                  buildMenuItem(Icons.favorite_border,
                                      selectedIndex == 1),
                                  buildMenuItem(
                                      Icons.lock_outline, selectedIndex == 2),
                                ],
                              ),
                            ),
                            if (selectedIndex == 0)
                              ProfileVideo2()
                            else if (selectedIndex == 1)
                              VideoList(uid: widget.uid)
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
            ),
          );
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
