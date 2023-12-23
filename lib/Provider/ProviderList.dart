import 'package:ats/Admin/Homerental.dart';
import 'package:ats/Admin/navbar.dart';
import 'package:ats/Provider/ProviderView.dart';
import 'package:ats/Provider/rent/rentallist.dart';
import 'package:ats/constants/font.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProviderList extends StatefulWidget {
  const ProviderList({super.key});

  @override
  State<ProviderList> createState() => _ProviderListState();
}

class _ProviderListState extends State<ProviderList> {

    late List<DocumentSnapshot<Map<String, dynamic>>> providerData=[];

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  Future<dynamic> fetchDataFromFirebase() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('providers').get();

      setState(() {
        providerData = querySnapshot.docs;
        
      });
            return providerData;

    } 
    
    catch (e) {
      print('Error fetching data: $e');
      // Handle errors as needed
    }
  }
  
  @override
  Widget build(BuildContext context) {
     return Scaffold(
    body: providerData == null
        ? Center(child: CircularProgressIndicator()) // Loading indicator
        : ListView.builder(
            itemCount: providerData.length,
            itemBuilder: (context, index) {
              var provider = providerData[index].data();

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Clr.clrlight,
                  child: ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (ctx){
                        return ProviderView(id: providerData[index].id);
                      }));
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://t4.ftcdn.net/jpg/04/83/90/95/360_F_483909569_OI4LKNeFgHwvvVju60fejLd9gj43dIcd.jpg'),
                    ),
                    title: Text(provider!['name'] ?? 'Name'),
                    subtitle: Text(provider['email'] ?? 'Subtitle'),
                    trailing:  Text(provider['category'] ?? 'Subtitle'),
                  ),
                ),
              );
            },
          ),
  );
  }
}
