import 'package:ats/Provider/pronav1.dart';
import 'package:ats/constants/font.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CarViewPro extends StatefulWidget {
  final String id;

  CarViewPro({Key? key, required this.id}) : super(key: key);

  @override
  State<CarViewPro> createState() => _CarViewProState();
}

class _CarViewProState extends State<CarViewPro> {
  late Map<String, dynamic> carData = {};
  late bool isAvailable=true; // Availability status
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase(); // Fetch data during initState
  }

  Future<void> fetchDataFromFirebase() async {
    try {
      // Simulate loading time
      await Future.delayed(Duration(seconds: 2));

      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance.collection('rent').doc(widget.id).get();

      setState(() {
        carData = documentSnapshot.data() ?? {};
        isAvailable = carData['status'] ?? false; // Set availability status
        isLoading = false; // Set loading to false after data is loaded
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false; // Set loading to false even if there's an error
      });
    }
  }

  Future<void> updateAvailabilityStatus(bool newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('rent')
          .doc(widget.id)
          .update({'status': newStatus});
      print('Status updated successfully');
    } catch (e) {
      print('Error updating status: $e');
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
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Car for rent',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              height: 200,
              width: 400,
              color: Clr.clrlight,
              child: isLoading
                  ? Center(child: CircularProgressIndicator()) // Show circular progress indicator during loading
                  : (carData['v_image'] as String?) != null
                      ? Image.network(carData['v_image'] as String)
                      : Text('Image not available'),
            ),
            SizedBox(height: 20),
             
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      carData['name'] ?? '...',
                      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(icon:Icon(Icons.edit), onPressed: () { 
                      _showEditDialog();
                     },)
                  ],
                ),
                Text(
                      'Rs. ${carData['price']}',
                      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Available:',
                      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                   
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: isAvailable,
                        onChanged: isLoading
                            ? null
                            : (value) async {
                                setState(() {
                                  isAvailable = value;
                                });
                                await updateAvailabilityStatus(value);
                              },
                        activeTrackColor: Colors.green,
                        activeColor: Colors.white,
                        inactiveThumbColor: const Color.fromARGB(255, 255, 255, 255),
                        inactiveTrackColor: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Description',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  carData['desc'] ?? 'Description loading...',
                  style: GoogleFonts.poppins(fontSize: 15),
                ),
                SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
 Future<void> _showEditDialog() async {
  // Create controllers and set initial values
  TextEditingController nameController = TextEditingController(text: carData['name']);
  TextEditingController priceController = TextEditingController(text: carData['price']);
  TextEditingController descriptionController = TextEditingController(text: carData['desc']);

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Edit Car Details'),
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
            onPressed: () {
              // Implement logic to update the car details
              // Access the entered text from controllers
              // nameController.text, priceController.text, descriptionController.text;
              Navigator.of(context).pop();
            },
            child:  TextButton(
            onPressed: () async {
              // Implement logic to update the car details
              String newName = nameController.text;
              String newPrice = priceController.text;
              String newDescription = descriptionController.text;

              // Update Firestore document
              try {
                await FirebaseFirestore.instance
                    .collection('rent')
                    .doc(widget.id)
                    .update({
                  'name': newName,
                  'price': newPrice,
                  'desc': newDescription,
                });

                // Provide feedback to the user (optional)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Car details updated successfully!'),
                  ),
                );

                // Close the dialog
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx){
                  return ProNavbar1();
                }));
              } catch (e) {
                print('Error updating car details: $e');

                // Provide feedback to the user (optional)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to update car details. Please try again.'),
                  ),
                );
              }
            },
            child: Text('Save'),
          ),
          ),
        ],
      );
    },
  );
}

}
