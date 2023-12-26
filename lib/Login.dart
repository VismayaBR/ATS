
import 'package:ats/Admin/navbar.dart';
import 'package:ats/Provider/Pro_navbar.dart';
import 'package:ats/Provider/pronav1.dart';
import 'package:ats/choose.dart';
import 'package:ats/constants/font.dart';
import 'package:ats/customer/Cus_Navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();

  var email = TextEditingController();
  var password = TextEditingController();


  // var type = 'customer';
// var type = 'provider';
Future<void> loginUser() async {
  try {
    const String adminEmail = 'admin@gmail.com';
    const String adminPassword = 'admin@123';

    if (email.text == adminEmail && password.text == adminPassword) {
      Fluttertoast.showToast(msg: 'Login Successful as Admin');
      // Redirect to the admin home page
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return MyNavigationBar();
      }));
      return;
    }

    // Check if the user with the provided email and password exists in the customers' table
    final QuerySnapshot<Map<String, dynamic>> customerSnapshot =
        await FirebaseFirestore.instance
            .collection('customers')
            .where('email', isEqualTo: email.text)
            .where('password', isEqualTo: password.text)
            .where('status', isEqualTo: '1')
            .get();

    // Check if the user with the provided email and password exists in the providers' table
    final QuerySnapshot<Map<String, dynamic>> providerSnapshot =
        await FirebaseFirestore.instance
            .collection('providers')
            .where('email', isEqualTo: email.text)
            .where('password', isEqualTo: password.text)
            .where('status', isEqualTo: '1')
            .get();
    if (customerSnapshot.docs.isNotEmpty) {
      String customerId = customerSnapshot.docs[0].id;
      SharedPreferences spref = await SharedPreferences.getInstance();
      spref.setString('user_id', customerId);
      Fluttertoast.showToast(msg: 'Login Successful as Customer');
      print('Customer ID: $customerId');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return MyHomePage();
      }));
    } else if (providerSnapshot.docs.isNotEmpty) {
      String providerId = providerSnapshot.docs[0].id;
      SharedPreferences spref = await SharedPreferences.getInstance();
      spref.setString('user_id', providerId);
      String category = providerSnapshot.docs[0]['category'];

      Fluttertoast.showToast(msg: 'Login Successful as Provider');

      if (category == 'Cab') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return ProNavbar();
        }));
      } else if (category == 'Rent') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return ProNavbar1();
        }));
      } else {
        // Handle the case where the category is not recognized
        Fluttertoast.showToast(msg: 'Unknown provider category');
        print('Unknown provider category');
      }
    } else {
      Fluttertoast.showToast(msg: 'Invalid credentials');
      print('Invalid credentials');
    }
  } catch (e) {
    print('Error logging in: $e');
    // Handle errors and show an error message to the user if needed
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                height: 150,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Login',
                    style: GoogleFonts.poppins(fontSize: 40),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Welcome back you've been missed!",
                      style: GoogleFonts.poppins(fontSize: 15)),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              TextFormField(
                controller: email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Email';
                  }

                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Email',
                  filled: true,
                  fillColor: Clr.clrlight,
                  border: InputBorder.none,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: password,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Password';
                  }

                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Password',
                  filled: true,
                  fillColor: Clr.clrlight,
                  border: InputBorder.none,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Forgot Password?'),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              InkWell(
                // <------------------ADMIN------------------->
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    // print(email.text);
                    if (email.text == 'admin@gmail.com' &&
                        password.text == 'admin@123') {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MyNavigationBar();
                      }));
                    }
                    loginUser();

                    // If login is successful, navigate to HomeScreen
                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    //   return HomeScreen();
                    // }));
                  }
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) {
                  //   return MyNavigationBar();
                  // }));

                  // <------------------------------------------->

                  // <------------------CUSTOMER------------------->

                  //  onTap: (){
                  //   Navigator.push(context, MaterialPageRoute(builder:  (context){
                  //     return MyHomePage();
                  //   }));

                  // <------------------------------------------->

                  // <-----------------PROVIDER-------------------------->

                  // onTap: (){
                  // Navigator.push(context, MaterialPageRoute(builder:  (context){
                  //   return ProCarNav();
                  // }));
                },
                child: Container(
                  child: Center(
                      child: Text(
                    'Login',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  )),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Clr.clrdark,
                  ),
                  height: 50,
                  width: double.infinity,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Choose();
                    }));
                  },
                  child: Text(
                    'Create new account?',
                    style: GoogleFonts.poppins(fontSize: 15),
                  ))
            ]),
          ),
        ),
      ),
    );
  }
}
