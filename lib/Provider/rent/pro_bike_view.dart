import 'package:ats/constants/font.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BikeViewPro extends StatefulWidget {
  final String id;

  BikeViewPro({required this.id});

  @override
  State<BikeViewPro> createState() => _BikeViewProState();
}

class _BikeViewProState extends State<BikeViewPro> {
  late bool isAvailable;
  late Map<String, dynamic> bikeData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  Future<void> updateAvailabilityStatus(bool newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('rent')
          .doc(widget.id)
          .update({'status': newStatus});
      print('Status updated successfully');
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  Future<void> fetchDataFromFirebase() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance.collection('rent').doc(widget.id).get();

      setState(() {
        bikeData = documentSnapshot.data() ?? {};
        isAvailable = bikeData['status'] ?? false;
        isLoading = false; // Set isLoading to false when data fetching is complete
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false; // Set isLoading to false even if there's an error
      });
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
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Bike for Rent',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 200,
                width: 400,
                color: Clr.clrlight,
                child: Image.network(bikeData['v_image']),
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bikeData['name'],
                    style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        'Available:',
                        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Transform.scale(
                        scale: 0.8,
                        child: Switch(
                          value: isAvailable,
                          onChanged: isLoading
                              ? null // Disable switch when loading
                              : (value) async {
                                  setState(() {
                                    isAvailable = value;
                                  });
                                  await updateAvailabilityStatus(value);
                                },
                          activeTrackColor: Colors.green,
                          activeColor: Colors.white,
                          inactiveThumbColor: const Color.fromARGB(255, 255, 255, 255),
                          inactiveTrackColor: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Description',
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    bikeData['desc'],
                    style: GoogleFonts.poppins(fontSize: 15),
                  ),
                  SizedBox(height: 20),
                ],
              ),
              SizedBox(height: 40),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
