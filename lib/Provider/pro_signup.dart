import 'dart:io';

import 'package:ats/Admin/Home.dart';
import 'package:ats/Provider/ProviderHome.dart';
import 'package:ats/constants/font.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ProSignup extends StatefulWidget {
  const ProSignup({Key? key}) : super(key: key);

  @override
  State<ProSignup> createState() => _ProSignupState();
}

class _ProSignupState extends State<ProSignup> {
  final _formKey = GlobalKey<FormState>();

  String? selectedCategory;

  var name = TextEditingController();
  var email = TextEditingController();
  var mobile = TextEditingController();
  var password = TextEditingController();
  var category = TextEditingController();
  var district = TextEditingController();
  var pincode = TextEditingController();

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

  // Future<void> uploadImage() async {
  //   try {
  //     if (_image != null) {
  //       // Get a reference to the storage service
  //       Reference storageReference =
  //           FirebaseStorage.instance.ref().child('uploads/${_image!.name}');

  //       // Upload the file to Firebase Storage
  //       await storageReference.putFile(File(_image!.path));

  //       // Get the download URL
  //       imageUrl = await storageReference.getDownloadURL();
  //     }
  //   } catch (e) {
  //     print('Error uploading image: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                  height: 30,
                ),
                TextFormField(
                  controller: name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Name',
                    filled: true,
                    fillColor: Clr.clrlight,
                    border: InputBorder.none,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: email,
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
                  controller: password,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Password';
                    }
                    RegExp passwordRegExp = RegExp(
                        r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{6,}$');
                    if (!passwordRegExp.hasMatch(value)) {
                      return 'Must be at least 6 and both letters and numbers.';
                    }
                    return null;
                  },
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
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    hintText: 'Category',
                    filled: true,
                    fillColor: Clr.clrlight,
                    border: InputBorder.none,
                  ),
                  items: [
                    DropdownMenuItem(value: 'Cab', child: Text('Cab')),
                    DropdownMenuItem(value: 'Rent', child: Text('Rent')),
                    // Add more DropdownMenuItem widgets as needed
                  ],
                  onChanged: (value) {
                    // Handle the selected value
                    print('Selected category: $value');
                    // You can perform any additional actions based on the selected value
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  // Set a prompt text as the initial value
                  value: selectedCategory,
                  hint: Text('Select a category'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null; // Return null if the value is valid
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: district,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your District';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'District',
                    filled: true,
                    fillColor: Clr.clrlight,
                    border: InputBorder.none,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: pincode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Pincode';
                    }
                    RegExp pincodeRegExp = RegExp(r'^\d{6}$');
                    if (!pincodeRegExp.hasMatch(value)) {
                      return 'Must be a 6-digit number.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Pincode',
                    filled: true,
                    fillColor: Clr.clrlight,
                    border: InputBorder.none,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 40,
                  width: double.infinity,
                  color: Clr.clrlight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload),
                      InkWell(
                          onTap: () async {
                            await pickImage();
                            // await uploadImage();
                          },
                          child: Text('Upload Proof'))
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () async {
                   uploadImage();
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
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
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

        // Ensure that imageUrl is set before adding data to Firestore
        if (imageUrl != null) {
          await FirebaseFirestore.instance.collection('providers').add({
            'name': name.text,
            'email': email.text,
            'mobile': mobile.text,
            'password': password.text,
            'category': selectedCategory,
            'district': district.text,
            'pincode': pincode.text,
            'status': '0',
            'image': imageUrl,
            'type': 'provider',
          }).then((value) => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return HomePage();
                }),
              ));
          // Navigate to the provider's home screen
        } else {
          print('Image URL is null. Image may not have been uploaded successfully.');
        }
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
}
