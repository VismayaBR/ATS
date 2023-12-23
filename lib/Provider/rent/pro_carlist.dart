import 'package:ats/Provider/rent/Addcar.dart';
import 'package:ats/Provider/cab/addcab.dart';
import 'package:ats/Provider/cab/addedcabvie.dart';
import 'package:ats/constants/font.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProCarList extends StatefulWidget {
  const ProCarList({super.key});

  @override
  State<ProCarList> createState() => _ProCarListState();
}

class _ProCarListState extends State<ProCarList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(

        children: [
          Text('Added Cars', style: GoogleFonts.poppins(
                  color: Clr.clrdark,
                  fontSize: 18,
                ),),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context,index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Clr.clrlight,
                    child: ListTile(
                      onTap: (){
                        // Navigator.push(context, MaterialPageRoute(builder: (context){
                        //   return CabRequestView1();
                        // }));
                      },
                      leading: Container(height: 80,width: 80,child: Image.network('https://imgd.aeplcdn.com/370x208/n/cw/ec/130591/fronx-exterior-right-front-three-quarter-109.jpeg?isig=0&q=80'),),
                      title: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Name'),
                        ),
                      ),
                      subtitle: Text('    Seat'),
                    ),
                  ),
                );
              }),
          ),
        ],
      ),
    floatingActionButton: FloatingActionButton(onPressed: (){
      Navigator.push(context, MaterialPageRoute(builder: (ctx){
        return AddCar();
      }));
    },child: Icon(Icons.add,color: Clr.clrlight,),backgroundColor: Clr.clrdark,),
    );
  }
}