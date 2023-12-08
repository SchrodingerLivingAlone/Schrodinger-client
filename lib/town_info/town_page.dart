import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:schrodinger_client/style.dart';
import 'package:schrodinger_client/town_info/home_info.dart';
import 'package:schrodinger_client/town_info/food_info.dart';
import 'package:schrodinger_client/town_info/facility_info.dart';
import 'package:schrodinger_client/town_info/public_info.dart';
import 'package:schrodinger_client/town_info/question_info.dart';
import 'package:schrodinger_client/town_info/share_info.dart';
import 'package:schrodinger_client/town_info/together_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TownPage extends StatefulWidget {
  const TownPage({super.key});

  @override
  State<TownPage> createState() => _TownPageState();
}

class _TownPageState extends State<TownPage> {
  int _selectedIndex = 0;
  bool isCompleted = false;
  String townName = '검색중...';

  @override
  void initState(){
    super.initState();
    getTownName();
  }

  Future<void> getTownName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    String url = '${dotenv.env['BASE_URL']}/api/neighborhood/posts/location';

    final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        }
    );

    final res = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      townName = res['result']['town'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 7,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColor.main,
            title: Text(townName),
            leading: const Icon(Icons.place),
            actions: [
              IconButton(onPressed: (){
                Navigator.pushNamed(context, '/town/search');
              }, icon: const Icon(Icons.search))
            ],
            bottom: const TabBar(
                indicatorColor: Colors.white,
                isScrollable: true,
                tabs: [
                  Tab(text: '홈'),
                  Tab(text: '맛집'),
                  Tab(text: '시설'),
                  Tab(text: '정보공유'),
                  Tab(text: '같이해요'),
                  Tab(text: '소통해요'),
                  Tab(text: '기타'),
                ],
            ),
          ),
          body: TabBarView(
            children: [
              HomeInfoPage(townName: townName),
              const FoodInfoPage(tabIndex: 0),
              const FacilityInfoPage(tabIndex: 1),
              const ShareInfoPage(tabIndex: 2),
              const TogetherInfoPage(tabIndex: 3),
              const QuestionInfoPage(tabIndex: 4),
              const EtcInfoPage(tabIndex: 5),
            ],
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