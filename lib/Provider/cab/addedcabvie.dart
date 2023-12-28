import 'package:ats/Provider/Pro_navbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CabRequestView1 extends StatefulWidget {
  final String id;

  CabRequestView1({Key? key, required this.id}) : super(key: key);

  @override
  State<CabRequestView1> createState() => _CabRequestView1State();
}

class _CabRequestView1State extends State<CabRequestView1> {
  Map<String, dynamic> cabData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  Future<void> fetchDataFromFirebase() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection('cabs')
              .doc(widget.id)
              .get();

      setState(() {
        cabData = documentSnapshot.data() ?? {};
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
      // Handle errors as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Center(
                child: Text(
                  'Cabs',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              if (isLoading)
                Center(
                  child: CircularProgressIndicator(),
                )
              else
                CabDetailsWidget(cabData: cabData, id: widget.id),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class CabDetailsWidget extends StatefulWidget {
  final Map<String, dynamic> cabData;
  final String id;

  CabDetailsWidget({required this.cabData, required this.id});

  @override
  _CabDetailsWidgetState createState() => _CabDetailsWidgetState();
}

class _CabDetailsWidgetState extends State<CabDetailsWidget> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.cabData['name']);
    priceController = TextEditingController(text: widget.cabData['price']);
    descriptionController = TextEditingController(text: widget.cabData['desc']);
  }

  Future<void> _showEditDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Cab Details'),
          content: SizedBox(
            height: 250,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(hintText: 'Enter new name'),
                  ),
                  TextField(
                    controller: priceController,
                    decoration: InputDecoration(hintText: 'Enter Price'),
                  ),
                  TextField(
                    controller: descriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(hintText: 'Enter description'),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Implement logic to update the cab details
                String newName = nameController.text;
                String newPrice = priceController.text;
                String newDescription = descriptionController.text;

                // Update Firestore document
                try {
                  await FirebaseFirestore.instance
                      .collection('cabs')
                      .doc(widget.id)
                      .update({
                    'name': newName,
                    'price': newPrice,
                    'desc': newDescription,
                  });

                  // Provide feedback to the user (optional)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Cab details updated successfully!'),
                    ),
                  );

                  // Close the dialog
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx){
                  return ProNavbar();
                }));
                } catch (e) {
                  print('Error updating cab details: $e');

                  // Provide feedback to the user (optional)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to update cab details. Please try again.'),
                    ),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          width: 400,
          color: const Color.fromARGB(255, 255, 255, 255),
          child: Image.network(
            widget.cabData['v_image'] ?? '',
          ),
        ),
        SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.cabData['name'] ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(icon: Icon(Icons.edit), onPressed: _showEditDialog),
              ],
            ),
            
            Text(
              'Available',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Description',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.cabData['desc'] ?? '',
              style: GoogleFonts.poppins(fontSize: 15),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CabDetail(label: 'seat ', value: widget.cabData['seat']?.toString() ?? ''),
                CabDetail(label: 'Price per Hour  ', value: widget.cabData['price']?.toString() ?? ''),
              ],
            ),
            SizedBox(height: 20),
            Container(
              height: 100,
              width: double.infinity,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Image.network(
                widget.cabData['rc'] ?? '',
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}

class CabDetail extends StatelessWidget {
  final String label;
  final String value;

  CabDetail({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 15),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(fontSize: 15),
        ),
      ],
    );
  }
}
