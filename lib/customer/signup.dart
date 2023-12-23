import 'dart:io';
import 'package:ats/Login.dart';
import 'package:ats/constants/font.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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

  final _formKey = GlobalKey<FormState>();

  var email = TextEditingController();
  var mobile = TextEditingController();
  var name = TextEditingController();
  var password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                ),
               
               
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Sign Up',
                    style: GoogleFonts.poppins(fontSize: 40),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Let's setup your account",
                      style: GoogleFonts.poppins(fontSize: 15)),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Email';
                  }
                  RegExp emailRegExp =
                      RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
                  if (!emailRegExp.hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                controller: email,
                decoration: InputDecoration(
                  hintText: 'Email',
                  filled: true,
                  fillColor: Clr.clrlight,
                  border: InputBorder.none,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
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
                controller: mobile,
                decoration: InputDecoration(
                  hintText: 'Mobile',
                  filled: true,
                  fillColor: Clr.clrlight,
                  border: InputBorder.none,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Username';
                  }
                  return null;
                },
                controller: name,
                decoration: InputDecoration(
                  hintText: 'Username',
                  filled: true,
                  fillColor: Clr.clrlight,
                  border: InputBorder.none,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Password';
                  }
                  RegExp passwordRegExp =
                      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{6,}$');
                  if (!passwordRegExp.hasMatch(value)) {
                    return 'Must be at least 6 and both letters and numbers.';
                  }
                  return null;
                },
                
                controller: password,
                decoration: InputDecoration(
                  
                  hintText: 'Password',
                  filled: true,
                  fillColor: Clr.clrlight,
                  border: InputBorder.none,
                ),
              ),
              SizedBox(
                height: 20,
              ),
                InkWell(
                  onTap: () async {
                    await pickImage();
                    await uploadImage();
                  },
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    color: Clr.clrlight,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _image == null
                              ? Column(
                                  children: [
                                    Icon(Icons.upload),
                                    Text('Upload Driving License'),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Text(_image!.name),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                InkWell(
                  onTap: () async {
                    await uploadImage();
                    await uploadDataToDatabase();
                  },
                  child: Container(
                    child: Center(
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
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
        
        await FirebaseFirestore.instance.collection('customers').add({
          'email': email.text,
          'mobile': mobile.text,
          'username': name.text,
          'password': password.text,
          'type': 'customer',
          'proof': imageUrl,
          'status':'0'

        }).then((value) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }));
        });
      }
    } catch (e) {
      print('Error uploading data: $e');
    }
  }
}
