import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mylockery/ui/history/history.dart';
import 'package:mylockery/ui/home/home.dart';

class MyNavigationBar extends StatefulWidget {
  User user;
  MyNavigationBar({required this.user, Key? key}) : super(key: key);

  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    _widgetOptions = <Widget>[
      Home(
        user: widget.user,
      ),
      History(
        user: widget.user,
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home', backgroundColor: Colors.green),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'History', backgroundColor: Colors.yellow),
      ], type: BottomNavigationBarType.shifting, currentIndex: _selectedIndex, selectedItemColor: Colors.black, iconSize: 40, onTap: _onItemTapped, elevation: 5),
    );
  }
}
