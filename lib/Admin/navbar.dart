 
  
import 'package:ats/Admin/Home.dart';
import 'package:ats/Admin/accessories.dart';
import 'package:ats/Admin/payment.dart';
import 'package:ats/constants/font.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyNavigationBar extends StatefulWidget {  
  MyNavigationBar ({Key? key}) : super(key: key);  
  
  @override  
  _MyNavigationBarState createState() => _MyNavigationBarState();  
}  
  
class _MyNavigationBarState extends State<MyNavigationBar > {  
  int _selectedIndex = 1;  
  static const List<Widget> _widgetOptions = <Widget>[  
    
    Acc(),
    HomePage(), 
    Payment() 
  ];  
  
  void _onItemTapped(int index) {  
    setState(() {  
      _selectedIndex = index;  
    });  
  }  
  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
        
      body: Center(  
        child: _widgetOptions.elementAt(_selectedIndex),  
      ),  
      bottomNavigationBar: BottomNavigationBar(  
        items: const <BottomNavigationBarItem>[  
           
          BottomNavigationBarItem(  
            icon: Icon(CupertinoIcons.wrench,color: Colors.black,),  
            label: 'Accessories',  
            backgroundColor: Clr.clrlight 
          ),
           BottomNavigationBarItem(  
            icon: Icon(CupertinoIcons.home,color: Colors.black,),  
            label: 'Home',  
            backgroundColor: Clr.clrlight 
          ),  
          BottomNavigationBarItem(  
            icon: Icon(Icons.payment,color: Colors.black,),  
            label: 'Payment',  
            backgroundColor: Clr.clrlight
          ),  
        ],  
        type: BottomNavigationBarType.shifting,  
        currentIndex: _selectedIndex,  
        selectedItemColor: Colors.black,  
        iconSize: 40,  
        onTap: _onItemTapped,  
        elevation: 5  
      ),  
    );  
  }  
}  