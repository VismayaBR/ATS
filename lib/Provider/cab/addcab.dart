import 'dart:io';

import 'package:ats/Login.dart';
import 'package:ats/Provider/Pro_navbar.dart';
import 'package:ats/constants/font.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCab extends StatefulWidget {
  const AddCab({super.key});

  @override
  State<AddCab> createState() => _AddCabState();
}

class _AddCabState extends State<AddCab> {

  final _formKey = GlobalKey<FormState>();

  var name = TextEditingController();
  var price = TextEditingController();
  var seat = TextEditingController();
  var desc = TextEditingController();

  XFile? _image;
  String? imageUrl;

  XFile? _image1;
  String? imageUrl1;

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? pickedImage;

    try {
      pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    } catch (e) {
      print('Error picking image: $e');
    }

    if (pickedImage != null) {
      setState(() {
        _image = pickedImage;
      });
    }
  }

  Future<void> uploadImage() async {
    try {
      if (_image != null) {
        // Get a reference to the storage service
        Reference storageReference =
            FirebaseStorage.instance.ref().child('uploads/${_image!.name}');

        // Upload the file to Firebase Storage
        await storageReference.putFile(File(_image!.path));

        // Get the download URL
        imageUrl = await storageReference.getDownloadURL();
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> pickImage1() async {
    final ImagePicker _picker = ImagePicker();
    XFile? pickedImage;

    try {
      pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    } catch (e) {
      print('Error picking image: $e');
    }

    if (pickedImage != null) {
      setState(() {
        _image1 = pickedImage;
      });
    }
  }

  Future<void> uploadImage1() async {
    try {
      if (_image1 != null) {
        // Get a reference to the storage service
        Reference storageReference =
            FirebaseStorage.instance.ref().child('uploads/${_image1!.name}');

        // Upload the file to Firebase Storage
        await storageReference.putFile(File(_image1!.path));

        // Get the download URL
        imageUrl1 = await storageReference.getDownloadURL();
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

   Future<void> uploadDataToDatabase() async {
    try {
      if (_formKey.currentState!.validate()) {
        SharedPreferences spref = await SharedPreferences.getInstance();
        var id = spref.getString('user_id');
        print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$id');
        await uploadImage();
        await FirebaseFirestore.instance.collection('cabs').add({
          'v_image': imageUrl,
          'rc': imageUrl1,
          'name': name.text,
          'seat': seat.text,
          'price': price.text,
          'desc':desc.text,
          'pro_id':id

        }).then((value) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ProNavbar();
          }));
        });
      }
    } catch (e) {
      print('Error uploading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Add your Cab',
                  style: GoogleFonts.poppins(
                    color: Clr.clrdark,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: InkWell(
                    onTap: () async {
                      await pickImage();
                      await uploadImage();
                    },
                    child:  _image == null
                              ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.upload),
                                    Text('Upload Image of cab'),
                                  ],
                                )
                              : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(_image!.name),
                                  ],
                                ),
                  ),
                  height: 50,
                  width: double.infinity,
                  color: Clr.clrlight,
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    await pickImage1();
                    await uploadImage1();
                  },
                  child: Container(
                    child:  _image1 == null
                              ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.upload),
                                    Text('Upload Driving License'),
                                  ],
                                )
                              : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(_image1!.name),
                                  ],
                                ),
                    height: 50,
                    width: double.infinity,
                    color: Clr.clrlight,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text('Name'),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter cab name';
                    }
            
                    return null;
                  },
                  decoration: InputDecoration(
                    // hintText: 'Email',
                    filled: true,
                    fillColor: Clr.clrlight,
                    border: InputBorder.none,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text('Seat'),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: seat,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter no of seat';
                    }
            
                    return null;
                  },
                  decoration: InputDecoration(
                    // hintText: 'Email',
                    filled: true,
                    fillColor: Clr.clrlight,
                    border: InputBorder.none,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text('Price per hour'),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: price,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter price per day';
                    }
            
                    return null;
                  },
                  decoration: InputDecoration(
                    // hintText: 'Email',
                    filled: true,
                    fillColor: Clr.clrlight,
                    border: InputBorder.none,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text('Description'),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: desc,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter description';
                    }
            
                    return null;
                  },
                  decoration: InputDecoration(
                    // hintText: 'Email',
                    filled: true,
                    fillColor: Clr.clrlight,
                    border: InputBorder.none,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    uploadDataToDatabase();
                  },
                  child: Container(
                    child: Center(
                        child: Text(
                      'ADD',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    )),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Clr.clrdark,
                    ),
                    height: 50,
                    width: double.infinity,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
