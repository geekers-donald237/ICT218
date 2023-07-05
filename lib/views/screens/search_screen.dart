import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/views/screens/profile_screen.dart';

import '../widgets/icons_message.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchUser = TextEditingController();
  List<Map<String, dynamic>> foundUsers = [];
  bool isSearched = false;

  Future<List<Map<String, dynamic>>> getUsersByUsername(String username) async {
    List<Map<String, dynamic>> users = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('name', isEqualTo: username)
          .get();

      users = querySnapshot.docs
          .map((doc) => doc.data())
          .cast<Map<String, dynamic>>()
          .toList();
    } catch (e) {
      
    }

    return users;
  }

  void searchAndShowUsers() async {
    String username = searchUser.text;
    List<Map<String, dynamic>> users = await getUsersByUsername(username);

    setState(() {
      foundUsers = users;
    });
  }

  Widget buildUserCard(Map<String, dynamic> user) {
    String name = user['name'];
    String profileImageUrl = user['profilePhoto'];

    return InkWell(
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(profileImageUrl),
          ),
          title: Text(name),
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfileScreen(uid: user['uid']),
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black12)),
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchUser,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black12,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.search, color: Colors.black),
                        hintText: "Search",
                        hintStyle: TextStyle(color: Colors.black26),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    child: Text(
                      'Rechercher',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        isSearched = true;
                        searchUser.text;
                      });
                      searchAndShowUsers();
                    },
                  ),
                ],
              ),
            ),
            if (isSearched && searchUser.text.toString().length != 0)
              Expanded(
                child: foundUsers.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(
                            8.0), // Espace souhaité autour du ListView
                        child: ListView.builder(
                          itemCount: foundUsers.length,
                          itemBuilder: (context, index) {
                            return buildUserCard(foundUsers[index]);
                          },
                        ),
                      )
                    : IconsMessage(
                        icon: Icons.cancel_presentation_outlined,
                        message: 'User Not Found',
                      ),
              )
            else
              Expanded(
                child: IconsMessage(
                  icon: Icons.search,
                  message: 'Search User, Type here ',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
