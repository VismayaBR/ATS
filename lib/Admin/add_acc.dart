import 'dart:io';

import 'package:ats/Admin/accessories.dart';
import 'package:ats/Admin/navbar.dart';
import 'package:ats/Login.dart';
import 'package:ats/constants/font.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AddAcc extends StatefulWidget {
  const AddAcc({super.key});

  @override
  State<AddAcc> createState() => _AddAccState();
}

class _AddAccState extends State<AddAcc> {

    final _formKey = GlobalKey<FormState>();

      var name = TextEditingController();
  var desc = TextEditingController();
  var price = TextEditingController();

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

  Future<void> uploadDataToDatabase() async {
    try {
      if (_formKey.currentState!.validate()) {
        await uploadImage();
        await FirebaseFirestore.instance.collection('accessories').add({
          'name': name.text,
          'desc': desc.text,
          'price': price.text,
         'image':imageUrl

        }).then((value) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return MyNavigationBar();
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
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Add Accessories',
                      style: GoogleFonts.poppins(
                          color: Clr.clrdark,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Accessory name',
                          style: GoogleFonts.poppins(fontSize: 15),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: name,
                      validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Acceossory name';
                    }
                   
                    return null;
                  },
                      decoration: InputDecoration(
                        // hintText: 'Password',
                        filled: true,
                        fillColor: Clr.clrlight,
                        border: InputBorder.none,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: GoogleFonts.poppins(fontSize: 15),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: desc,
                        validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Description';
                    }
                    return null;
                        },
                   
                      decoration: InputDecoration(
                        // hintText: 'Password',
                        filled: true,
                        fillColor: Clr.clrlight,
                        border: InputBorder.none,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Price',
                          style: GoogleFonts.poppins(fontSize: 15),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: price,
                             validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Price';
                    }
                    return null;
                        },
                   
                      decoration: InputDecoration(
                        // hintText: 'Password',
                        filled: true,
                        fillColor: Clr.clrlight,
                        border: InputBorder.none,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Add Image',
                          style: GoogleFonts.poppins(fontSize: 15),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () async {
                         await pickImage();
                      await uploadImage();
                      },
                      child: Container(
                        child: Center(child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             _image == null
                              ? Column(
                                  children: [
                                    Icon(Icons.upload),
                                    Text('Upload image'),
                                  ],
                                )
                              : Column(
                                  children: [
                                    
                                    Text(_image!.name),
                                  ],
                                ),
                          ],
                        )),
                        height: 200,
                        color: Clr.clrlight,
                      ),
                    )
                  ],
                ),
                InkWell(
                  onTap: (){
                    uploadDataToDatabase();
                  },
                  child: Container(height: 50,width: double.infinity,
                    child: Center(child: Text('Add',style: TextStyle(color: Colors.white,fontSize: 18),)),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Clr.clrdark,),),
                ),
              SizedBox(height: 25,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
