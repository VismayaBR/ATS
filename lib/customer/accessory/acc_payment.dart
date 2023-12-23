import 'package:ats/constants/font.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccPayment extends StatefulWidget {
  const AccPayment({super.key});

  @override
  State<AccPayment> createState() => _AccPaymentState();
}

class _AccPaymentState extends State<AccPayment> {
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
                    backgroundColor: Colors.black,
                  ),
                  title: Text('Model name'),
                  // subtitle: Text('Provider name'),
                ),
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
                        'Amount',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Rs. 1500',
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
                    'Quandity',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '1',
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
                    Text(
                      'Total Amound',
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(height: 10,),
                Container(
                  width: 150,
                  height: 60,
                  color: Clr.clrlight,
                  child: Center(child: Text('10500',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
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