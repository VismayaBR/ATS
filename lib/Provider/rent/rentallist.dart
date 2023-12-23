import 'package:ats/Admin/Homerental.dart';
import 'package:ats/Admin/navbar.dart';
import 'package:ats/Provider/ProviderView.dart';
import 'package:ats/constants/font.dart';
import 'package:flutter/material.dart';

class RentalList extends StatefulWidget {
  const RentalList({super.key});

  @override
  State<RentalList> createState() => _RentalListState();
}

class _RentalListState extends State<RentalList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 25,
          ),
          Container(
            height: 50,
            width: 250,
            child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                                'Rental Providers',
                                style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255), fontSize: 18),
                              ),
                )),
            decoration: BoxDecoration(
              border: Border.all(color: Clr.clrlight),
              borderRadius: BorderRadius.circular(10),
              color: Clr.clrdark,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Clr.clrlight,
                  child: ListTile(
                    onTap: () {
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) {
                      //   return ProviderView();
                      // }));
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://t4.ftcdn.net/jpg/04/83/90/95/360_F_483909569_OI4LKNeFgHwvvVju60fejLd9gj43dIcd.jpg'),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Name'),
                      ),
                    ),
                    subtitle: Text('    Subtitle'),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
