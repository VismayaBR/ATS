import 'package:ats/Provider/cab/addcab.dart';
import 'package:ats/Provider/cab/addedcabvie.dart';
import 'package:ats/Provider/cab/addrent.dart';
import 'package:ats/Provider/rent/pro_bike_view.dart';
import 'package:ats/Provider/rent/pro_car_view.dart';
import 'package:ats/constants/font.dart';
import 'package:ats/customer/CustomerView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProHome1 extends StatefulWidget {
  const ProHome1({super.key});

  @override
  State<ProHome1> createState() => _ProHome1State();
}

class _ProHome1State extends State<ProHome1> {

  late List<DocumentSnapshot<Map<String, dynamic>>> rentData=[];

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  Future<dynamic> fetchDataFromFirebase() async {
    try {
       SharedPreferences spref = await SharedPreferences.getInstance();
        var id = spref.getString('user_id');
        print(id);
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('rent')
          // .where('category',isEqualTo: 'Bike')
          .where('pro_id',isEqualTo: id)
          .get();

      setState(() {
        rentData = querySnapshot.docs;
        
      });
            return rentData;

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
          
         
          SizedBox(height: 20,),
          Text('Added Vehicles', style: GoogleFonts.poppins(
                  color: Clr.clrdark,
                  fontSize: 18,
                ),),
          Expanded(
            child:rentData == null
        ? Center(child: CircularProgressIndicator()) // Loading indicator
        :ListView.builder(
             itemCount: rentData.length,
            itemBuilder: (context, index) {
              var cab = rentData[index].data();
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Clr.clrlight,
                    child: ListTile(
                      onTap: (){
                        if(cab['category']=='Car'){
                           Navigator.push(context, MaterialPageRoute(builder: (context){
                          return CarViewPro(id: rentData[index].id);
                        }));
                        }
                        if(cab['category']=='Bike'){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                          return BikeViewPro(id: rentData[index].id);
                        }));
                        }
                       
                      },
                      leading: Container(height: 80,width: 80,child: Image.network(cab!['v_image']),),
                      title: Text(cab!['name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Price per hour :${cab['price']}'),
                          
                        ],
                      ),
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