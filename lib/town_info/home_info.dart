import 'package:flutter/material.dart';
import 'package:schrodinger_client/style.dart';
import 'package:schrodinger_client/town_info/category_dropdown.dart';

class HomeInfoPage extends StatefulWidget {
  const HomeInfoPage({super.key});

  @override
  State<HomeInfoPage> createState() => _HomeInfoPageState();
}

class _HomeInfoPageState extends State<HomeInfoPage> {
  int sortIndex = 0;
  final sortCategory = ['카테고리', '최신순', '인기순'];

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return TabBarView(
      children: [
        ListView(
          children: [
            Stack(
              // height: 100,
              // color: AppColor.lightGrey,
              alignment: Alignment.center,
              children: [
                Container(
                  height: deviceHeight * 0.20,
                  color: AppColor.lightGrey,
                ),
                Container(
                    decoration: BoxDecoration(
                      color: AppColor.yellow,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey, // 그림자 색상
                          offset: Offset(0, 3), // 그림자의 위치 (가로, 세로)
                          blurRadius: 6.0, // 그림자의 흐림 정도
                          spreadRadius: 2.0, // 그림자의 확산 정도
                        ),
                      ],
                      ),
                  height: deviceHeight * 0.15,
                  width: deviceWidth * 0.85,
                  child: const Center(
                    child: Text(
                        '이번주 전농동에서\n 가장 인기있는 글들을 구경해보세요!💫',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold
                        ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ),
              ],
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
          title: const Text('공공 정보'),
          trailing: const Icon(Icons.navigate_next),
          onTap: (){},
        ),
      ],
    );
  }
}



