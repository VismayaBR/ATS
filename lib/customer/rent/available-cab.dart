import 'package:ats/constants/font.dart';
import 'package:ats/customer/cab/cabview.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AvailableCab extends StatefulWidget {
  const AvailableCab({Key? key}) : super(key: key);

  @override
  State<AvailableCab> createState() => _AvailableCabState();
}

class _AvailableCabState extends State<AvailableCab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            'Available Cabs',
            style:
                GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 1, // Number of rows in your grid
              itemBuilder: (BuildContext context, int rowIndex) {
                return Container(
                  // color: Clr.clrlight,
                  height: 800, // Adjust the height of each row as needed
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 9,
                      mainAxisSpacing: 9,
                    ),
                    itemCount: 10, // Number of items in each row
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            color: Clr.clrlight,
                            child: Center(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      'https://www.evoximages.com/wp-content/uploads/2021/09/img_0_0_30-e1630602054753.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Text('Vehicle name'),
                                  Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: InkWell(
                                      onTap: () {
                                        // Navigator.push(context,
                                        //     MaterialPageRoute(builder: (ctx) {
                                        //   return CabView();
                                        // }));
                                      },
                                      child: Container(
                                        height: 30,
                                        width: double.infinity,
                                        child: Center(
                                          child: Text(
                                            'Book',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Clr.clrdark,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Function to get the color based on the index
  // Color _getColor(int index) {
  //   // Define your color logic here
  //   switch (index % 5) {
  //     case 0:
  //       return Colors.teal[100]!;
  //     case 1:
  //       return Colors.teal[200]!;
  //     case 2:
  //       return Colors.teal[300]!;
  //     case 3:
  //       return Colors.teal[400]!;
  //     case 4:
  //       return Colors.teal[500]!;
  //     default:
  //       return Colors.teal[600]!;
  //   }
  // }

  // Function to get the text based on the index
  String _getText(int index) {
    // Define your text logic here
    switch (index % 6) {
      case 0:
        return "He'd have you all unravel at the";
      case 1:
        return "Heed not the rabble";
      case 2:
        return "Sound of screams but the";
      case 3:
        return "Who scream";
      case 4:
        return "Revolution is coming...";
      case 5:
        return "Revolution, they...";
      default:
        return "Default Text";
    }
  }
}
