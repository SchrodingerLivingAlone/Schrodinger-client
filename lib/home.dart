import 'package:flutter/material.dart';
import 'package:schrodinger_client/account/accountbank.dart';
import 'package:schrodinger_client/mypage/my_page.dart';
import 'package:schrodinger_client/style.dart';
import 'package:schrodinger_client/town_info/town_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
  }

  @override
  Widget build(BuildContext context) {

    final List<Widget> bottomTabWidgets = <Widget>[const TownPage(), const AccountBank(), const TownPage(), const MyPage()];
    return Scaffold(
          body: SafeArea(
            child: bottomTabWidgets.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
              BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: '가계부'),
              BottomNavigationBarItem(icon: Icon(Icons.post_add), label: '동네정보'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
        )
    );
  }
}
