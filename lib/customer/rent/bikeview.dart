import 'package:ats/constants/font.dart';
import 'package:ats/customer/cab/cabpayment.dart';
import 'package:ats/customer/rent/bikepayment.dart';
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
  var days = TextEditingController();

  late Map<String, dynamic> bikeData = {};
  late DateTime selectedDate = DateTime.now();
  late DateTime selectedDate1 = DateTime.now();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  Future<void> uploadDataToDatabase() async {
    try {
      if (_formKey.currentState!.validate()) {
        if (selectedDate != null && selectedDate1 != null) {
          String formattedDate =
              '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}';
          String formattedDate1 =
              '${selectedDate1.day}-${selectedDate1.month}-${selectedDate1.year}';

          SharedPreferences spref = await SharedPreferences.getInstance();
          var id = spref.getString('user_id');

          final bookingRef =
              FirebaseFirestore.instance.collection('bike_booking');

          final DocumentReference bookingDoc = await bookingRef.add({
            'pick': formattedDate,
            'drop': formattedDate1,
            'car_id': widget.id,
            'status': "0",
            'cus_id': id,
            'pro_id': bikeData['pro_id'],
            'days': days.text,
            'amount': '0'
          });

          final bookingId = bookingDoc.id;
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return BikePayment(
              cab: bikeData['name'],
              price: bikeData['price'],
              img: bikeData['v_image'],
              days: days.text,
              id: bookingId,
            );
          }));
        } else {
          print('Selected date or time is null');
        }
      }
    } catch (e) {
      print('Error uploading data: $e');
    }
  }

  Future<void> fetchDataFromFirebase() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance.collection('rent').doc(widget.id).get();

      setState(() {
        bikeData = documentSnapshot.data() ?? {};
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bike for rent',
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                if (isLoading)
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                if (!isLoading)
                  Container(
                    height: 200,
                    width: 400,
                    color: Clr.clrlight,
                    child: Image.network(bikeData['v_image']),
                  ),
                SizedBox(height: 20),
                if (!isLoading)
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
                      SizedBox(height: 20),
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
                            child: InkWell(
                              onTap: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(DateTime.now().year + 100),
                                );

                                if (pickedDate != null &&
                                    pickedDate != selectedDate) {
                                  setState(() {
                                    selectedDate = pickedDate;
                                  });
                                }
                              },
                              child: TextFormField(
                                enabled: false,
                                decoration: InputDecoration(
                                  labelText: 'Date',
                                  filled: true,
                                  fillColor: Clr.clrlight,
                                ),
                                controller: TextEditingController(
                                  text:
                                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate1,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(DateTime.now().year + 100),
                                );

                                if (pickedDate != null &&
                                    pickedDate != selectedDate) {
                                  setState(() {
                                    selectedDate1 = pickedDate;
                                  });
                                }
                              },
                              child: TextFormField(
                                enabled: false,
                                decoration: InputDecoration(
                                  labelText: 'Date1',
                                  filled: true,
                                  fillColor: Clr.clrlight,
                                ),
                                controller: TextEditingController(
                                  text:
                                      '${selectedDate1.day}/${selectedDate1.month}/${selectedDate1.year}',
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
                        controller: days,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Clr.clrlight,
                          border: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 40),
                if (!isLoading)
                  InkWell(
                    onTap: () {
                      uploadDataToDatabase();
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
