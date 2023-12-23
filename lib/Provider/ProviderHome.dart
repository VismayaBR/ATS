import 'package:ats/Provider/cab/addcab.dart';
import 'package:ats/Provider/cab/addedcabvie.dart';
import 'package:ats/constants/font.dart';
import 'package:ats/customer/CustomerView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProHome extends StatefulWidget {
  const ProHome({super.key});

  @override
  State<ProHome> createState() => _ProHomeState();
}

class _ProHomeState extends State<ProHome> {

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
          await FirebaseFirestore.instance.collection('cabs')
          .where('pro_id',isEqualTo: id)
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
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     Icon(Icons.settings_power_sharp),
            //   ],
            // ),
          SizedBox(height: 10,),
          Text('Added Cabs', style: GoogleFonts.poppins(
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
                      title: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(cab!['name']),
                        ),
                      ),
                      subtitle: Text('Seats :${cab['seat']}'),
                    ),
                  ),
                );
              }),
          ),
        ],
      ),
    floatingActionButton: FloatingActionButton(onPressed: (){
      Navigator.push(context, MaterialPageRoute(builder: (ctx){
        return AddCab();
      }));
    },child: Icon(Icons.add,color: Clr.clrlight,),backgroundColor: Clr.clrdark,),
    );
    
  }
}