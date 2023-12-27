import 'package:ats/Provider/bikepayment.dart';
import 'package:ats/Provider/payment_history.dart';
import 'package:ats/constants/font.dart';
import 'package:ats/customer/rent/bikelist.dart';
import 'package:ats/customer/rent/carlist.dart';
import 'package:flutter/material.dart';

class RentalVehicleTab extends StatefulWidget {
  const RentalVehicleTab({Key? key}) : super(key: key);

  @override
  State<RentalVehicleTab> createState() => _RentalVehicleTabState();
}

class _RentalVehicleTabState extends State<RentalVehicleTab> {



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          automaticallyImplyLeading: false,
          title: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Clr.clrdark, // Change this to your desired background color
                ),
                
                width: 250,
                child: const TabBar(
                  indicatorColor: Color.fromARGB(255, 255, 255, 255), // Change this to your desired selected indicator color
                  labelColor: Color.fromARGB(255, 255, 255, 255), // Change this to your desired selected text color
                  unselectedLabelColor: Color.fromARGB(255, 185, 185, 185), // Change this to your desired unselected text color
                  tabs: [
                    Tab(text: 'Car'),
                    Tab(text: 'Bike'),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            PaymentHistory(),
            PaymentHistory1(),
          ],
        ),
      ),
    );
  }
}
