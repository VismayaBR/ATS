import 'package:ats/constants/font.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerView extends StatefulWidget {
  String id;
  CustomerView({Key? key, required this.id});

  @override
  State<CustomerView> createState() => _CustomerViewState();
}

class _CustomerViewState extends State<CustomerView> {
  late Map<String, dynamic> customerData = {};
  late String imageUrl = '';

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  Future<void> fetchDataFromFirebase() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance.collection('customers').doc(widget.id).get();

      setState(() {
        customerData = documentSnapshot.data() ?? {};
      });
    } catch (e) {
      print('Error fetching data: $e');
      // Handle errors as needed
    }
  }

  Future<void> updateStatus() async {
    try {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('customers').doc(widget.id);

      await documentReference.update({'status': '1'});

      print('Status updated successfully!');
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  Future<void> updateStatus1() async {
    try {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('customers').doc(widget.id);

      await documentReference.update({'status': '2'});

      print('Status updated successfully!');
    } catch (e) {
      print('Error updating status: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(38.0),
              child: Container(
                width: double.infinity,
                color: Clr.clrlight,
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(CupertinoIcons.person, size: 50,),
                    ),
                    Text(customerData['username'], style: GoogleFonts.poppins(fontSize: 16),),
                    Text(customerData['email'] ?? '', style: GoogleFonts.poppins(fontSize: 16)),
                    Text(customerData['mobile'] ?? '', style: GoogleFonts.poppins(fontSize: 16)),
                    SizedBox(height: 40,)
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: Image.network(customerData['proof']),
            ),
            if (customerData['status'] == '0')
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 38, right: 38, bottom: 20, top: 10),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          updateStatus();
                        });
                        
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        child: Center(
                          child: Text('Accept', style: TextStyle(color: Colors.white, fontSize: 18),),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Clr.clrdark,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 38, right: 38, bottom: 10),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          updateStatus1();
                        });
                      },
                      child: Container(
                        height: 45,
                        width: double.infinity,
                        child: Center(
                          child: Text('Reject', style: TextStyle(color: Color.fromARGB(255, 15, 1, 58), fontSize: 18),),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Clr.clrdark),
                          borderRadius: BorderRadius.circular(10),
                          color: Clr.clrlight,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else if (customerData['status'] == '1')
              Padding(
                padding: const EdgeInsets.only(left: 38, right: 38, bottom: 20, top: 10),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: Center(
                    child: Text('Accepted', style: TextStyle(color: Colors.white, fontSize: 18),),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Clr.clrdark,
                  ),
                ),
              )
            else if (customerData['status'] == '2')
              Padding(
                padding: const EdgeInsets.only(left: 38, right: 38, bottom: 20, top: 10),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: Center(
                    child: Text('Rejected', style: TextStyle(color: Colors.white, fontSize: 18),),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Clr.clrdark,
                  ),
                ),
              ),
             
          ],
        ),
      ),
    );
  }
}

