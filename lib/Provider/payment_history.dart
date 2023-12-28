import 'package:ats/constants/font.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({Key? key}) : super(key: key);

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  late List<QueryDocumentSnapshot<Map<String, dynamic>>> reqData = [];
  late Map<String, dynamic> customerData = {};
  late Map<String, dynamic> carData = {};

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
      // Handle errors as needed
    }
  }

  Future<void> fetchCustomerName(String cusId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection('customers')
              .doc(cusId)
              .get();

      setState(() {
        customerData = documentSnapshot.data() ?? {};
      });
    } catch (e) {
      print('Error fetching customer data: $e');
      // Handle errors as needed
    }
  }

  Future<void> fetchCarName(String carId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance.collection('rent').doc(carId).get();

      setState(() {
        carData = documentSnapshot.data() ?? {};
      });
    } catch (e) {
      print('Error fetching car data: $e');
      // Handle errors as needed
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
                var cusId = req?['cus_id'] ?? '';
                var carId = req?['car_id'] ?? '';

                fetchCustomerName(cusId); // Fetch customer name based on cusId
                fetchCarName(carId); // Fetch car name based on carId

                return Card(
                  color: Clr.clrlight,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(customerData['username'] ?? 'Unknown Customer'),
                          // Text(carData['name'] ?? 'Unknown Car'),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Advance amount is paid',
                                  style: TextStyle(color: Colors.green)),
                              Text('Rs. ${req['amount']}' ?? ''),
                            ],
                          ),
                          Text(req?['pick'] ?? 'Unknown Pickup Location'),
                          Text('${req?['days'] ?? 'Unknown'} Days For Rent'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
