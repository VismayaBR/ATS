import 'package:ats/constants/font.dart';
import 'package:ats/customer/cab/cabpayment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CabView extends StatefulWidget {
  final String id;

  CabView({Key? key, required this.id}) : super(key: key);

  @override
  State<CabView> createState() => _CabViewState();
}

class _CabViewState extends State<CabView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController pick = TextEditingController();
  final TextEditingController drop = TextEditingController();
  late Map<String, dynamic> cabData = {};
  late DateTime selectedDate = DateTime.now();
  TimeOfDay? selectedTime; // Initialize with a default value
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  Future<void> fetchDataFromFirebase() async {
    try {
      setState(() {
        isLoading = true; // Set loading to true when starting to fetch data
      });

      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance.collection('cabs').doc(widget.id).get();

      setState(() {
        cabData = documentSnapshot.data() ?? {};
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
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Cab Booking',
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                if (isLoading) // Display circular progress indicator during initial loading
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                if (!isLoading && cabData.isNotEmpty)
                  Container(
                    height: 200,
                    width: 400,
                    color: Clr.clrlight,
                    child: Image.network(cabData['v_image']),
                  ),
                if (!isLoading && cabData.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cabData['name'],
                        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Rs. ${cabData['price']}',
                        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        cabData['desc'],
                        style: GoogleFonts.poppins(fontSize: 15),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            'Date',
                            style: GoogleFonts.poppins(fontSize: 15),
                          ),
                          SizedBox(
                            width: 170,
                          ),
                          Text(
                            'Time',
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
                                  lastDate: DateTime(DateTime.now().year + 1),
                                );

                                if (pickedDate != null && pickedDate != selectedDate) {
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
                                  text: '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );

                                if (pickedTime != null) {
                                  setState(() {
                                    selectedTime = pickedTime;
                                  });
                                }
                              },
                              child: TextFormField(
                                enabled: false,
                                decoration: InputDecoration(
                                  labelText: 'Time',
                                  filled: true,
                                  fillColor: Clr.clrlight,
                                ),
                                controller: TextEditingController(
                                  text: selectedTime != null ? '${selectedTime!.format(context)}' : '',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text('Pickup point'),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: pick,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Clr.clrlight,
                          border: InputBorder.none,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text('Drop off'),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: drop,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Clr.clrlight,
                          border: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                if (!isLoading && cabData.isNotEmpty)
                  InkWell(
                    onTap: () {
                      print('object');
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

  Future<void> uploadDataToDatabase() async {
    try {
      if (_formKey.currentState!.validate()) {
        if (selectedDate != null && selectedTime != null) {
          String formattedDate = '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
          String formattedTime = '${selectedTime!.hour}:${selectedTime!.minute}';
          SharedPreferences spref = await SharedPreferences.getInstance();
          var id = spref.getString('user_id');

          // Check for potential null values in cabData
          var proId = cabData['pro_id'] ?? '';
          var price = cabData['price'] ?? '';

          await FirebaseFirestore.instance.collection('cab_booking').add({
            'date': formattedDate,
            'time': formattedTime,
            'pick': pick.text ?? '',
            'drop': drop.text ?? '',
            'cab_id': widget.id,
            'status': "0",
            'cus_id': id,
            'pro_id': proId,
            'pay': price,
          }).then((value) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return CabPayment(
                cab: cabData['name'] ?? '',
                price: price,
                img: cabData['v_image'] ?? '',
              );
            }));
          });
        } else {
          print('Selected date or time is null');
        }
      }
    } catch (e) {
      print('Error uploading data: $e');
    }
  }
}
