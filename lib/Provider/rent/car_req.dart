import 'package:ats/Provider/rent/carreqview.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ats/constants/font.dart';

class Requests2 extends StatefulWidget {
  const Requests2({Key? key}) : super(key: key);

  @override
  State<Requests2> createState() => _Requests2State();
}

class _Requests2State extends State<Requests2> {
  List<DocumentSnapshot<Map<String, dynamic>>> reqData = [];

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
          await FirebaseFirestore.instance
              .collection('car_booking')
              .where('pro_id', isEqualTo: id)
              .get();

      setState(() {
        reqData = querySnapshot.docs;
      });
    } catch (e) {
      print('Error fetching data: $e');
      // Handle errors gracefully, e.g., show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: reqData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : RequestList(reqData: reqData),
    );
  }
}

class RequestList extends StatelessWidget {
  final List<DocumentSnapshot<Map<String, dynamic>>> reqData;

  const RequestList({required this.reqData});

  @override
  Widget build(BuildContext context) {
    return Column(
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
              return RequestCard(document: reqData[index]);
            },
          ),
        ),
      ],
    );
  }
}

class RequestCard extends StatelessWidget {
  final DocumentSnapshot<Map<String, dynamic>> document;

  const RequestCard({required this.document});

  @override
  Widget build(BuildContext context) {
    var req = document.data();
    // Timestamp timestamp = req!['timestamp'];
    // DateTime dateTime = timestamp.toDate();
    // String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Clr.clrlight,
        child: ListTile(
         onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (ctx) {
              return CarReqView(
                  id: document.id,
                  cus_id: req['cus_id'],
                  pick: req['pick'],
                  drop: req['drop'],
                  car_id: req['car_id']);
            }));
          },
          title: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pick up: ${req!['pick']}'), // Display formatted date
                    Text('Drop off  : ${req['drop']}'),
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
