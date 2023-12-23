import 'package:ats/Provider/ProviderList.dart';
import 'package:ats/constants/font.dart';
import 'package:ats/customer/customerlist.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                    Tab(text: 'Customer'),
                    Tab(text: 'Provider'),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            CustomerList(),
            ProviderList(),
          ],
        ),
      ),
    );
  }
}
