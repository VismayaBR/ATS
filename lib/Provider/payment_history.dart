import 'package:ats/constants/font.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Payment_history extends StatefulWidget {
  const Payment_history({super.key});

  @override
  State<Payment_history> createState() => _Payment_historyState();
}

class _Payment_historyState extends State<Payment_history> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Payment History',style: GoogleFonts.poppins(fontSize: 20),),
          Expanded(
            child: ListView.builder(itemBuilder: (context, index) {
              return Card(
                color: Clr.clrlight,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.black,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Customer'),
                        Text('Vehicle'),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Amount'),
                        Text('Date'),
                      ],
                    ),
                    
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
