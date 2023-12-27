import 'package:ats/constants/font.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CarPayment extends StatefulWidget {
  String cab;
  String price;
  String img;
  CarPayment(
      {super.key, required this.cab, required this.price, required this.img});

  @override
  State<CarPayment> createState() => _CarPaymentState();
}

class _CarPaymentState extends State<CarPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Payment')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Card(
              color: Clr.clrlight,
              child: ListTile(
                // leading: CircleAvatar(
                //   backgroundImage: NetworkImage(widget.img),
                // ),
                title: Text(widget.cab),
                subtitle: Text('Price per hour : ${widget.price}'),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Advance Amount',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Rs. 250',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total amount',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: Text(
                          'Depends on distance',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Amound',
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 150,
                  height: 60,
                  color: Clr.clrlight,
                  child: Center(
                      child: Text(
                    '250',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
                ),
              ],
            ),
            SizedBox(),
            InkWell(
             
            
              child: Container(
                child: Center(
                    child: Text(
                  'Pay',
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
          ],
        ),
      ),
    );
  }
}
