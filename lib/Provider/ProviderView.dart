import 'package:ats/constants/font.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProviderView extends StatefulWidget {
  final String id;

  ProviderView({required this.id});

  @override
  State<ProviderView> createState() => _ProviderViewState();
}

class _ProviderViewState extends State<ProviderView> {
  late Map<String, dynamic> providerData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  Future<void> fetchDataFromFirebase() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance.collection('providers').doc(widget.id).get();

      setState(() {
        providerData = documentSnapshot.data() ?? {};
        isLoading = false; // Set loading to false when data is fetched
      });
    } catch (e) {
      print('Error fetching data: $e');
      // Handle errors as needed
    }
  }

  Future<void> updateStatusAndRefresh(String status) async {
    try {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('providers').doc(widget.id);

      await documentReference.update({'status': status});

      print('Status updated successfully!');
      fetchDataFromFirebase(); // Refresh data after updating status
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(38.0),
              child: Container(
                width: double.infinity,
                color: Clr.clrlight,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(CupertinoIcons.person, size: 50,),
                      ),
                      RowDetails('Name:', providerData['name'] ?? ''),
                      RowDetails('Email:', providerData['email'] ?? ''),
                      RowDetails('Mobile:', providerData['mobile'] ?? ''),
                      RowDetails('District:', providerData['district'] ?? ''),
                      RowDetails('Pincode:', providerData['pincode'] ?? ''),
                      RowDetails('Category:', providerData['category'] ?? ''),
                      SizedBox(height: 40,),
                    ],
                  ),
                ),
              ),
            ),
            buildImage(),
            SizedBox(height: 10,),
            if (providerData['status'] == '0')
              buildStatusButtons('Accept', 'Reject', '1', '2')
            else if (providerData['status'] == '1')
              buildStatusText('Accepted')
            else if (providerData['status'] == '2')
              buildStatusText('Rejected'),
          ],
        ),
      ),
    );
  }

  Widget buildImage() {
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: Stack(
        children: [
          Center(
            child: Image.network(
              providerData['image'] ?? '',
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                }
              },
            ),
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget buildStatusButtons(String acceptText, String rejectText, String acceptStatus, String rejectStatus) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 38, right: 38, bottom: 20, top: 10),
          child: InkWell(
            onTap: () {
              updateStatusAndRefresh(acceptStatus);
            },
            child: Container(
              height: 50,
              width: double.infinity,
              child: Center(
                child: Text(acceptText, style: TextStyle(color: Colors.white, fontSize: 18),),
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
              updateStatusAndRefresh(rejectStatus);
            },
            child: Container(
              height: 45,
              width: double.infinity,
              child: Center(
                child: Text(rejectText, style: TextStyle(color: Color.fromARGB(255, 15, 1, 58), fontSize: 18),),
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
  }

  Widget buildStatusText(String statusText) {
    return Padding(
      padding: const EdgeInsets.only(left: 38, right: 38, bottom: 20, top: 10),
      child: Container(
        height: 50,
        width: double.infinity,
        child: Center(
          child: Text(statusText, style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Clr.clrdark,
        ),
      ),
    );
  }
}

class RowDetails extends StatelessWidget {
  final String label;
  final String value;

  RowDetails(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(value, style: GoogleFonts.poppins(fontSize: 16)),
      ],
    );
  }
}
