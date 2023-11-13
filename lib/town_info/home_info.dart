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

    return
        ListView(
          children: [
            Stack(
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
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 10, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('맛집', style: TextStyle(fontSize: 20)),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            // elevation: 0,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)
                            )
                          ),
                          onPressed: (){},
                          child:const Text('더보기 >', style: TextStyle(fontSize: 15, color: Colors.grey)),
                      ),
                    ],
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
                Container(
                    height: 10,
                    color: AppColor.lightGrey
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 10, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('시설', style: TextStyle(fontSize: 20)),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // elevation: 0,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)
                            )
                        ),
                        onPressed: (){},
                        child:const Text('더보기 >', style: TextStyle(fontSize: 15, color: Colors.grey)),
                      ),
                    ],
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
                Container(
                    height: 10,
                    color: AppColor.lightGrey
                ),
              ],
            ),
          ],
        );
  }
}



