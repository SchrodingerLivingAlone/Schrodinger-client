import 'package:flutter/material.dart';
import 'package:schrodinger_client/town_info/facility_info.dart';
import 'package:schrodinger_client/town_info/food_info.dart';
import 'package:schrodinger_client/town_info/home_info.dart';
import 'package:schrodinger_client/town_info/post_page.dart';
import 'package:schrodinger_client/style.dart';
import 'package:schrodinger_client/town_info/town_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        primaryColor: AppColor.main,
        primarySwatch: Colors.deepPurple,
        // useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/' : (context) => const MainPage(),
        '/post' : (context) => const PostPage(),
        '/town/auth' : (context) => const TownAuthPage()
      },
      // home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  bool isCompleted = false;

  void _onItemTapped(int index) {
    setState(() {
      if (index == 2){
        showDialog(context: context, builder: (context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0), // BorderRadius 조절
            ),
            // title: const Text('AlertDialog'),
            elevation: 20,
            content: const Text(
              "동네인증을 완료해야 \n 동네정보에 접근할 수 있습니다.\n 동네인증 페이지로 이동할까요?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15)
            ),
            contentPadding: const EdgeInsets.only(top: 30),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('취소', style: TextStyle(fontSize: 20, color: Colors.red)),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isCompleted == true
                        ? isCompleted = false
                        : isCompleted = true;
                  });
                  // Navigator.of(context).pop(); // TODO: 동네 인증 화면으로 넘어가기
                  Navigator.pushNamed(context, '/town/auth');

                },
                child: const Text('이동', style: TextStyle(fontSize: 20, color: Colors.blue)),
              ),
            ],
          );
        });
      } else {
        _selectedIndex = index;
      }
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
            actions: [
              IconButton(onPressed: (){}, icon: const Icon(Icons.search))
            ],
            bottom: const TabBar(
              // unselectedLabelColor: Colors.white,
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
          drawer: const Drawer(),
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