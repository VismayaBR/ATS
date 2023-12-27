import 'package:ats/constants/font.dart';
import 'package:ats/customer/cab/cabview.dart';
import 'package:ats/customer/rent/carview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CarList extends StatefulWidget {
  const CarList({Key? key}) : super(key: key);

  @override
  State<CarList> createState() => _CarListState();
}

class _CarListState extends State<CarList> {
  late List<DocumentSnapshot<Map<String, dynamic>>> cabData = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  Future<dynamic> fetchDataFromFirebase() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('rent')
              .where('category', isEqualTo: 'Car')
              .get();

      setState(() {
        cabData = querySnapshot.docs;
      });
      return cabData;
    } catch (e) {
      print('Error fetching data: $e');
      // Handle errors as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            'Available Cars',
            style:
                GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cabData
                  .length, // Set the itemCount to the length of your data
              itemBuilder: (BuildContext context, int rowIndex) {
                return Container(
                  height: 800,
                  // ... (other properties)
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 9,
                      mainAxisSpacing: 9,
                    ),
                    itemCount: cabData
                        .length, // Set the itemCount to the length of your data
                    itemBuilder: (BuildContext context, int index) {
                      var cab = cabData[index].data();
                      return Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Container(
                          color: Clr.clrlight,
                          padding: const EdgeInsets.all(8),
                          // ... (other properties)
                          child: Center(
                            child: Column(
                              children: [
                                Expanded(
                                  child: Image.network(
                                    cab!['v_image'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Text(cab['name']),
                                Text(
                                  cab['status'] == true
                                      ? 'Available'
                                      : 'Not available',
                                  style: TextStyle(
                                    color: cab['status'] == true
                                        ? Color.fromARGB(255, 8, 171, 14)
                                        : // Color for 'Not available'
                                        Colors
                                            .red, // Change this color as needed
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (ctx) {
                                        return CarView(id: cabData[index].id);
                                      }),
                                    );
                                  },
                                  child: Container(
                                    height: 30,
                                    width: double.infinity,
                                    child: Center(
                                      child: Text(
                                        'Book',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Clr.clrdark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
