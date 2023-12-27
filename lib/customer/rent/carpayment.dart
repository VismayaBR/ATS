import 'package:ats/constants/font.dart';
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
    int pricePerDay = int.parse(widget.price); // Convert the price to an integer
    int numberOfDays = int.parse(widget.days); // Convert the number of days to an integer

    // Calculate the advance amount
    int advanceAmount = pricePerDay * numberOfDays;

    return advanceAmount;
  }
   double calculateAdvanceAmount1() {
    int pricePerDay = int.parse(widget.price); // Convert the price to an integer
    int numberOfDays = int.parse(widget.days); // Convert the number of days to an integer

    // Calculate the advance amount
    int advanceAmount = pricePerDay * numberOfDays;

    var ttl = advanceAmount/2;
    return ttl;
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
              color: Clr.clrlight,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: ListTile(
                  leading: CircleAvatar(
                    // backgroundColor: Colors.black,
                  ),
                  title: Text(widget.cab),
                  subtitle: Text('Price per day : ${widget.price}'),
                ),
              ),
            ),
            Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text(
                //         'Advance Amount',
                //         style: GoogleFonts.poppins(
                //           fontSize: 16,
                //         ),
                //       ),
                //       Text(
                //         'Rs. 1500',
                //         style: GoogleFonts.poppins(
                //           fontSize: 16,
                //         ),
                //       )
                //     ],
                //   ),
                // ),
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
            SizedBox(height: 20,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Advance Amound',
                          style: GoogleFonts.poppins(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10,),
                        Text(
                      'Half of the total amount',
                      style: GoogleFonts.poppins(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    )
                      ],
                    )
                  ],
                ),
                SizedBox(height: 10,),
                Container(
                  width: 150,
                  height: 60,
                  color: Clr.clrlight,
                  child: Center(child: Text('${calculateAdvanceAmount1()}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
                ),
              ],
            ),
           SizedBox(),
            InkWell(
              // <------------------ADMIN------------------->
              // onTap: (){
              //   Navigator.push(context, MaterialPageRoute(builder:  (context){
              //     return MyNavigationBar();
              //   }));
              // <------------------------------------------->
            
              //  onTap: (){
              //   Navigator.push(context, MaterialPageRoute(builder:  (context){
              //     return MyHomePage();
              //   }));
            
              // },
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