import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  final String videoUrl;
  final String name;
  final int likes;
  final int dislikes;

  VideoPage({
    required this.videoUrl,
    required this.name,
    required this.likes,
    required this.dislikes,
  });

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isPlaying = false;
  List<String> comments = [
    "Super vidéo !",
    "J'adore ce projet !",
    "Merci pour le partage !",
  ];


  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlaying() {
    if (_isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
    Timer(Duration(milliseconds: 300), () {
      if (mounted && _controller.value.isPlaying != _isPlaying) {
        setState(() {
          _isPlaying = _controller.value.isPlaying;
        });
      }
    });
  }


  void sharePressed(String url){
    Share.share(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tik-Tok Clone'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _togglePlaying,
              child: FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                        Positioned.fill(
                          child: AnimatedOpacity(
                            opacity: _isPlaying ? 0.0 : 1.0,
                            duration: Duration(milliseconds: 300),
                            child: IconButton(
                              icon: Icon(Icons.play_arrow),
                              onPressed: _togglePlaying,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            CircleAvatar(
            radius: 25,
            // backgroundImage: AssetImage('assets/images/profile_pic.jpg'),
            ),
            SizedBox(width: 4),
            Expanded(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
            'Nom Utilisateur',
            style: TextStyle(
            fontWeight: FontWeight.bold,
            ),
            ),
            SizedBox(height: 4),
            Text(
            'Projet Final ICT-218',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
            color: Colors.grey,
            ),
            ),
            SizedBox(height: 8),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            IconBadge(
            icon: Icons.thumb_up,
            count: widget.likes,
            ),
            IconBadge(
            icon: Icons.thumb_down,
            count: widget.dislikes,
            ),
            IconBadge(
            icon: Icons.mode_comment_outlined,
            count: 50, // exemple de nombre de commentaires
            ),
            GestureDetector(
            onTap: () {
              sharePressed(_controller.dataSource);
            },
            child: Icon(
            Icons.share_outlined,
            size: 28,
            ),
            ),
            ],
            ),
            ],
            ),
            ),
            ],
            ),
            ),
          Expanded(
            child: ListView(
              children: [
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 30, // ajustez la hauteur ici
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Ajouter un commentaire',
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontSize: 14.0, // ajustez la taille de la police ici
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // ajouter l'action d'envoi ici
                      },
                      icon: Icon(Icons.send),
                      color: Colors.pink, // changer la couleur ici
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Plus',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'profil',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.red,
        onTap: (index) {},
      ),
    );
  }
}

class IconBadge extends StatelessWidget {
  final IconData icon;
  final int count;

  const IconBadge({required this.icon, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
          ),
          SizedBox(width: 4),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

