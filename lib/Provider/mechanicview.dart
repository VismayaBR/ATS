
import 'package:ats/Provider/addtech.dart';
import 'package:ats/constants/font.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Mech extends StatefulWidget {
  const Mech({super.key});

  @override
  State<Mech> createState() => _MechState();
}

class _MechState extends State<Mech> {
   late List<DocumentSnapshot<Map<String, dynamic>>> mechData=[];

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  Future<dynamic> fetchDataFromFirebase() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('mechanics').get();

      setState(() {
        mechData = querySnapshot.docs;
        
      });
            return mechData;

    } 
    
    catch (e) {
      print('Error fetching data: $e');
      // Handle errors as needed
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          Expanded(
            child: mechData == null
        ? Center(child: CircularProgressIndicator()) // Loading indicator
        : ListView.builder(
           itemCount: mechData.length,
            itemBuilder: (context, index) {
              var mech = mechData[index].data();
              return Card(
                color: Clr.clrlight,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: ListTile(
                    leading: CircleAvatar(backgroundColor: Colors.black,),
                    title: Text(mech!['name']),
                    subtitle: Text(mech['mobile']),
                    trailing: IconButton(onPressed: (){},icon: Icon(Icons.phone),),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (ctx){
          return AddTech();
        }));
      },child: Icon(Icons.add,color: Clr.clrlight,),backgroundColor: Clr.clrdark,),
         );
         
  }
}