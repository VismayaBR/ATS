import 'package:ats/constants/font.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Payment_history1 extends StatefulWidget {
  const Payment_history1({super.key});

  @override
  State<Payment_history1> createState() => _Payment_history1State();
}

class _Payment_history1State extends State<Payment_history1> {

   @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  late List<DocumentSnapshot<Map<String, dynamic>>> reqData=[];


  Future<dynamic> fetchDataFromFirebase() async {
    try {
       SharedPreferences spref = await SharedPreferences.getInstance();
        var id = spref.getString('user_id');
        print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$id');
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('bike_booking')
          .where('pro_id',isEqualTo: id)
          .get();

      setState(() {
        reqData = querySnapshot.docs;
        
      });
            return reqData;

    } 
    
    catch (e) {
      print('Error fetching data: $e');
      // Handle errors as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Payment History',style: GoogleFonts.poppins(fontSize: 20),),
          Expanded(
            child: ListView.builder(
            itemCount: reqData.length,
            itemBuilder: (context, index) {
              var req = reqData[index].data();
              return Card(
                color: Clr.clrlight,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: ListTile(
                  
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(req!['cus_id']),
                        Text(req!['car_id']),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Advance amount is payed',style: TextStyle(color: Colors.green),),
                        Text(req['pick']),
                         Text('${req['days']} Days For rent'),
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