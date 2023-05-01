import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../view/addvideo.screens.dart';
import '../view/loadvideo.screens.dart';
import '../view/mainview.screens.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = "John";
  String surname = "Doe";
  String username = "johndoe123";
  bool showControls = false;
  List<VideoPlayerController> controllers = [];
  List<String> videoLinks = [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
  ];

  @override
  void initState() {
    super.initState();
    controllers = videoLinks
        .map((videoLink) => VideoPlayerController.network(videoLink))
        .toList();
    controllers.forEach((controller) {
      controller.addListener(() {
        if (controller.value.isInitialized) {
          setState(() {});
        }
      });
      controller.setLooping(true);
      controller.initialize().then((_) => setState(() {}));
      controller.pause();
    });
  }

  @override
  void dispose() {
    controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Mon profil"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.pinkAccent),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              color: Colors.pinkAccent,
              onPressed: () {
                // Action de déconnexion
              },
            ),
          ],
        ),
        body: Container(
        padding: const EdgeInsets.all(16),
        child: GestureDetector(
          onTap: () {
    FocusScope.of(context).unfocus();
    },
      child: Column(
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    border: Border.all(width: 3, color: Colors.pinkAccent),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ],
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/profilImage.jpg',
                      fit: BoxFit.cover,
                      width: 130,
                      height: 130,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '@' + username,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    IconButton(
                      onPressed: () {
                        showProfileDialog(context);
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.pinkAccent,
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.black,
                  height: 40,
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                for (var controller in controllers)
                  Column(
                    children: [
                      Container(
                        height: 200,
                        child: Center(
                          child: controller.value.isInitialized
                              ? GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => VideoPage(
                                  videoUrl:controller.dataSource,
                                  name: 'John Doe', // replace with actual name
                                  likes: 42, // replace with actual number of likes
                                  dislikes: 3,
                                ),
                              ));
                            },
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width: controller.value.size?.width ?? 0,
                                height: controller.value.size?.height ?? 0,
                                child: VideoPlayer(controller),
                              ),
                            ),
                          )
                              : CircularProgressIndicator(),
                        ),
                      ),
                      SizedBox(height: 16), // Ajout d'un espace entre les vidéos
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => mainView(),
                ));
              },
            ),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AddVideo(),
                ));
              },
            ),
            label: 'Plus',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Profile(),
                ));
              },
            ),
            label: 'Profil',
          ),

        ],
        currentIndex: 2,
        selectedItemColor: Colors.red,
        onTap: (index) {},
      ),
    );

  }


  Future<void> showProfileDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifier le profil'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Pseudo',
                      hintText: username,
                      hintStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      )
                  ),
                  onChanged: (value) {
                    username = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Nom',
                    hintText: name,
                      hintStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                  )
                  ),
                  onChanged: (value) {
                    name = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Prénom',
                    hintText: surname,
                      hintStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      )
                  ),
                  onChanged: (value) {
                    surname = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Sauvegarder'),
              onPressed: () {
                // TODO: Implement save action
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildTextField(String label, String placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: TextField(
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 5),
            labelText: label,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black
            )
        ),
      ),
    );
  }
}


