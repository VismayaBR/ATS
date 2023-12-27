import 'package:ats/constants/font.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarViewPro extends StatefulWidget {
  String id;
  CarViewPro({Key? key, required this.id}) : super(key: key);

  @override
  State<CarViewPro> createState() => _CarViewProState();
}
class _CarViewProState extends State<CarViewPro> {
  late Map<String, dynamic> carData = {};
  late bool isAvailable; // Availability status

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  Future<void> fetchDataFromFirebase() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance.collection('rent').doc(widget.id).get();

      setState(() {
        carData = documentSnapshot.data() ?? {};
        isAvailable = carData['status'] ?? false; // Set availability status
      });
    } catch (e) {
      print('Error fetching data: $e');
      // Handle errors as needed
    }
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
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Car for rent',
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
                child: Image.network(carData['v_image']),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    carData['name'],
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text('Available:',
                          style: GoogleFonts.poppins(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Transform.scale(
                        scale: 0.8, // Adjust the scaling factor as needed
                        child: Switch(
                          value: isAvailable,
                          onChanged: (value) async {
                            setState(() {
                              isAvailable = value;
                            });
                            await updateAvailabilityStatus(value);
                          },
                          activeTrackColor: Colors
                              .green, // Change the color of the track when switch is ON
                          activeColor: Colors
                              .white, // Change the color of the thumb when switch is ON
                          inactiveThumbColor: const Color.fromARGB(255, 255, 255, 255), // Change the color of the thumb when switch is OFF
                          inactiveTrackColor: Colors.grey,
                        ),
                      ),
                    ],
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
                    carData['desc'],
                    style: GoogleFonts.poppins(fontSize: 15),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
