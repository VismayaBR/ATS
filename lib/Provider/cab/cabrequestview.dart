import 'package:ats/constants/font.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CabRequestView extends StatefulWidget {

  String cus_id;
  String cab_id;
  String date;
  String time;
  String drop;
  String pick;

  CabRequestView({super.key, 
  required this.cus_id,
  required this.cab_id, 
  required this.date, 
  required this.time, 
  required this.drop, 
  required this.pick
  });

  @override
  State<CabRequestView> createState() => _CabRequestViewState();
}

class _CabRequestViewState extends State<CabRequestView> {
  late Map<String, dynamic> cabData = {};
  late Map<String, dynamic> cusData = {};


  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
    fetchDataFromFirebase1();
  }

  Future<void> fetchDataFromFirebase() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance.collection('cabs').doc(widget.cab_id).get();

      setState(() {
        cabData = documentSnapshot.data() ?? {};
      });
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



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                  child: Image.network(cabData['v_image']),
                ),
                SizedBox(height: 20,),
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

                 Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Date',
                          style: GoogleFonts.poppins(fontSize: 15),
                        ),
                        Text(
                          widget.date,
                          style: GoogleFonts.poppins(fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Time',
                          style: GoogleFonts.poppins(fontSize: 15),
                        ),
                        Text(
                         widget.time,
                          style: GoogleFonts.poppins(fontSize: 15),
                        ),
                      ],
                    ),
                SizedBox(height: 40,),
                InkWell(
                  // onTap: (){
                  //   Navigator.push(context, MaterialPageRoute(builder: (ctx){
                  //     return CarPayment();
                  //   }));
                  // },
                  child: Container(
                    child: Center(
                        child: Text(
                      'Approve',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    )),
                    decoration: BoxDecoration(
                      // border: Border.all(),
                      borderRadius: BorderRadius.circular(8),
                      color: Clr.clrdark,
                    ),
                    height: 50,
                    width: double.infinity,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    child: Center(
                        child: Text(
                      'Reject',
                      style: GoogleFonts.poppins(
                        color: Clr.clrdark,
                        fontSize: 18,
                      ),
                    )),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(8),
                      color: Clr.clrlight,
                    ),
                    height: 50,
                    width: double.infinity,
                  ),
                  
                    
              ]),
        ),
      ),
    );
  }
}