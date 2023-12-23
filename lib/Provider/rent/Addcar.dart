import 'package:ats/constants/font.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddCar extends StatefulWidget {
  const AddCar({super.key});

  @override
  State<AddCar> createState() => _AddCarState();
}

class _AddCarState extends State<AddCar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              'Add your Car',
              style: GoogleFonts.poppins(
                color: Clr.clrdark,
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload_file),
                  Text('Upload Image of vehicle'),
                ],
              ),
              height: 100,
              width: double.infinity,
              color: Clr.clrlight,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload_file),
                  Text('Upload RC'),
                ],
              ),
              height: 100,
              width: double.infinity,
              color: Clr.clrlight,
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Text('Name'),
              ],
            ),
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
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text('Seat'),
              ],
            ),
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
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text('Price per day'),
              ],
            ),
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
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text('Description'),
              ],
            ),
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
            SizedBox(
              height: 30,
            ),
            Container(
              child: Center(
                  child: Text(
                'ADD',
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
          ],
        ),
      ),
    );
  }
}
