import 'package:ats/constants/font.dart';
import 'package:ats/customer/cab/cabpayment.dart';
import 'package:ats/customer/rent/carpayment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BikeView extends StatefulWidget {
  String id;
  BikeView({super.key, required this.id});

  @override
  State<BikeView> createState() => _BikeViewState();
}

class _BikeViewState extends State<BikeView> {
  var _formKey = GlobalKey<FormState>();

  var pick = TextEditingController();
  var drop = TextEditingController();

  late Map<String, dynamic> bikeData = {};
  late DateTime selectedDate = DateTime.now();
  var selectedTime; // Initialize with a default value

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

   Future<void> fetchDataFromFirebase() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection('rent')
              .doc(widget.id)
              .get();


      setState(() {
        bikeData = documentSnapshot.data() ?? {};
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
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Bike for rent',style: GoogleFonts.poppins(fontSize: 18,fontWeight: FontWeight.bold),),
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
                    Text(
                      bikeData['desc'],
                      style: GoogleFonts.poppins(fontSize: 15),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          'Pick up Date',
                          style: GoogleFonts.poppins(fontSize: 15),
                        ),
                        SizedBox(
                          width: 90,
                        ),
                        Text(
                          'Return Date',
                          style: GoogleFonts.poppins(fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: '12/2/20223',
                                filled: true,
                                fillColor: Clr.clrlight,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: SizedBox(
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: '12/2/20223',
                                filled: true,
                                fillColor: Clr.clrlight,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    
                   
                   
                    Text('Number of days'),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        // hintText: 'Email',
                        filled: true,
                        fillColor: Clr.clrlight,
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40,),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (ctx){
                      return CarPayment();
                    }));
                  },
                  child: Container(
                    child: Center(
                        child: Text(
                      'Book',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    )),
                    decoration: BoxDecoration(
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
              ]),
        ),
      ),
    );
  }

//   Future<void> uploadDataToDatabase() async {
//     try {
//       if (_formKey.currentState!.validate()) {
//         if (selectedDate != null && selectedTime != null) {
//           // Convert DateTime to formatted date string
//           String formattedDate =
//               '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';

//           // Convert TimeOfDay to formatted time string
//           String formattedTime =
//               '${selectedTime!.hour}:${selectedTime!.minute}';
// SharedPreferences spref = await SharedPreferences.getInstance();
//     var id = spref.getString('user_id');
//           await FirebaseFirestore.instance.collection('cab_booking').add({
//             'date': formattedDate, // Store date as formatted string
//             'time': formattedTime, // Store time as formatted string
//             'pick': pick.text ?? '',
//             'drop': drop.text ?? '',
//             'cab_id': widget.id,
//             'status':"0",
//             'cus_id':id

//           }).then((value) {
//             Navigator.push(context, MaterialPageRoute(builder: (context) {
//               return CabPayment(cab:cabData['name'],price:cabData['price'],img:cabData['v_image']);
//             }));
//           });
//         } else {
//           print('Selected date or time is null');
//         }
//       }
//     } catch (e) {
//       print('Error uploading data: $e');
//     }
//   }
}
