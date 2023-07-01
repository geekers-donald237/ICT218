import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/models/video.dart';
import 'package:video_player/video_player.dart';

class VideoController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);
  List<Video> get videoList => _videoList.value;

  final Rx<Duration> _currentPlaybackPosition = Rx<Duration>(Duration.zero);
  Duration get currentPlaybackPosition => _currentPlaybackPosition.value;

  final Rx<Duration> _videoDuration = Rx<Duration>(Duration.zero);
  Duration get videoDuration => _videoDuration.value;

  late VideoPlayerController _videoPlayerController;
  VideoPlayerController get videoPlayerController => _videoPlayerController;

  @override
  void onInit() {
    super.onInit();
    _videoList.bindStream(
      FirebaseFirestore.instance
          .collection('videos')
          .snapshots()
          .map((QuerySnapshot query) {
        List<Video> retVal = [];
        for (var element in query.docs) {
          retVal.add(
            Video.fromSnap(element),
          );
        }
        return retVal;
      }),
    );
  }

  void initializeVideoController(String videoUrl) {
    _videoPlayerController = VideoPlayerController.network(videoUrl);

    _videoPlayerController.addListener(() {
      _currentPlaybackPosition.value = _videoPlayerController.value.position;
      _videoDuration.value = _videoPlayerController.value.duration;
    });

    _videoPlayerController.initialize().then((_) {
      _videoPlayerController.play();
      _videoPlayerController.setLooping(true);
    });
  }

  void seekTo(int seconds) {
    _videoPlayerController.seekTo(Duration(seconds: seconds));
  }

  void likeVideo(String id) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('videos').doc(id).get();
    var uid = authController.user.uid;
    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await FirebaseFirestore.instance.collection('videos').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await FirebaseFirestore.instance.collection('videos').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }

  @override
  void onClose() {
    _videoPlayerController.removeListener(() {});
    _videoPlayerController.dispose();
    super.onClose();
  }
}
