import 'package:classcheckup/pages/dashboard.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';

import 'pages/edit.dart';
import 'pages/profile.dart';

class IndexPage extends StatefulWidget {
  final String uid;
  const IndexPage({Key? key, required this.uid}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DashBoard(uid: widget.uid),
      EditPage(uid: widget.uid),
      ProfilePage(uid: widget.uid)
    ];
  }

  static const TextStyle style = TextStyle(
    fontFamily: 'Architect',
    fontSize: 18,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0
              ? 'Your Classes'
              : _selectedIndex == 1
                  ? 'Edit Classes'
                  : 'Profile',
          style: const TextStyle(
            fontFamily: 'Avenir',
            fontSize: 25,
          ),
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        buttonBackgroundColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: Theme.of(context).colorScheme.background,
        color: Theme.of(context).colorScheme.primaryContainer,
        items: const [
          CurvedNavigationBarItem(
            child: Icon(
              Icons.home,
              color: Colors.white,
            ),
            label: 'Home',
            labelStyle: style,
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            label: 'Edit',
            labelStyle: style,
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.perm_identity,
              color: Colors.white,
            ),
            label: 'Profile',
            labelStyle: style,
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
