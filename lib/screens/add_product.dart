
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signup/screens/product_category.dart';
import 'package:signup/utils/color_utils.dart';

import '../reusable_widgets/reusable_widgets.dart';
import 'package:path/path.dart' as Path;  

class addProduct extends StatefulWidget {
      final String category;

  const addProduct({Key? key, required this.category}) : super(key: key);
  @override
  State<addProduct> createState() {
    return _addProductState(this.category);
  }
}

class _addProductState extends State<addProduct> {
  String category;
  _addProductState(this.category);

  TextEditingController _nameController = TextEditingController();
  TextEditingController _discriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  List<File> _images = [];
  List<String> imageURL = [];
    DocumentReference sightingRef = FirebaseFirestore.instance.collection('sample').doc();


Future<void> sendUserDataToDB() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    String user = (currentUser!.email) as String;
    

    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection(category);

        var dicref = _collectionRef.doc();

        dicref.set({
          "discription": _discriptionController.text,
          "img" : imageURL.toList(),
          "name": _nameController.text,
          "price": _priceController.text,
          "quantity": _quantityController.text,
          "seller-name": currentUser.email,
          "reference": dicref,

        })
        .then((_){
          print("collection created");
        }).catchError((_){
          print("an error occured");
        });

        FirebaseFirestore.instance.collection("Products").add({
          "discription": _discriptionController.text,
          "img" : imageURL.toList(),
          "name": _nameController.text,
          "price": _priceController.text,
          "quantity": _quantityController.text,
          "remaining-quantity": _quantityController.text,
          "seller-name": currentUser.email,
          "reference": dicref,

          }).then((_){
          print("collection created");
        }).catchError((_){
          print("an error occured");
        });

  CollectionReference _collectionRef3 =
        FirebaseFirestore.instance.collection("seller-products").doc(user).collection(category);
  var doc = _collectionRef3.doc();
    doc.set({
          "sold": false,
          "discription": _discriptionController.text,
          "img" : imageURL.toList(),
          "name": _nameController.text,
          "price": _priceController.text,
          "quantity": _quantityController.text,
          "return" : false,
          "reference":   dicref,
        }).then((_){
          print("collection created");
        }).catchError((_){
          print("an error occured");
        });
    
    _images.clear();
    imageURL.clear();
  }
  Future getImage(bool gallery) async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    // Let user select photo from gallery
    if(gallery) {
      pickedFile = await picker.pickImage(
          source: ImageSource.gallery,);
    } 
    // Otherwise open camera to get new photo
    // else{
    //   pickedFile = await picker.pickImage(
    //       source: ImageSource.camera,);
    // }

    setState(() {
      if (pickedFile != null) {
        print('hello');
      print(pickedFile.path);
        _images.add(File(pickedFile.path));
        //_image = File(pickedFile.path); // Use if you only need a single picture
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String?> uploadFile(File _image) async {
  Reference storageReference = FirebaseStorage.instance
      .ref()
      .child('sample/${Path.basename(_image.path)}');
  UploadTask uploadTask =  storageReference.putFile(_image);
  TaskSnapshot taskSnapshot = await await uploadTask;
  print('File Uploaded');
  String? returnURL ;
  await (await storageReference).getDownloadURL().then((fileURL) {
    returnURL =  fileURL;
  });
  return returnURL;
}

Future<void> saveImages(List<File> _images, DocumentReference ref) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    String user = (currentUser!.email) as String;
       
    print('not image');
  _images.forEach((image) async {
    String? URL = await uploadFile(image);
    imageURL.add(URL!);
    // print(imageURL);
    //  FirebaseFirestore.instance.collection(user).add({
    //       "key": FieldValue.arrayUnion([imageURL]) //your data which will be added to the collection and collection will be created after this
    //     }).then((_){
    //       print("collection created");
    //     }).catchError((_){
    //       print("an error occured");
    //     });
    // ref.update({"images": FieldValue.arrayUnion([imageURL])});
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "User Details",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            hexStringToColor("CB2B93"),
            hexStringToColor("9546C4"),
            hexStringToColor("5E61F4")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                    "Enter Name of Product", Icons.question_mark, false, _nameController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                    "Enter discription of Product", Icons.info, false, _discriptionController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                    "Enter price of Product", Icons.onetwothree, false, _quantityController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                    "Enter price of Product", Icons.price_change, false, _priceController),
                const SizedBox(
                  height: 20,
                ),
                 RawMaterialButton(
                    fillColor: Theme.of(context).colorScheme.secondary,
                    child: Icon(Icons.add_photo_alternate_rounded,
                    color: Colors.white,),
                    elevation: 8,

                    onPressed: () {
                      getImage(true);
                    },
          
                    padding: EdgeInsets.all(15),
                    shape: CircleBorder(),
                ),
                 const SizedBox(
                  height: 20,
                ),
                RawMaterialButton(
                fillColor: Theme.of(context).colorScheme.secondary,
                child: Icon(Icons.add_circle,
                color: Colors.white,),
                elevation: 8,
                onPressed: () async {
                  await saveImages(_images,sightingRef);
                },
                
                padding: EdgeInsets.all(15),
              shape: CircleBorder(),
              ),
               const SizedBox(
                  height: 20,
                ),
                firebaseUIButton(context, "Save", () {
                sendUserDataToDB();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => productcategory()),
                  );
                }),
              ],
            ),
          ))),
    );
  }



}