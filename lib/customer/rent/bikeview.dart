import 'package:ats/constants/font.dart';
import 'package:ats/customer/rent/carpayment.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BikeView extends StatefulWidget {
  const BikeView({super.key});

  @override
  State<BikeView> createState() => _BikeViewState();
}

class _BikeViewState extends State<BikeView> {
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
                  child: Image.network('https://images.assettype.com/fortuneindia%2F2023-08%2F9dc1396c-a9b2-43f5-b7d9-78bd3eaf5be5%2FBrief_Bike_1.jpg?w=1250&q=60'),
                ),
                SizedBox(height: 20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Model of Car',
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
                      'qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq',
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
}