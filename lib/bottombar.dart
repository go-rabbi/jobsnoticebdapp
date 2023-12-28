import 'package:flutter/material.dart';
import 'package:jobs/screens/homepage.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  PageController pageController = PageController();
  List<Widget> views = [
    HomePage(),
    CategoryPage(),
    HomePage(),
    HomePage(),
  ];
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice of usaf'),
      ),
      body: PageView(
        onPageChanged: (int v) {
          index = v;
        },
        children: views,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.blue,
        onTap: (int v) {
          index = v;
          pageController.jumpToPage(index);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        ],
      ),
    );
  }
}
