import 'package:ats/constants/font.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// ... Import statements ...

// ... Import statements ...

class CustomerView extends StatefulWidget {
  final String id;

  CustomerView({Key? key, required this.id});

  @override
  State<CustomerView> createState() => _CustomerViewState();
}

class _CustomerViewState extends State<CustomerView> {
  late Map<String, dynamic> customerData = {};
  late String imageUrl = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  Future<void> fetchDataFromFirebase() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance.collection('customers').doc(widget.id).get();

      setState(() {
        customerData = documentSnapshot.data() ?? {};
        isLoading = false; // Set loading to false when data is fetched
      });
    } catch (e) {
      print('Error fetching data: $e');
      // Handle errors as needed
    }
  }

Future<void> updateStatus(String status) async {
  try {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('customers').doc(widget.id);

    await documentReference.update({'status': status});

    // Refresh UI by fetching data again
    await fetchDataFromFirebase();

    print('Status updated successfully!');
  } catch (e) {
    print('Error updating status: $e');
  }
}

Future<void> updateStatus1() async {
  try {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('customers').doc(widget.id);

    await documentReference.update({'status': '2'});

    // Refresh UI by fetching data again
    await fetchDataFromFirebase();

    print('Status updated successfully!');
  } catch (e) {
    print('Error updating status: $e');
  }
}

  Widget buildCustomerDetails() {
    return Padding(
      padding: const EdgeInsets.all(38.0),
      child: Container(
        width: double.infinity,
        color: Clr.clrlight,
        child: Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(CupertinoIcons.person, size: 50),
            ),
            Text(customerData['username'] ?? '', style: GoogleFonts.poppins(fontSize: 16)),
            Text(customerData['email'] ?? '', style: GoogleFonts.poppins(fontSize: 16)),
            Text(customerData['mobile'] ?? '', style: GoogleFonts.poppins(fontSize: 16)),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget buildImage() {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          Image.network(
            customerData['proof'] ?? '',
            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
              return Center(
                child: CircularProgressIndicator()
              );
            },
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget buildStatusButtons() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (customerData['status'] == '0') {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 38, right: 38, bottom: 20, top: 10),
            child: InkWell(
              onTap: () {
                setState(() {
                  updateStatus('1'); // Accept
                });
              },
              child: Container(
                height: 50,
                width: double.infinity,
                child: Center(
                  child: Text('Accept', style: TextStyle(color: Colors.white, fontSize: 18)),
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
                  updateStatus('2'); // Reject
                });
              },
              child: Container(
                height: 45,
                width: double.infinity,
                child: Center(
                  child: Text('Reject', style: TextStyle(color: Color.fromARGB(255, 15, 1, 58), fontSize: 18)),
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
      );
    } else if (customerData['status'] == '1') {
      return Padding(
        padding: const EdgeInsets.only(left: 38, right: 38, bottom: 20, top: 10),
        child: Container(
          height: 50,
          width: double.infinity,
          child: Center(
            child: Text('Accepted', style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Clr.clrdark,
          ),
        ),
      );
    } else if (customerData['status'] == '2') {
      return Padding(
        padding: const EdgeInsets.only(left: 38, right: 38, bottom: 20, top: 10),
        child: Container(
          height: 50,
          width: double.infinity,
          child: Center(
            child: Text('Rejected', style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Clr.clrdark,
          ),
        ),
      );
    }

    return Container(); // Default case, return an empty container
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildCustomerDetails(),
            buildImage(),
            buildStatusButtons(),
          ],
        ),
      ),
    );
  }
}
