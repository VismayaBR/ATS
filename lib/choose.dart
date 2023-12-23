import 'package:ats/constants/font.dart';
import 'package:ats/Provider/pro_signup.dart';
import 'package:ats/customer/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Choose extends StatefulWidget {
  const Choose({super.key});

  @override
  State<Choose> createState() => _ChooseState();
}

class _ChooseState extends State<Choose> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (ctx){
                    return SignUp();
                  }));
                },
              child: Container(
                  child: Center(
                      child: Text(
                    'Customer Registration',
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
              SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (ctx){
                    return ProSignup();
                  }));
                },
                child: Container(
                  child: Center(
                      child: Text(
                    'Provider Registration',
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
          ],
        ),
      ),
    );
  }
}