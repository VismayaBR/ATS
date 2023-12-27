import 'package:ats/constants/font.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BikeReqView extends StatefulWidget {

  String cus_id;
  String pick;
  String drop;
  String car_id;
  String id;

  BikeReqView({super.key, 
  required this.cus_id, 
  required this.pick, 
  required this.drop, 
  required this.car_id, 
  required this.id
  });

  @override
  State<BikeReqView> createState() => _BikeReqViewState();
}

class _BikeReqViewState extends State<BikeReqView> {

  late Map<String, dynamic> bikeData = {};
  late Map<String, dynamic> cusData = {};
  late Map<String, dynamic> bookData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
    fetchDataFromFirebase1();
  }

  Future<void> fetchDataFromFirebase() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance.collection('rent').doc(widget.car_id).get();

      setState(() {
        bikeData = documentSnapshot.data() ?? {};
      });
       await fetchDataFromFirebase1();
      await bookingData();
    } catch (e) {
      print('Error fetching data: $e');
      // Handle errors as needed
    }
  }
    Future<void> fetchDataFromFirebase1() async {
  try {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance.collection('customers').doc(widget.cus_id).get();

    setState(() {
      cusData = documentSnapshot.data() ?? {};
    });
  } catch (e) {
    print('Error fetching data: $e');
    setState(() {
      cusData = {}; // Set to an empty map in case of an error
    });
  }
}

 Future<void> bookingData() async {
    try {
      print('.............${widget.id}............');
      DocumentSnapshot<Map<String, dynamic>> bookingSnapshot =
          await FirebaseFirestore.instance.collection('bike_booking').doc(widget.id).get();

      setState(() {
        bookData = bookingSnapshot.data() ?? {};
        print('.............${bookData}............');
      });
    } catch (e) {
      print('Error fetching booking data: $e');
    }
  }

  Future<void> updateStatus(String status) async {
    try {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('bike_booking').doc(widget.id);

      await documentReference.update({'status': status});

      // Refresh UI by fetching data again
      await fetchDataFromFirebase();

      print('Status updated successfully!');
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  Future<void> updateStatus1(String status) async {
    try {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('bike_booking').doc(widget.id);

      await documentReference.update({'status': status});

      // Refresh UI by fetching data again
      await fetchDataFromFirebase();

      print('Status updated successfully!');
    } catch (e) {
      print('Error updating status: $e');
    }
  }

 Widget buildStatusButtons() {
    print('>>>>>>>>>>>>>>>>>>>>>>${bookData['status']}');
//  if (isLoading) {
//       return Center(
//         child: CircularProgressIndicator(),
//       );
//     } else 
if (bookData['status'] == '0') {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 38, right: 38, bottom: 20, top: 10),
            child: InkWell(
              onTap: () {
                setState(() {
                  updateStatus('1'); // Accept
                });
              },
              child: Container(
                height: 50,
                width: double.infinity,
                child: Center(
                  child: Text('Accept', style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Clr.clrdark,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 38, right: 38, bottom: 10),
            child: InkWell(
              onTap: () {
                setState(() {
                  updateStatus('2'); // Reject
                });
              },
              child: Container(
                height: 45,
                width: double.infinity,
                child: Center(
                  child: Text('Reject', style: TextStyle(color: Color.fromARGB(255, 15, 1, 58), fontSize: 18)),
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Clr.clrdark),
                  borderRadius: BorderRadius.circular(10),
                  color: Clr.clrlight,
                ),
              ),
            ),
          ),
        ],
      );
    } else if (bookData['status'] == '1') {
      return Padding(
        padding: const EdgeInsets.only(left: 38, right: 38, bottom: 20, top: 10),
        child: Container(
          height: 50,
          width: double.infinity,
          child: Center(
            child: Text('Accepted', style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Clr.clrdark,
          ),
        ),
      );
    } else if (bookData['status'] == '2') {
      return Padding(
        padding: const EdgeInsets.only(left: 38, right: 38, bottom: 20, top: 10),
        child: Container(
          height: 50,
          width: double.infinity,
          child: Center(
            child: Text('Rejected', style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Clr.clrdark,
          ),
        ),
      );
    }

    return Container(); // Default case, return an empty container
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
                    Text('Requests',style: GoogleFonts.poppins(fontSize: 18,fontWeight: FontWeight.bold),),
                  ],
                ),
                SizedBox(height: 10,),
                Container(
                  height: 200,
                  width: 400,
                  color: Clr.clrlight,
                  child: Image.network(bikeData['v_image']),
                ),
                SizedBox(height: 20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bikeData['name'],
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Available',
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20,),
                    Text(
                      'Description',
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    // Text(
                    //   'qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq',
                    //   style: GoogleFonts.poppins(fontSize: 15),
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Text(
                        //   'seat',
                        //   style: GoogleFonts.poppins(fontSize: 15),
                        // ),
                        // Text(
                        //   bikeData['seat'],
                        //   style: GoogleFonts.poppins(fontSize: 15),
                        // ),
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
                          bikeData['price'],
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
                          'Customer name',
                          style: GoogleFonts.poppins(fontSize: 15),
                        ),
                        Text(
                          cusData['username']??'',
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
                          'Mobile',
                          style: GoogleFonts.poppins(fontSize: 15),
                        ),
                        Text(
                          cusData['mobile'],
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
                          'Pickup',
                          style: GoogleFonts.poppins(fontSize: 15),
                        ),
                        Text(
                          widget.pick,
                          style: GoogleFonts.poppins(fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Dropoff',
                          style: GoogleFonts.poppins(fontSize: 15),
                        ),
                        Text(
                          widget.drop,
                          style: GoogleFonts.poppins(fontSize: 15),
                        ),
                      ],
                    ),           ],
                ),
                                    SizedBox(height: 10,),

                
                    SizedBox(height: 10,),
                   
                SizedBox(height: 40,),
               buildStatusButtons()
                  
                    
              ]),
        ),
      ),
    );
  }
}