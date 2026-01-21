import 'package:flutter/material.dart';
import 'package:to_do_app/calendar_screen.dart';
import 'package:to_do_app/home_screen.dart';
import 'package:to_do_app/setting_screen.dart';
import 'package:to_do_app/task_screen.dart';

class BottomScreen extends StatefulWidget {
  final int initialIndex;
  const BottomScreen({super.key,this.initialIndex=0});

  @override
  State<BottomScreen> createState() => _BottomScreenState();
}

class _BottomScreenState extends State<BottomScreen> {
  late int myIndex;
  @override
  void initState() {
    super.initState();
    myIndex = widget.initialIndex;
  }

  List<Widget> widgetList = [ HomeScreen(),TaskScreen(), CalendarScreen(), SettingScreen(),];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: myIndex,children: widgetList),
      //widgetList[myIndex],

      bottomNavigationBar:
        // decoration: BoxDecoration(
        //   // color: Color(0xff05243E),
        //   gradient: LinearGradient(
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //     colors: [Color(0xff1253AA), Color(0xff05243E)],
        //   ),
        // ),
      BottomNavigationBar(backgroundColor: Color(0xff05243E),
        //type: BottomNavigationBarType.fixed,
        currentIndex: myIndex,
        onTap: (index){
          setState(() {
            myIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        iconSize: 33,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
      ),
    );
  }
}
