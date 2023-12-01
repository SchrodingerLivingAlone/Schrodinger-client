import 'package:flutter/material.dart';
import 'package:schrodinger_client/style.dart';
import 'package:schrodinger_client/town_info/home_info.dart';
import 'package:schrodinger_client/town_info/food_info.dart';
import 'package:schrodinger_client/town_info/facility_info.dart';

class TownPage extends StatefulWidget {
  const TownPage({super.key});

  @override
  State<TownPage> createState() => _TownPageState();
}

class _TownPageState extends State<TownPage> {
  int _selectedIndex = 0;
  bool isCompleted = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 7,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColor.main,
            title: const Text('전농동'),
            leading: const Icon(Icons.place),
            actions: [
              IconButton(onPressed: (){}, icon: const Icon(Icons.search))
            ],
            bottom: const TabBar(
                indicatorColor: Colors.white,
                isScrollable: true,
                tabs: [
                  Tab(text: '홈'),
                  Tab(text: '맛집'),
                  Tab(text: '시설'),
                  Tab(text: '할인'),
                  Tab(text: '같이 해요'),
                  Tab(text: '질문 요청'),
                  Tab(text: '공공 정보'),
                ]
            ),
          ),
          body: TabBarView(
            children: [
              const HomeInfoPage(),
              const FoodInfoPage(),
              const FacilityInfoPage(),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('할인'),
                trailing: const Icon(Icons.navigate_next),
                onTap: (){},
              ),
              ListTile(
                leading: const Icon(Icons.search),
                title: const Text('같이 해요'),
                trailing: const Icon(Icons.navigate_next),
                onTap: (){},
              ),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const Text('질문 요청'),
                trailing: const Icon(Icons.navigate_next),
                onTap: (){},
              ),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const Text('공공 정보'),
                trailing: const Icon(Icons.navigate_next),
                onTap: (){},
              ),
            ],
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
          ),
          floatingActionButton: FloatingActionButton.extended(
              backgroundColor: AppColor.yellow,
              onPressed: (){
                Navigator.pushNamed(context, '/post');
              },
              label: const Text('글쓰기'),
              icon: const Icon(Icons.post_add)
          ),
        )
    );
  }
}