import 'package:ats/constants/font.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'package:shared_preferences/shared_preferences.dart';

class Requests1 extends StatefulWidget {
  const Requests1({Key? key}) : super(key: key);

  @override
  State<Requests1> createState() => _Requests1State();
}

class _Requests1State extends State<Requests1> {
  late List<DocumentSnapshot<Map<String, dynamic>>> reqData = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  Future<void> fetchDataFromFirebase() async {
    try {
      SharedPreferences spref = await SharedPreferences.getInstance();
      var id = spref.getString('user_id');
      print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$id');
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('bike_booking').where('pro_id', isEqualTo: id).get();

      setState(() {
        reqData = querySnapshot.docs;
      });
    } catch (e) {
      print('Error fetching data: $e');
      // Provide user feedback or handle errors as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: reqData.isEmpty
          ? Center(child: CircularProgressIndicator()) // Loading indicator
          : Column(
              children: [
                Text(
                  'Requests',
                  style: GoogleFonts.poppins(
                    color: Clr.clrdark,
                    fontSize: 18,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: reqData.length,
                    itemBuilder: (context, index) {
                      return buildRequestCard(reqData[index]);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildRequestCard(DocumentSnapshot<Map<String, dynamic>> document) {
    var req = document.data();
    Timestamp timestamp = req!['timestamp'];
    DateTime dateTime = timestamp.toDate();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Clr.clrlight,
        child: ListTile(
          onTap: () {
            // Provide navigation logic if needed
          },
          title: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date: $formattedDate'), // Display formatted date
                    Text('Pick up  : ${req['pick']}'),
                    // Add more fields as needed
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

