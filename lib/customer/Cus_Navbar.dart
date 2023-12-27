import 'package:ats/Admin/accessories.dart';
import 'package:ats/customer/accessory/accessory.dart';
import 'package:ats/customer/cab/available-cab.dart';
import 'package:ats/customer/mechanics.dart';
import 'package:ats/customer/rent/rentaltab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key,}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
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
         child: InkWell(
          onTap: (){
            launchUrl(Uri.parse('tel:0496123456'));
          },
           child: SizedBox(
             child: Image.asset('assets/cs.jpg')),
         ),
       ),
       ],
      ),
      bottomNavigationBar: MotionTabBar(
        controller:
            _motionTabBarController, // ADD THIS if you need to change your tab programmatically
        initialSelectedTab: "Home",
        useSafeArea: true, // default: true, apply safe area wrapper
        labels: const ["Home", "Rental", "Accesssories", "Mechanics"],
        icons: const [
          Icons.car_rental_outlined,
         CupertinoIcons.car_detailed,
         CupertinoIcons.wrench,
         CupertinoIcons.person_2_fill
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
         AvailableCab(),
          RentalVehicle(),
          Acc1(),
         Mechanics(),
          ],
      ),
    );
  }
}
