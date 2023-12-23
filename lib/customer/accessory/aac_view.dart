import 'package:ats/Admin/navbar.dart';
import 'package:ats/constants/font.dart';
import 'package:ats/customer/Cus_Navbar.dart';
import 'package:ats/customer/accessory/acc_payment.dart';
import 'package:ats/customer/accessory/accessory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccView extends StatefulWidget {
  String id;
  String name;
  String price;
  String desc;
  AccView(
      {super.key,
      required String this.id,
      required this.name,
      required this.price,
      required this.desc});

  @override
  State<AccView> createState() => _AccViewState();
}

class _AccViewState extends State<AccView> {
  final _formKey = GlobalKey<FormState>();

  var qua = TextEditingController();
  var add = TextEditingController();
   Future<void> uploadDataToDatabase() async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    var id = spref.getString('user_id');
                         print('object');
                        try {
                          if (_formKey.currentState!.validate()) {
                            await FirebaseFirestore.instance
                                .collection('acc_booking')
                                .add({
                              'acc_id': widget.id,
                              'quandity': qua.text,
                              'address': add.text,
                              'cus_id':id
                            }).then((value) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return MyHomePage();
                              }));
                            });
                          }
                        } catch (e) {
                          print('Error uploading data: $e');
                        }
                      }
                      // Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                      //   return AccPayment();
                      // }));

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
                        'Accessory',
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
                    child: Image.network(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQuNCrtnkEWK7E3hRXcfe9x2xeRIp1nr8dvZhkgQDJ8vR8utJsndHhbuhXrQzyCqumV60E&usqp=CAU'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: GoogleFonts.poppins(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Rs. ${widget.price}',
                        style: GoogleFonts.poppins(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'About',
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.desc,
                        style: GoogleFonts.poppins(fontSize: 15),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            'Quandity',
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
                            child: SizedBox(
                              child: TextFormField(
                                controller: qua,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a quandity';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  // hintText: '1',
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
                      Text('Delivery address'),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: add,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter yor address';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          // hintText: 'Email',
                          filled: true,
                          fillColor: Clr.clrlight,
                          border: InputBorder.none,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("(Estimated Delivery in 5 days)"),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    onTap: () {
                     uploadDataToDatabase();
                     
                    },
                    child: Container(
                      child: Center(
                          child: Text(
                        'Place Order',
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
      ),
    );
  }
}
