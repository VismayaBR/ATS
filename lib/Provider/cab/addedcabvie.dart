import 'package:ats/constants/font.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CabRequestView1 extends StatefulWidget {
  String id;
  CabRequestView1({super.key, required this.id, });

  @override
  State<CabRequestView1> createState() => _CabRequestView1State();
}

class _CabRequestView1State extends State<CabRequestView1> {
  Map<String, dynamic> cabData = {}; // Initialize with an empty map
  late String imageUrl = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  Future<void> fetchDataFromFirebase() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection('cabs')
              .doc(widget.id)
              .get();

      setState(() {
        cabData = documentSnapshot.data() ??
            {}; // Use null-aware operator to handle null
        isLoading = false; // Set loading to false when data is fetched
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading =
            false; // Ensure loading is set to false even if an error occurs
      });
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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              if (isLoading)
                Center(
                    child:
                        CircularProgressIndicator()) // Show a circular progress indicator while loading
              else
                Container(
                  height: 200,
                  width: 400,
                  color: Clr.clrlight,
                  child: Image.network(cabData['v_image'] ??
                      ''), // Use null-aware operator to handle null
                ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cabData['name'] ??
                        '', // Use null-aware operator to handle null
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Available',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Description',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    cabData['desc'] ??
                        '', // Use null-aware operator to handle null
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
                        cabData['seat'] ??
                            '', // Use null-aware operator to handle null
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
                        'Price per day',
                        style: GoogleFonts.poppins(fontSize: 15),
                      ),
                      Text(
                        cabData['price'] ??
                            '', // Use null-aware operator to handle null
                        style: GoogleFonts.poppins(fontSize: 15),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 100,
                    width: double.infinity,
                    color: Clr.clrlight,
                    child: Image.network(
                      cabData['rc'] ?? '',
  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                        
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
