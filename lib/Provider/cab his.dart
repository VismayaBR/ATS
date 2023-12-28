import 'package:ats/constants/font.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CabPaymentHistory extends StatefulWidget {
  const CabPaymentHistory({super.key});

  @override
  State<CabPaymentHistory> createState() => _CabPaymentHistoryState();
}

class _CabPaymentHistoryState extends State<CabPaymentHistory> {
  late List<DocumentSnapshot<Map<String, dynamic>>> reqData = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  Future<dynamic> fetchDataFromFirebase() async {
    try {
      SharedPreferences spref = await SharedPreferences.getInstance();
      var id = spref.getString('user_id');
      print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$id');
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('cab_booking')
              .where('pro_id', isEqualTo: id)
              .get();

      setState(() {
        reqData = querySnapshot.docs;
      });
      return reqData;
    } catch (e) {
      print('Error fetching data: $e');
      // Handle errors as needed
    }
  }

  Future<String> getCustomerName(String customerId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> customerSnapshot =
          await FirebaseFirestore.instance
              .collection('customers')
              .doc(customerId)
              .get();

      var customerData = customerSnapshot.data();
      return customerData?['username'] ?? 'Unknown Customer';
    } catch (e) {
      print('Error fetching customer name: $e');
      return 'Unknown Customer';
    }
  }

  Future<String> getCabName(String cabId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> cabSnapshot =
          await FirebaseFirestore.instance.collection('cabs').doc(cabId).get();

      var cabData = cabSnapshot.data();
      return cabData?['name'] ?? 'Unknown Cab';
    } catch (e) {
      print('Error fetching cab name: $e');
      return 'Unknown Cab';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Payment History', style: GoogleFonts.poppins(fontSize: 20)),
          Expanded(
            child: ListView.builder(
              itemCount: reqData.length,
              itemBuilder: (context, index) {
                var req = reqData[index].data();
                return FutureBuilder(
                  future: Future.wait([
                    getCustomerName(req!['cus_id']),
                    getCabName(req!['cab_id']),
                  ]),
                  builder: (context, AsyncSnapshot<List<String>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    }
                     else if (snapshot.hasError) {
                      return Text('Error loading data');
                    } 
                    else {
                      var customerName = snapshot.data?[0] ?? 'Unknown Customer';
                      var cabName = snapshot.data?[1] ?? 'Unknown Cab';

                      return Card(
                        color: Clr.clrlight,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: ListTile(
                            onTap: () {
                              // Add navigation logic here
                              // Navigator.push(...);
                            },
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text('Customer ID: ${req!['cus_id']}'),
                                Text('Customer Name: $customerName'),
                                // Text('Cab ID: ${req!['cab_id']}'),
                                Text('Cab : $cabName'),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Rs 250',
                                    style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)),
                                Text('Advance amount is paid',
                                    style: TextStyle(color: Colors.green)),
                                Text('Pickup Location: ${req['pick']}'),
                                // Text('${req['days']} Days For rent'),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
