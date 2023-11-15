import 'package:flutter/material.dart';
import 'package:schrodinger_client/style.dart';
import 'package:schrodinger_client/town_info/list_item.dart';

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
                          color: Colors.grey,
                          offset: Offset(0, 3),
                          blurRadius: 6.0,
                          spreadRadius: 2.0,
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
            const ListItem(title: '맛집'),
            const ListItem(title: '시설'),
            const ListItem(title: '할일'),
            const ListItem(title: '같이 해요'),
            const ListItem(title: '질문 요청'),
            const ListItem(title: '공공 정보'),
          ],
        );
  }
}



