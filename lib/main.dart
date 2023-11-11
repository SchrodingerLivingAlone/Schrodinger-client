import 'package:flutter/material.dart';
import 'package:schrodinger_client/facility_info.dart';
import 'package:schrodinger_client/home_info.dart';
import 'package:schrodinger_client/style.dart';

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
              const PostPage(),
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

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black
          ),
          backgroundColor: Colors.white,
          title: const Center(
              child: Text('새 게시물', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shadowColor: Colors.transparent,
              ),
              onPressed: (){
                Navigator.pop(context);
              },
              child: const Text('등록',
                  style: TextStyle(
                      color: AppColor.main,
                      fontWeight: FontWeight.bold
                  )
              )
            ),
          ],
        ),
      );
    }
}