import 'package:ats/constants/font.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProviderView extends StatefulWidget {
  String id;
   ProviderView({super.key, required this.id});

  @override
  State<ProviderView> createState() => _ProviderViewState();
}


class _ProviderViewState extends State<ProviderView> {
  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

    late Map<String, dynamic> providerData = {};


   Future<void> fetchDataFromFirebase() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance.collection('providers').doc(widget.id).get();

      setState(() {
        providerData = documentSnapshot.data() ?? {};
      });
    } catch (e) {
      print('Error fetching data: $e');
      // Handle errors as needed
    }
  }
  
   Future<void> updateStatus() async {
    try {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('providers').doc(widget.id);

      await documentReference.update({'status': '1'});

      print('Status updated successfully!');
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  Future<void> updateStatus1() async {
    try {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('providers').doc(widget.id);

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
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                     SizedBox(height: 20,),
                  
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(CupertinoIcons.person,size: 50,),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Name :'),
                          Text(providerData['name']?? '',style: GoogleFonts.poppins(fontSize: 16),),
                        ],
                      ),
                      Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Text('Email :'),
                          Text(providerData['email']?? '',style: GoogleFonts.poppins(fontSize: 16)),
                        ],
                      ),
                      Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Text('Mobile :'),
                          Text(providerData['mobile']?? '',style: GoogleFonts.poppins(fontSize: 16)),
                        ],
                      ),
                      Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Text('District :'),
                          Text(providerData['district']?? '',style: GoogleFonts.poppins(fontSize: 16),),
                        ],
                      ),
                      Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Text('Pincode :'),
                          Text(providerData['pincode']?? '',style: GoogleFonts.poppins(fontSize: 16)),
                        ],
                      ),
                      Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Text('Category :'),
                          Text(providerData['category']?? '',style: GoogleFonts.poppins(fontSize: 16)),
                        ],
                      ),
                  
                      SizedBox(height: 40,)
                    ],
                  ),
                ),
              ),
            ),
           
            SizedBox(
              height: 150,width: double.infinity,
              child: Image.network(providerData['image']??"")),
              SizedBox(height: 10,),
            if (providerData['status'] == '0')
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
            else if (providerData['status'] == '1')
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
            else if (providerData['status'] == '2')
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
        ]),
      ),
    );
  }
}