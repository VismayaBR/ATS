import 'package:ats/constants/font.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  late List<Map<String, dynamic>> accessories = [];
  String cusId = "";

  Future<void> fetchDataFromFirebase() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('acc_booking').get();

      List<Map<String, dynamic>> fetchedAccessories = [];

      await Future.wait(querySnapshot.docs.map((document) async {
        String accId = document['acc_id'];
        setState(() {
          cusId = document['cus_id'];
        });

        print('.................................................$cusId');
        Map<String, dynamic> accBookingData = await fetchAccBookingData(accId);
        Map<String, dynamic> accessoriesData =
            await fetchAccessoriesData(accId);
        Map<String, dynamic> accessoriesDataUser =
            await fetchAccBookingDataUser(cusId);

        // Combine data from both collections
        Map<String, dynamic> combinedData = {
          'acc_id': accId,
          'acc_booking_data': accBookingData,
          'accessories_data': accessoriesData,
          'customer_data': accessoriesDataUser,
          'quantity': document['quandity'],
          'address': document['address'],
          // Add other fields as needed
        };

        fetchedAccessories.add(combinedData);
      }));

      setState(() {
        accessories = fetchedAccessories;
      });
    } catch (e) {
      print('Error fetching data: $e');
      // Handle errors as needed
    }
  }

  Future<Map<String, dynamic>> fetchAccBookingData(String accId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> accBookingSnapshot =
          await FirebaseFirestore.instance
              .collection('acc_booking')
              .doc(accId)
              .get();

      return accBookingSnapshot.data() ?? {};
    } catch (e) {
      print('Error fetching acc_booking data: $e');
      return {}; // Handle the case where data couldn't be fetched
    }
  }

  Future<Map<String, dynamic>> fetchAccBookingDataUser(String cusId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> accBookingUserSnapshot =
          await FirebaseFirestore.instance
              .collection('customers')
              .doc(cusId)
              .get();

      return accBookingUserSnapshot.data() ?? {};
    } catch (e) {
      print('Error fetching acc_booking data: $e');
      return {}; // Handle the case where data couldn't be fetched
    }
  }

  Future<Map<String, dynamic>> fetchAccessoriesData(String accId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> accessoriesSnapshot =
          await FirebaseFirestore.instance
              .collection('accessories')
              .doc(accId)
              .get();

      return accessoriesSnapshot.data() ?? {};
    } catch (e) {
      print('Error fetching accessories data: $e');
      return {}; // Handle the case where data couldn't be fetched
    }
  }

  Future<Map<String, dynamic>> getCustomer(String cusId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> customersSnapshot =
          await FirebaseFirestore.instance
              .collection('customers')
              .doc(cusId)
              .get();
      var cus = customersSnapshot.data() ?? {};
      print(cus);
      return cus;
    } catch (e) {
      print('Error fetching customer data: $e');
      return {}; // Handle the case where data couldn't be fetched
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payments'),
      ),
      body: accessories.isEmpty
          ? Center(child: CircularProgressIndicator()) // Loading indicator
          : ListView.builder(
              itemCount: accessories.length,
              itemBuilder: (context, index) {
                var accessory = accessories[index];
                return Card(
                  color: Clr.clrlight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18,bottom: 18,),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return FutureBuilder<Map<String, dynamic>>(
                              future: getCustomer(cusId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return AlertDialog(
                                    title: Text('Customet details'),
                                    content: Text('Loading...'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Ok'),
                                      ),
                                    ],
                                  );
                                } else if (snapshot.hasError) {
                                  return AlertDialog(
                                    title: Text('Error'),
                                    content: Text('Error fetching data'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Ok'),
                                      ),
                                    ],
                                  );
                                } else {
                                  return AlertDialog(
                                    title: Text('Customer details'),
                                    content: SizedBox(
                                      height: 80,
                                      child: Column(
                                        children: [
                                          Text(snapshot.data!['username']),
                                           Text(snapshot.data!['email']),
                                            Text(snapshot.data!['mobile']),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                }
                              },
                            );
                          },
                        );
                      },
                      child: ListTile(
                        leading: CircleAvatar(backgroundImage: NetworkImage(accessory['accessories_data']['image']),),
                        title: Text(accessory['accessories_data']['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Price:'),
                                    Text('Quantity:'),
                                    Text('Address:'),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                        '${accessory['accessories_data']['price'] ?? 0}'),
                                    Text('${accessory['quantity']}'),
                                    SizedBox(
                                      width: 100,
                                      child: Text('${accessory['address']}')),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
