import 'package:ats/constants/font.dart';
import 'package:ats/customer/accessory/acc_payment.dart';
import 'package:ats/customer/cab/cabpayment.dart';
import 'package:ats/customer/rent/carpayment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccView1 extends StatefulWidget {
  String id;
  AccView1({super.key, required this.id});

  @override
  State<AccView1> createState() => _AccView1State();
}

class _AccView1State extends State<AccView1> {

   late Map<String, dynamic> accData = {};
  late String imageUrl = '';

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  Future<void> fetchDataFromFirebase() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance.collection('accessories').doc(widget.id).get();

      setState(() {
        accData = documentSnapshot.data() ?? {};
      });
    } catch (e) {
      print('Error fetching data: $e');
      // Handle errors as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: SingleChildScrollView(
          child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Accessory',style: GoogleFonts.poppins(fontSize: 18,fontWeight: FontWeight.bold),),
                  ],
                ),
                SizedBox(height: 10,),
                Container(
                  height: 200,
                  width: 400,
                  color: Clr.clrlight,
                  child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQuNCrtnkEWK7E3hRXcfe9x2xeRIp1nr8dvZhkgQDJ8vR8utJsndHhbuhXrQzyCqumV60E&usqp=CAU'),
                ),
                SizedBox(height: 20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      accData['name'],
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Rs. ${accData['price']}',
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20,),
                    Text(
                      'About',
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      accData['desc'],
                      style: GoogleFonts.poppins(fontSize: 15),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                   
                    SizedBox(
                      height: 10,
                    ),
                  
                  ],
                ),
                SizedBox(height: 60,),
               
                SizedBox(
                  height: 10,
                ),
              ]),
        ),
      ),
    );
  }
}