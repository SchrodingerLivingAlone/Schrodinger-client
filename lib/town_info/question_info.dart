import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:schrodinger_client/town_info/food_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../post/post_info.dart';
import 'category_dropdown.dart';

class QuestionInfoPage extends StatefulWidget {
  final int tabIndex;

  const QuestionInfoPage({super.key, required this.tabIndex});

  @override
  State<QuestionInfoPage> createState() => _QuestionInfoPageState();
}

class _QuestionInfoPageState extends State<QuestionInfoPage> {
  late List<TownInfo> questionList = [];
  int sortedIndex = 0;

  @override
  void initState() {
    super.initState();
    getQuestionPost();
  }

  void setSortedIndex(int index) {
    setState(() {
      sortedIndex = index;
    });
    getQuestionPost();
  }

  List<Widget> createTownListTiles(List<TownInfo> townInfoList) {
    List<Widget> townTiles = [];

    for (int i = 0; i < townInfoList.length; i++) {
      TownInfo town = townInfoList[i];

      Widget townTile = Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: ListTile(
          title: Text(town.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Text(town.content, style: TextStyle(fontSize: 12)),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(town.dong),
                  const SizedBox(width: 10),
                  Text(town.calculatedTime),
                  const SizedBox(width: 10),
                  Text('조회 ${town.view}'),
                ],
              ),
            ],
          ),
          trailing: Column(
            children: [
              Image.network(
                town.imageUrl,
                width: 60,
                height: 40,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child; // 이미지 로드 완료됨
                  } else {
                    return const CircularProgressIndicator(); // 이미지 로드 중
                  }
                },
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  return Image.asset('assets/default_profile.png', width: 60, height: 40,); // 오류 발생 시 기본 이미지
                },
              ),
              Text('댓글 ${town.commentCount} 공감 ${town.likeCount}', style: TextStyle(fontSize: 11)),
            ],
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PostInfo(PostId: town.id)));
          },
        ),
      );
      townTiles.add(townTile);
    }
    return townTiles;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CategoryDropdown(setSortedIndex: setSortedIndex),
        ...createTownListTiles(questionList),
      ],
    );
  }

  Future<void> getQuestionPost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    String url = '${dotenv.env['BASE_URL']}/api/neighborhood/posts?sortBy=$sortedIndex&category=${widget.tabIndex}';

    final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        }
    );

    final res = jsonDecode(utf8.decode(response.bodyBytes));
    final List<dynamic> responseResult = res['result'];
    List<TownInfo> questions = responseResult.map((data) => TownInfo.fromJson(data)).toList();

    setState(() {
      questionList = questions;
    });
  }
}