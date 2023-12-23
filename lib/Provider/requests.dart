import 'package:ats/Provider/cab/cabrequestview.dart';
import 'package:ats/constants/font.dart';
import 'package:ats/customer/CustomerView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {

   @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  late List<DocumentSnapshot<Map<String, dynamic>>> reqData=[];


  Future<dynamic> fetchDataFromFirebase() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('cab_booking').get();

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
       body:  reqData == null
        ? Center(child: CircularProgressIndicator()) // Loading indicator
        : Column(

        children: [
          Text('Requests', style: GoogleFonts.poppins(
                  color: Clr.clrdark,
                  fontSize: 18,
                ),),
          Expanded(
            child: ListView.builder(
            itemCount: reqData.length,
            itemBuilder: (context, index) {
              var req = reqData[index].data();
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Clr.clrlight,
                    child: ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return CabRequestView(cus_id:req['cus_id'],cab_id:req['cab_id'],date:req['date'],time:req['time'],drop:req['drop'],pick:req['pick']);
                        }));
                      },
                      leading: Container(height: 80,width: 80,color: Clr.clrdark,),
                      title: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('date : '),
                                Text('Time : '),
                                Text('Pick up  : '),
                                Text('Drop off : ')
                                 
                              ],
                            ),
                             Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(req!['date']),
                                Text(req!['time']),
                                Text(req!['pick']),
                                Text(req!['drop'])
                                 
                              ],
                            ),
                          ],
                        ),
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