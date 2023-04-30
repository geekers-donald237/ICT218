import 'dart:html';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mon profil"),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.amber,
          ),
          onPressed: () {},
        ),
        /*actions: [
          IconButton(
              onPressed: (){},
              icon: Icon(
                Icons.settings,
                color: Colors.black,
              ))
        ],*/
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 20, right: 15, bottom: 20),
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(width: 5, color: Colors.black),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color : Colors.black.withOpacity(0.1)
                          )
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: Image.asset("/home/onana/StudioProjects/ICT218/android/app/src/main/assets/im1.jpg"),
                        )
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30
              ),
              buildTextField("mon nom","onana"),
              buildTextField("prenom", "laeticia"),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField( String label, String placeholder){
    return Padding(
        padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 5),
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black
          )
        ),
      ),
    );
  }
}



