import 'dart:io';

import 'package:ats/Provider/mechanicview.dart';
import 'package:ats/constants/font.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AddTech extends StatefulWidget {
  const AddTech({super.key});

  @override
  State<AddTech> createState() => _AddTechState();
}

class _AddTechState extends State<AddTech> {

  final _formKey = GlobalKey<FormState>();


    var email = TextEditingController();


  var mobile = TextEditingController();
  var name = TextEditingController();
  var exp = TextEditingController();

   XFile? _image;
  String? imageUrl;

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 80,
                ),
                Text(

                  'Add Mechanic',
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
                    child:_image == null
                              ? Column(
                                  children: [
                                    Icon(Icons.upload),
                                    Text('Upload Proof'),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Text(_image!.name),
                                  ],
                                ),
                  ),
                  height: 100,
                  width: double.infinity,
                  color: Clr.clrlight,
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
                        return 'Please enter Name';
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
                    Text('Mobile no'),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: mobile,
                  validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Mobile no';
                      }
                      RegExp mobileRegExp = RegExp(r'^\d{10}$');
                      if (!mobileRegExp.hasMatch(value)) {
                        return 'Please enter a valid mobile number';
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
                    Text('Experience'),
                  ],
                ),
            
               SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: exp,
                  validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter years of experience';
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
                  onTap: ()
                  {
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
   Future<void> uploadDataToDatabase() async {
    try {
      if (_formKey.currentState!.validate()) {
        await uploadImage();
        await FirebaseFirestore.instance.collection('mechanics').add({
          'name': name.text,
          'mobile': mobile.text,
          'experience': exp.text,
          'proof':imageUrl
        }).then((value) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Mech();
          }));
        });
      }
    } catch (e) {
      print('Error uploading data: $e');
    }
  }
}