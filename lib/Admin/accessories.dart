import 'package:ats/Admin/ad_view_acc.dart';
import 'package:ats/Admin/add_acc.dart';
import 'package:ats/constants/font.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Acc extends StatefulWidget {
  const Acc({super.key});

  @override
  State<Acc> createState() => _AccState();
}

class _AccState extends State<Acc> {
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
      appBar: AppBar(),
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
                          color: const Color.fromARGB(255, 255, 255, 255),
                          child: Padding(
                            padding: const EdgeInsets.only(top:18.0,left: 18,right: 0,bottom: 18),
                            child: ListTile(
                              // onTap: () {
                              //   Navigator.push(context,
                              //       MaterialPageRoute(builder: (ctx) {
                              //     return AccView1(id: accessories[index].id);
                              //   }));
                              // },
                              // leading: CircleAvatar(
                              //   backgroundImage:
                              //       NetworkImage(accessory!['image']),
                              // ),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(accessory!['name'] ?? 'Name',style: GoogleFonts.poppins(fontSize: 17,fontWeight: FontWeight.bold),),
                                  IconButton(
                                icon: Icon(Icons.delete,size: 18,),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Confirm Deletion'),
                                        content: Text(
                                            'Are you sure you want to delete this accessory?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                  context); // Close the dialog
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.pop(
                                                  context); // Close the dialog

                                              try {
                                                final accessoryId =
                                                    accessories[index].id;
                                                await deleteAccessory(
                                                    accessoryId);
                                                setState(() {
                                                  // Remove the deleted accessory from the local list
                                                  accessories.removeAt(index);
                                                });
                                              } catch (e) {
                                                print(
                                                    'Error deleting accessory: $e');
                                                // Handle errors as needed
                                              }
                                            },
                                            child: Text('Delete'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
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
                              // trailing: IconButton(
                              //   icon: Icon(Icons.delete),
                              //   onPressed: () {
                              //     showDialog(
                              //       context: context,
                              //       builder: (BuildContext context) {
                              //         return AlertDialog(
                              //           title: Text('Confirm Deletion'),
                              //           content: Text(
                              //               'Are you sure you want to delete this accessory?'),
                              //           actions: [
                              //             TextButton(
                              //               onPressed: () {
                              //                 Navigator.pop(
                              //                     context); // Close the dialog
                              //               },
                              //               child: Text('Cancel'),
                              //             ),
                              //             TextButton(
                              //               onPressed: () async {
                              //                 Navigator.pop(
                              //                     context); // Close the dialog

                              //                 try {
                              //                   final accessoryId =
                              //                       accessories[index].id;
                              //                   await deleteAccessory(
                              //                       accessoryId);
                              //                   setState(() {
                              //                     // Remove the deleted accessory from the local list
                              //                     accessories.removeAt(index);
                              //                   });
                              //                 } catch (e) {
                              //                   print(
                              //                       'Error deleting accessory: $e');
                              //                   // Handle errors as needed
                              //                 }
                              //               },
                              //               child: Text('Delete'),
                              //             ),
                              //           ],
                              //         );
                              //       },
                              //     );
                              //   },
                              // ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddAcc();
          }));
        },
        child: Icon(
          Icons.add,
          color: Clr.clrlight,
        ),
        backgroundColor: Clr.clrdark,
      ),
    );
  }
}
