import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileVideo2 extends StatefulWidget {
  const ProfileVideo2({Key? key}) : super(key: key);

  @override
  State<ProfileVideo2> createState() => _ProfileVideo2State();
}

class _ProfileVideo2State extends State<ProfileVideo2> {
  List<String> videoUrls = [
    "https://media.giphy.com/media/Ii4Cv63yG9iYawDtKC/giphy.gif",
    "https://media.giphy.com/media/tqfS3mgQU28ko/giphy.gif",
    "https://media.giphy.com/media/3o72EX5QZ9N9d51dqo/giphy.gif",
    // Ajoutez d'autres URL de vidéos ici
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (String videoUrl in videoUrls)
          Expanded(
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                  color: Colors.black26,
                  border: Border.all(color: Colors.white70, width: .5)),
              child: FittedBox(
                child: CachedNetworkImage(
                  fit: BoxFit.fill,
                  imageUrl: videoUrl,
                  placeholder: (context, url) => Padding(
                    padding: const EdgeInsets.all(35.0),
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                fit: BoxFit.fill,
              ),
            ),
          ),
      ],
    );
  }
}
