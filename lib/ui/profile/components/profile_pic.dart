import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
// import 'dart:async';
import 'dart:io';

class ProfilePic extends StatelessWidget {
  late File file;


  chooseImage() async {
    var xfile = await ImagePicker().pickImage(source: ImageSource.gallery);
    file = File(xfile!.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage("assest/images/Profile Image.png"),
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: Colors.white),
                  ),
                  primary: Color.fromARGB(255, 19, 18, 18),
                  backgroundColor: Color.fromARGB(255, 209, 209, 209),
                ),
                onPressed: () {
                },
                // child: (file == null)
                //       ? InkWell(
                //           onTap: () {
                //             chooseImage();
                //           },
                //           child: Icon(
                //             Icons.image,
                //             size: 48,
                //           ),
                //         )
                //       : Image.file(file),

                child: SvgPicture.asset("assest/icons/Camera Icon.svg"),
              ),
            ),
          )
        ],
      ),
    );
  }

  void setState(Null Function() param0) {}
}
