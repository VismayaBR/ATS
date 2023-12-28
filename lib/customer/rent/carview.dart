import 'package:ats/constants/font.dart';
import 'package:ats/customer/rent/carpayment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarView extends StatefulWidget {
  final String id;

  CarView({Key? key, required this.id}) : super(key: key);

  @override
  State<CarView> createState() => _CarViewState();
}

class _CarViewState extends State<CarView> {
  final _formKey = GlobalKey<FormState>();
  final _daysController = TextEditingController();
  late Map<String, dynamic> carData;
  late DateTime selectedDate;
  late DateTime selectedDate1;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
    selectedDate = DateTime.now();
    selectedDate1 = DateTime.now();
  }

  Future<void> fetchDataFromFirebase() async {
    try {
      final documentSnapshot = await FirebaseFirestore.instance
          .collection('rent')
          .doc(widget.id)
          .get();

      setState(() {
        carData = documentSnapshot.data() ?? {};
        isLoading = false; // Set loading to false after data is fetched
      });
    } catch (e) {
      print('Error fetching data: $e');
      // Handle errors as needed
      setState(() {
        isLoading = false; // Set loading to false in case of an error
      });
    }
  }

  Future<void> uploadDataToDatabase() async {
    try {
      if (_formKey.currentState!.validate()) {
        if (selectedDate != null && selectedDate1 != null) {
          SharedPreferences spref = await SharedPreferences.getInstance();
          final id = spref.getString('user_id');
          String formattedDate = '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}';
          String formattedDate1 = '${selectedDate1.day}-${selectedDate1.month}-${selectedDate1.year}';

          final bookingRef =
              FirebaseFirestore.instance.collection('car_booking');

          final DocumentReference bookingDoc = await bookingRef.add({
            'pick': formattedDate,
            'drop': formattedDate1,
            'car_id': widget.id,
            'status': '0',
            'cus_id': id,
            'pro_id': carData['pro_id'],
            'days': _daysController.text,
            'amount': '0',
          });

          final bookingId = bookingDoc.id;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CarPayment(
                cab: carData['name'],
                price: carData['price'],
                img: carData['v_image'],
                days: _daysController.text,
                id: bookingId,
              ),
            ),
          );
        } else {
          print('Selected date or time is null');
        }
      }
    } catch (e) {
      print('Error uploading data: $e');
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
                      'Car for rent',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (isLoading) // Display circular progress indicator during initial loading
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                if (!isLoading)
                  SizedBox(height: 10),
                if (!isLoading)
                  Container(
                    height: 200,
                    width: 400,
                    color: Clr.clrlight,
                    child: Image.network(carData['v_image']),
                  ),
                if (!isLoading)
                  SizedBox(height: 20),
                if (!isLoading)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        carData['name'],
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
                        carData['desc'],
                        style: GoogleFonts.poppins(fontSize: 15),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            'Pick up Date',
                            style: GoogleFonts.poppins(fontSize: 15),
                          ),
                          SizedBox(width: 90),
                          Text(
                            'Return Date',
                            style: GoogleFonts.poppins(fontSize: 15),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
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
                      SizedBox(height: 20),
                      Text('Number of days'),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _daysController,
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
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Clr.clrdark,
                      ),
                      height: 50,
                      width: double.infinity,
                    ),
                  ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
