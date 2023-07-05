import 'package:flutter/material.dart';

class IconsMessage extends StatelessWidget {
  final IconData icon;
  final String message;
  const IconsMessage({
    Key? key,
    required this.icon,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 150,
            color: Colors.black45,
          ),
          SizedBox(height: 15),
          Text(
            message,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
