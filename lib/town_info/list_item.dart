import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:schrodinger_client/post/post_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'food_info.dart';

class ListItem extends StatefulWidget {
  final String title;
  const ListItem({Key?key, required this.title}) : super(key: key);

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  late List<TownInfo> postList = [];

  @override
  void initState() {
    super.initState();
    getPost();
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 10, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(widget.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        ...createTownListTiles(postList),
      ],
    );
  }

  Future<void> getPost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    String url = '${dotenv.env['BASE_URL']}/api/neighborhood/posts?sortBy=3&category=0';

    final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        }
    );

    final res = jsonDecode(utf8.decode(response.bodyBytes));
    final List<dynamic> responseResult = res['result'];
    List<TownInfo> posts = responseResult.map((data) => TownInfo.fromJson(data)).toList();

    setState(() {
      postList = posts;
    });
  }
}



