import 'package:ats/Login.dart';
import 'package:ats/Provider/ProviderHome.dart';
import 'package:ats/Provider/cab%20his.dart';
import 'package:ats/Provider/mechanicview.dart';
import 'package:ats/Provider/payment_history.dart';
import 'package:ats/Provider/payment_tab.dart';
import 'package:ats/Provider/requests.dart';
import 'package:ats/customer/accessory/accessory.dart';
import 'package:ats/customer/cab/available-cab.dart';
import 'package:ats/customer/mechanics.dart';
import 'package:ats/customer/rent/rentaltab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motion_tab_bar_v2/motion-badge.widget.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';

class ProNavbar extends StatefulWidget {
  const ProNavbar({Key? key,}) : super(key: key);


  @override
  _ProNavbarState createState() => _ProNavbarState();
}

class _ProNavbarState extends State<ProNavbar> with TickerProviderStateMixin {
  // TabController? _tabController;
  MotionTabBarController? _motionTabBarController;

  @override
  void initState() {
    super.initState();
    // Use normal tab controller
    // _tabController = TabController(
      initialIndex: 0;
      length: 4;
      vsync: this;
    // );

    //// use "MotionTabBarController" to replace with "TabController", if you need to programmatically change the tab
    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _motionTabBarController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: IconButton(icon: Icon(Icons.settings_power_sharp), onPressed: () { 
              Navigator.push(context, MaterialPageRoute(builder: (ctx){
                return HomeScreen();
              }));
              },),
           ),
        ],
        // title: Text(widget.title!),
      ),
      bottomNavigationBar: MotionTabBar(
        controller:
            _motionTabBarController, // ADD THIS if you need to change your tab programmatically
        initialSelectedTab: "Home",
        useSafeArea: true, // default: true, apply safe area wrapper
        labels: const ["Home", "Request", "Mechanics", "Payments"],
        icons: const [
         Icons.car_rental,
         CupertinoIcons.doc_on_clipboard,
         CupertinoIcons.person_2_fill,
         CupertinoIcons.money_dollar
        ],

        // optional badges, length must be same with labels
        
        tabSize: 50,
        tabBarHeight: 55,
        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        tabIconColor: Colors.blue[600],
        tabIconSize: 28.0,
        tabIconSelectedSize: 26.0,
        tabSelectedColor: const Color.fromARGB(255, 1, 30, 73),
        tabIconSelectedColor: Colors.white,
        tabBarColor: Color.fromARGB(255, 241, 250, 255),
        onTabItemSelected: (int value) {
          setState(() {
            _motionTabBarController!.index = value;
          });
        },
      ),
      body: TabBarView(
        physics:
            const NeverScrollableScrollPhysics(), // swipe navigation handling is not supported
        controller: _motionTabBarController,
        children: [
         ProHome(),
          Requests(),
          Mech(),
         CabPaymentHistory(),
          ],
      ),
    );
  }
}
