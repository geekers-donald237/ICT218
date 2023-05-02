import 'dart:async';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/auth/profile.auth.dart';
import 'package:tiktok_clone/view/addvideo.screens.dart';
import 'package:tiktok_clone/view/loadvideo.screens.dart';
import 'package:video_player/video_player.dart';


class mainView extends StatefulWidget {
  const mainView({Key? key}) : super(key: key);

  @override
  State<mainView> createState() => _mainViewState();
}

class _mainViewState extends State<mainView> {
  bool isLiked = false;
  int nbLike = 120;
  bool showControls = false;
  late List<VideoPlayerController> controllers;
  List<String> videoLinks = [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/intro.mp4',
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

  Future<void> shareLink(String url) async {
    await Share.share('${url}');
  }


  void sharePressed(String url){
    Share.share(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Tik-Tok Clone",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
          color: Colors.white,
        ),
        child: ListView(
          children: [
            for (var controller in controllers)
              Column(
                children: [
                  Container(
                    // height: MediaQuery.of(context).size.height * 0.6,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : null,
                            ),
                            onPressed: () {
                              setState(() {
                                isLiked = !isLiked;
                                if(isLiked == true){
                                  nbLike++;
                                }else {
                                  nbLike--;
                                }
                              });
                            },
                          ),
                          Text(
                            nbLike.toString(),
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.mode_comment_outlined),
                            color: Colors.grey,
                          ),
                          Text(
                            "50",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              shareLink(controller.dataSource);
                            },
                            icon: Icon(Icons.share),
                            color: Colors.grey,
                          ),
                          Text(
                            "Partager",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
          ],
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
                  builder: (context) => AddVideo(),
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
        currentIndex: 0,
        selectedItemColor: Colors.red,
        onTap: (index) {},
      ),
    );
  }
}
