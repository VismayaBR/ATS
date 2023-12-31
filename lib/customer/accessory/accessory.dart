import 'package:ats/Admin/ad_view_acc.dart';
import 'package:ats/Admin/add_acc.dart';
import 'package:ats/constants/font.dart';
import 'package:ats/customer/accessory/aac_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Acc1 extends StatefulWidget {
  const Acc1({super.key});

  @override
  State<Acc1> createState() => _Acc1State();
}

class _Acc1State extends State<Acc1> {
  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  late List<DocumentSnapshot<Map<String, dynamic>>> accessories = [];

  Future<dynamic> fetchDataFromFirebase() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('accessories').get();

      setState(() {
        accessories = querySnapshot.docs;
      });
      return accessories;
    } catch (e) {
      print('Error fetching data: $e');
      // Handle errors as needed
    }
  }

  Future<void> deleteAccessory(String accessoryId) async {
    try {
      await FirebaseFirestore.instance
          .collection('accessories')
          .doc(accessoryId)
          .delete();
    } catch (e) {
      print('Error deleting accessory: $e');
      // Handle errors as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: accessories == null
          ? Center(child: CircularProgressIndicator()) // Loading indicator
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: accessories.length,
                      itemBuilder: (context, index) {
                        var accessory = accessories[index].data();
                        return Card(
                           color: Clr.clrlight,
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                           
                          child: ListTile(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx){
                                return AccView(id:accessories[index].id,name:accessory['name'],price: accessory['price'],desc:accessory['desc'],img:accessory['image']);
                              }));
                            },
                            title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(accessory!['name'] ?? 'Name',style: GoogleFonts.poppins(fontSize: 17,fontWeight: FontWeight.bold),),
                                   
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 150,width: 150,
                                      child: Image.network(accessory!['image'])),
                                      SizedBox(height: 20,),
                                    Text('Rs. ${accessory!['price']}' ?? 'Price',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                   SizedBox(height: 10,),
                                    Text('${accessory!['desc']}' ?? 'Price'),
                                  ],
                                ),
                          )
                          ),
                        );
                        
                      }),
                ),
              ],
            ),
      
    );
  }
}
