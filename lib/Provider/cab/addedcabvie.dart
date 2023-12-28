import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CabRequestView1 extends StatefulWidget {
  final String id;

  CabRequestView1({Key? key, required this.id}) : super(key: key);

  @override
  State<CabRequestView1> createState() => _CabRequestView1State();
}

class _CabRequestView1State extends State<CabRequestView1> {
  Map<String, dynamic> cabData = {};
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
        cabData = documentSnapshot.data() ?? {};
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
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
              SizedBox(height: 40),
              Center(
                child: Text(
                  'Cab',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              if (isLoading)
                Center(
                  child: CircularProgressIndicator(),
                )
              else
                CabDetailsWidget(cabData: cabData),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class CabDetailsWidget extends StatelessWidget {
  final Map<String, dynamic> cabData;

  CabDetailsWidget({required this.cabData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
        Container(
          height: 200,
          width: 400,
          color: const Color.fromARGB(255, 255, 255, 255),
          child: Image.network(
            cabData['v_image'] ?? '',
          ),
        ),
        SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cabData['name'] ?? '',
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
            SizedBox(height: 20),
            Text(
              'Description',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              cabData['desc'] ?? '',
              style: GoogleFonts.poppins(fontSize: 15),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CabDetail(label: 'seat', value: cabData['seat']?.toString() ?? ''),
                CabDetail(label: 'Price per day', value: cabData['price']?.toString() ?? ''),
              ],
            ),
            SizedBox(height: 20),
            Container(
              height: 100,
              width: double.infinity,
              color: const Color.fromARGB(255, 255, 255, 255),
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
      ],
    );
  }
}

class CabDetail extends StatelessWidget {
  final String label;
  final String value;

  CabDetail({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 15),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(fontSize: 15),
        ),
      ],
    );
  }
}
