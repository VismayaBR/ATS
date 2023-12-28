import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CarPayment extends StatefulWidget {
  String cab;
  String price;
  String img;
  String days;

  CarPayment({super.key, required this.cab, required this.price, required this.img, required this.days});

  @override
  State<CarPayment> createState() => _CarPaymentState();
}

class _CarPaymentState extends State<CarPayment> {
  int calculateAdvanceAmount() {
    int pricePerDay = int.parse(widget.price);
    int numberOfDays = int.parse(widget.days);
    return pricePerDay * numberOfDays;
  }

  double calculateAdvanceAmount1() {
    int pricePerDay = int.parse(widget.price);
    int numberOfDays = int.parse(widget.days);
    var ttl = pricePerDay * numberOfDays / 2;
    return ttl;
  }

  void handlePayment() async {
    try {

      var documentId = 'yourDocumentId';

      // Calculate the advance amount
      int advanceAmount = calculateAdvanceAmount();

      // Update the advance amount in the car_booking collection
      await FirebaseFirestore.instance.collection('car_booking').doc(documentId).update({
        'advance_amount': advanceAmount,
      });

      // Add additional logic here if needed, such as navigation to a success screen
    } catch (e) {
      print('Error during payment: $e');
      // Handle payment errors as needed
    }
  }

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
              color: Colors.lightBlue, // Update color as needed
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: ListTile(
                  leading: CircleAvatar(
                    // Add your avatar logic here
                  ),
                  title: Text(widget.cab),
                  subtitle: Text('Price per day: ${widget.price}'),
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'No of days for rent',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${widget.days} Days',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Rs. ${calculateAdvanceAmount()}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Advance Amount',
                          style: GoogleFonts.poppins(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Half of the total amount',
                          style: GoogleFonts.poppins(
                              fontSize: 12, fontWeight: FontWeight.normal),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  width: 150,
                  height: 60,
                  color: Colors.lightBlue, // Update color as needed
                  child: Center(
                    child: Text(
                      '${calculateAdvanceAmount1()}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(),
            InkWell(
              onTap: handlePayment,
              child: Container(
                child: Center(
                  child: Text(
                    'Pay',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue, // Update color as needed
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
