import 'package:flutter/material.dart';
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
      home: const HomePage(),
    );
  }
}

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
              ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top:10, bottom: 10),
                    child: ListTile(
                      title: const Text('기대치에 못미쳤던.. 백미당 후기'),
                      subtitle: const Text('유명한 백미당에 가봤는데 후기에서 봤던거랑 다르게...'),
                      trailing: const Icon(Icons.square, size: 50),
                      onTap: (){},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:10, bottom: 10),
                    child: ListTile(
                      title: const Text('기대치에 못미쳤던.. 백미당 후기'),
                      subtitle: const Text('유명한 백미당에 가봤는데 후기에서 봤던거랑 다르게...'),
                      trailing: const Icon(Icons.square, size: 50),
                      onTap: (){},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:10, bottom: 10),
                    child: ListTile(
                      title: const Text('기대치에 못미쳤던.. 백미당 후기'),
                      subtitle: const Text('유명한 백미당에 가봤는데 후기에서 봤던거랑 다르게...'),
                      trailing: const Icon(Icons.square, size: 50),
                      onTap: (){},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:10, bottom: 10),
                    child: ListTile(
                      title: const Text('기대치에 못미쳤던.. 백미당 후기'),
                      subtitle: const Text('유명한 백미당에 가봤는데 후기에서 봤던거랑 다르게...'),
                      trailing: const Icon(Icons.square, size: 50),
                      onTap: (){},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:10, bottom: 10),
                    child: ListTile(
                      title: const Text('기대치에 못미쳤던.. 백미당 후기'),
                      subtitle: const Text('유명한 백미당에 가봤는데 후기에서 봤던거랑 다르게...'),
                      trailing: const Icon(Icons.square, size: 50),
                      onTap: (){},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:10, bottom: 10),
                    child: ListTile(
                      title: const Text('기대치에 못미쳤던.. 백미당 후기'),
                      subtitle: const Text('유명한 백미당에 가봤는데 후기에서 봤던거랑 다르게...'),
                      trailing: const Icon(Icons.square, size: 50),
                      onTap: (){},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:10, bottom: 10),
                    child: ListTile(
                      title: const Text('기대치에 못미쳤던.. 백미당 후기'),
                      subtitle: const Text('유명한 백미당에 가봤는데 후기에서 봤던거랑 다르게...'),
                      trailing: const Icon(Icons.square, size: 50),
                      onTap: (){},
                    ),
                  ),
                ],
              ),

              ListTile(
                leading: const Icon(Icons.search),
                title: const Text('Search'),
                trailing: const Icon(Icons.navigate_next),
                onTap: (){},
              ),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const Text('Refresh'),
                trailing: const Icon(Icons.navigate_next),
                onTap: (){},
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                trailing: const Icon(Icons.navigate_next),
                onTap: (){},
              ),
              ListTile(
                leading: const Icon(Icons.search),
                title: const Text('Search'),
                trailing: const Icon(Icons.navigate_next),
                onTap: (){},
              ),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const Text('Refresh'),
                trailing: const Icon(Icons.navigate_next),
                onTap: (){},
              ),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const Text('ㅁㄴㅇㅁㄴㅇㅁㄴ'),
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
        )
    );
  }
}



