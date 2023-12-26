import 'package:ats/constants/font.dart';
import 'package:ats/customer/rent/bikeview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BikeList extends StatefulWidget {
  const BikeList({super.key});

  @override
  State<BikeList> createState() => _BikeListState();
}

class _BikeListState extends State<BikeList> {
   late List<DocumentSnapshot<Map<String, dynamic>>> bikeData = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  Future<dynamic> fetchDataFromFirebase() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('rent').where('category',isEqualTo: 'Bike').get();

      setState(() {
        bikeData = querySnapshot.docs;
      });
      return bikeData;
    } catch (e) {
      print('Error fetching data: $e');
      // Handle errors as needed
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Column(
        children: [
          Text('Rental Bikes',style: GoogleFonts.poppins(fontSize: 20,fontWeight: FontWeight.w500),),
          Expanded(
            child: ListView.builder(
              itemCount: 1, // Number of rows in your grid
              itemBuilder: (BuildContext context, int rowIndex) {
                return Container(
                  // color: Clr.clrlight,
                  height: 800, // Adjust the height of each row as needed
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 9,
                      mainAxisSpacing: 9,
                    ),
                     itemCount: bikeData.length, // Set the itemCount to the length of your data
                    itemBuilder: (BuildContext context, int index) {
                      var bike = bikeData[index].data();
                      return Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            color: Clr.clrlight,
                            child: Center(
                              child: Column(
                                children: [
                                  Expanded(
                                    child:Image.network(bike!['v_image'],),
                                  ),
                                  Text(bike!['name']),
                                  Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: InkWell(
                                       onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (ctx) {
                                          return BikeView(id: bikeData[index].id,);
                                        }));
                                       },
                                      child: Container(
                                        height: 30,
                                        width: double.infinity,
                                        child: Center(
                                          child: Text(
                                            'Book',
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 15),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Clr.clrdark,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
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