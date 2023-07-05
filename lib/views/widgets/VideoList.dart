import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoList extends StatefulWidget {
  const VideoList({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  List<String> videoUrls = [];

  Future<List<Map<String, dynamic>>> getVideosByUid(String uid) async {
    List<Map<String, dynamic>> videos = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('videos')
          .where('uid', isEqualTo: uid)
          // .where('likes', isNotEqualTo: [])
          .get();

      videos = querySnapshot.docs
          .map((doc) => doc.data())
          .cast<Map<String, dynamic>>()
          .toList();
    } catch (e) {
    }

    return videos;
  }

  void fetchVideos() async {
    String userId = widget.uid;

    List<Map<String, dynamic>> videos = await getVideosByUid(userId);

    setState(() {
      videoUrls =
          videos.map((video) => video['videoUrl']).cast<String>().toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  @override
  Widget build(BuildContext context) {
    if (videoUrls.isEmpty)
      return Container(
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.video_chat_rounded,
              size: 80,
              color: Colors.black45,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "vous n'avez pas encore de video",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      );
    else
      return Row(
        children: [
          for (String videoUrl in videoUrls)
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Gérer le clic sur la vidéo si nécessaire (ouvrir une fenêtre de lecture, etc.)
                },
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    border: Border.all(color: Colors.white70, width: .5),
                  ),
                  child: Image.network(
                    videoUrl, // Utilisez l'URL de la vidéo pour charger la vignette de la vidéo
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(Icons.error),
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      );
  }

  Future<Uint8List?> generateThumbnail(String videoUrl) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: videoUrl,
      imageFormat: ImageFormat.PNG,
      maxWidth: 128, // Largeur maximale de la vignette
      quality: 25, // Qualité de la vignette, valeur entre 0 et 100
    );
    return uint8list;
  }
}
