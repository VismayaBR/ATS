import 'package:ats/constants/font.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CabRequestView1 extends StatefulWidget {
  String id;
  CabRequestView1({super.key, required this.id});

  @override
  State<CabRequestView1> createState() => _CabRequestView1State();
}

class _CabRequestView1State extends State<CabRequestView1> {

   late Map<String, dynamic> cabData = {};
  late String imageUrl = '';

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  Future<void> fetchDataFromFirebase() async {
    try {
      
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance.collection('cabs')
          .doc(widget.id).get();

      setState(() {
        cabData = documentSnapshot.data() ?? {};
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Cab',
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 200,
                  width: 400,
                  color: Clr.clrlight,
                  child: Image.network(
                      cabData['v_image']),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cabData['name'],
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Available',
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Description',
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      cabData['desc'],
                      // 'k',
                      style: GoogleFonts.poppins(fontSize: 15),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'seat',
                          style: GoogleFonts.poppins(fontSize: 15),
                        ),
                        Text(
                          cabData['seat'],
                          style: GoogleFonts.poppins(fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Price per hour',
                          style: GoogleFonts.poppins(fontSize: 15),
                        ),
                        Text(
                          cabData['price'],
                          style: GoogleFonts.poppins(fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                     Container(
                      
              child: Image.network(cabData['rc']),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [

              //     // Icon(Icons.document_scanner_outlined),
              //     // Text('View RC'),
              //   ],
              // ),
              height: 100,
              width: double.infinity,
              color: Clr.clrlight,
            ),
                    
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                
              ]),
        ),
      ),
    );
  }
}
