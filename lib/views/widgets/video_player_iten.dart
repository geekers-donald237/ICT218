import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;
  late ChewieController _chewieController;
  bool _isVideoInitialized = false;
  bool downloading = false;
  var progressString = "";
  int i = 1;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
    _chewieController.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (!_isVideoInitialized) {
      return Center(
        child: CircularProgressIndicator(
          color: Colors.grey,
          strokeWidth: 2.0,
        ),
      );
    }

    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
    );

    return GestureDetector(
      onLongPress: () {
        _showOptionsDialog();
      },
      child: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: Chewie(controller: _chewieController),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 20,
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOptionsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: CustomAlertDialog(),
        );
      },
    );
  }

  Future<void> downloadFile(String url) async {
    Dio dio = Dio();

    try {
      var dir = await getApplicationDocumentsDirectory();
      print("path ${dir.path}");
      EasyLoading.show(status: 'Downloading...');

      await dio.download(url, "${dir.path}/video.mp4",
          onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");

        setState(() {
          downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      });

      EasyLoading.dismiss();
      await GallerySaver.saveVideo("${dir.path}/video${i}.mp4",
          albumName: "tiktok_cloneVideo");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Downloaded Complete ${dir.path}')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error When Downloading File ${e}')),
      );
    }

    setState(() {
      downloading = false;
      progressString = "Completed";
    });
    print("Download completed");
  }

  Widget CustomAlertDialog() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pop(); // Ferme la boîte de dialogue lorsque l'utilisateur tape en dehors
      },
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 150.0),
        backgroundColor: Colors.transparent,
        content: Container(
          width: 300.0, // Augmenter la largeur de la boîte de dialogue
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: ListView(
            shrinkWrap: true, // Réduit l'espace entre les ListTiles
            children: [
              ListTile(
                leading: Icon(
                  Icons.download_outlined,
                  color: Colors.black,
                ),
                title: Text(
                  "Telecharger",
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                  // Call the function to handle video download here
                  downloadFile(widget.videoUrl);

                  Navigator.of(context).pop(); // Ferme la boîte de dialogue
                },
              ),
              Divider(thickness: 0.2, color: Colors.black),
              ListTile(
                leading: Icon(
                  Icons.flag_outlined,
                  color: Colors.black,
                ),
                title: Text(
                  "Signaler",
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                  // Call the function to handle video reporting here
                  // _handleReport();
                  Navigator.of(context).pop(); // Ferme la boîte de dialogue
                },
              ),
              Divider(thickness: 0.2, color: Colors.black),
              ListTile(
                leading: Icon(
                  Icons.heart_broken_outlined,
                  color: Colors.black,
                ),
                title: Text(
                  "Pas interesse",
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                  // Call the function to handle video reporting here
                  // _handleReport();
                  Navigator.of(context).pop(); // Ferme la boîte de dialogue
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
