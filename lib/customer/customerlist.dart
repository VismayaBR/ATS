import 'package:ats/constants/font.dart';
import 'package:ats/customer/CustomerView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({Key? key}) : super(key: key);

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  late List<DocumentSnapshot<Map<String, dynamic>>> customerData=[];

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  Future<dynamic> fetchDataFromFirebase() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('customers').get();

      setState(() {
        customerData = querySnapshot.docs;
        
      });
            return customerData;

    } 
    
    catch (e) {
      print('Error fetching data: $e');
      // Handle errors as needed
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: customerData == null
        ? Center(child: CircularProgressIndicator()) // Loading indicator
        : ListView.builder(
            itemCount: customerData.length,
            itemBuilder: (context, index) {
              var customer = customerData[index].data();

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Clr.clrlight,
                  child: ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (ctx){
                        return CustomerView(id: customerData[index].id);
                      }));
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://t4.ftcdn.net/jpg/04/83/90/95/360_F_483909569_OI4LKNeFgHwvvVju60fejLd9gj43dIcd.jpg'),
                    ),
                    title: Text(customer!['username'] ?? 'Name'),
                    subtitle: Text(customer['email'] ?? 'Subtitle'),
                  ),
                ),
              );
            },
          ),
  );
}

}
