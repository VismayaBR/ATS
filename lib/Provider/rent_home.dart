import 'package:ats/Provider/cab/addcab.dart';
import 'package:ats/Provider/cab/addedcabvie.dart';
import 'package:ats/Provider/cab/addrent.dart';
import 'package:ats/constants/font.dart';
import 'package:ats/customer/CustomerView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProHome1 extends StatefulWidget {
  const ProHome1({super.key});

  @override
  State<ProHome1> createState() => _ProHome1State();
}

class _ProHome1State extends State<ProHome1> {

  late List<DocumentSnapshot<Map<String, dynamic>>> cabData=[];

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  Future<dynamic> fetchDataFromFirebase() async {
    try {
       SharedPreferences spref = await SharedPreferences.getInstance();
        var id = spref.getString('user_id');
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('rent')
          .where('category',isEqualTo: 'Bike')
          // .where('pro_id',isEqualTo: id)
          .get();

      setState(() {
        cabData = querySnapshot.docs;
        
      });
            return cabData;

    } 
    
    catch (e) {
      print('Error fetching data: $e');
      // Handle errors as needed
    }
  }


  @override
  Widget build(BuildContext context) {
    return 
       Scaffold(
      body: Column(

        children: [
          SizedBox(height: 50,),
          Text('Added Vehicles', style: GoogleFonts.poppins(
                  color: Clr.clrdark,
                  fontSize: 18,
                ),),
          Expanded(
            child:cabData == null
        ? Center(child: CircularProgressIndicator()) // Loading indicator
        :ListView.builder(
             itemCount: cabData.length,
            itemBuilder: (context, index) {
              var cab = cabData[index].data();
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Clr.clrlight,
                    child: ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return CabRequestView1(id: cabData[index].id);
                        }));
                      },
                      leading: Container(height: 80,width: 80,child: Image.network(cab!['v_image']),),
                      title: Text(cab!['name']),
                      subtitle: Text('Price per hour :${cab['price']}'),
                    ),
                  ),
                );
              }),
          ),
        ],
      ),
    floatingActionButton: FloatingActionButton(onPressed: (){
      Navigator.push(context, MaterialPageRoute(builder: (ctx){
        return AddRent();
      }));
    },child: Icon(Icons.add,color: Clr.clrlight,),backgroundColor: Clr.clrdark,),
    );
    
  }
}