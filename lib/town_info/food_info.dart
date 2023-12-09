import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:schrodinger_client/post/post_info.dart';
import 'package:schrodinger_client/town_info/category_dropdown.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FoodInfoPage extends StatefulWidget {
  final int tabIndex;

  const FoodInfoPage({super.key, required this.tabIndex});

  @override
  State<FoodInfoPage> createState() => _FoodInfoPageState();
}

class _FoodInfoPageState extends State<FoodInfoPage> {
  late List<TownInfo> foodList = [];
  int sortedIndex = 0;

  @override
  void initState() {
    super.initState();
    getFoodPost();
  }

  void setSortedIndex(int index) {
    setState(() {
      sortedIndex = index;
    });
    getFoodPost();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CategoryDropdown(setSortedIndex: setSortedIndex),
        ...createTownListTiles(foodList),
      ]
    );
  }

  Future<void> getFoodPost() async {
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
    List<TownInfo> foods = responseResult.map((data) => TownInfo.fromJson(data)).toList();

    setState(() {
      foodList = foods;
    });
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
          onTap: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (context) => PostInfo(PostId: town.id)));
            getFoodPost();
          },
        ),
      );
      townTiles.add(townTile);
    }
    return townTiles;
  }
}

class TownInfo {
  int id;
  String dong;
  String neighborhoodPostCategory;
  String title;
  String content;
  String imageUrl;
  String createdAt;
  String calculatedTime;
  int view;
  int likeCount;
  int commentCount;



  TownInfo({
    required this.id,
    required this.dong,
    required this.neighborhoodPostCategory,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.createdAt,
    required this.calculatedTime,
    required this.view,
    required this.likeCount,
    required this.commentCount,
  });

  factory TownInfo.fromJson(Map<String, dynamic> json) {
    return TownInfo(
      id: json['id'],
      dong: json['dong'],
      neighborhoodPostCategory: json['neighborhoodPostCategory'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      createdAt: json['createdAt'],
      calculatedTime: json['calculatedTime'],
      view: json['view'],
      likeCount: json['likeCount'],
      commentCount: json['commentCount'],
    );
  }
}
