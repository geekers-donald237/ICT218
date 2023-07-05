
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (!_isVideoInitialized) {
      return Center(
        child: CircularProgressIndicator(
          color: Colors.grey, // Couleur que vous souhaitez utiliser
          // backgroundColor:
          //     Colors.blue.shade100, // Couleur de l'arrière-plan du cercle
          strokeWidth: 2.0, // Épaisseur du cercle de progression
        ),
      );
    }

    // Initialize ChewieController if the video is initialized
    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      looping: true,
      // You can customize other ChewieController configuration options here
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
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height:
                  20, // Adjust the height as needed to cover the progress bar
              color: Colors
                  .black, // You can use any color to match your background
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

  // Future<void> _handleDownload() async {
  //   try {
  //     // Obtenir la référence du fichier à partir du lien de téléchargement Firebase
  //     Reference ref = FirebaseStorage.instance.refFromURL(widget.videoUrl);

  //     // Obtenir l'URL de téléchargement du fichier
  //     String downloadUrl = await ref.getDownloadURL();

  //     // Créer un dossier de téléchargement pour stocker le fichier
  //     Directory directory = await getApplicationDocumentsDirectory();
  //     String tiktokCloneDir = '${directory.path}/tiktok_clone';
  //     await Directory(tiktokCloneDir).create(recursive: true);
  //     String filePath = '$tiktokCloneDir/video.mp4';

  //     // Télécharger le fichier en utilisant flutter_downloader
  //     await FlutterDownloader.enqueue(
  //       url: downloadUrl,
  //       savedDir: directory.path,
  //       fileName: 'video.mp4'+ widget.videoUrl,
  //       showNotification: true,
  //       openFileFromNotification: true,
  //     );

  //     // Afficher un message de succès
  //     Get.snackbar("success", 'Video telechargee');
  //   } catch (error) {
  //     // En cas d'erreur, afficher un message d'erreur
  //     Get.snackbar(
  //         "Error", 'Une erreur est survenue lors du du telechargement');
  //   }
  // }

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
                  // _handleDownload();
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
