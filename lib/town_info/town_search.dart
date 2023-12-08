import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:schrodinger_client/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../post/post_info.dart';
import 'food_info.dart';

class TownSearchPage extends StatefulWidget {
  const TownSearchPage({super.key});

  @override
  State<TownSearchPage> createState() => _TownSearchPageState();
}

class _TownSearchPageState extends State<TownSearchPage> {
  final _searchController = TextEditingController();
  late List<TownInfo> townList = [];


  List<Widget> createTownListTiles() {
    List<Widget> townTiles = [];

    for (int i = 0; i < townList.length; i++) {
      TownInfo post = townList[i];


      Widget townTile = Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: ListTile(
          title: Text(post.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Text(post.content, style: TextStyle(fontSize: 12)),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(post.dong),
                  const SizedBox(width: 10),
                  Text(post.calculatedTime),
                  const SizedBox(width: 10),
                  Text('조회 ${post.view}'),
                ],
              ),
            ],
          ),
          trailing: Column(
            children: [
              Image.network(
                post.imageUrl,
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
              Text('댓글 ${post.commentCount} 공감 ${post.likeCount}', style: TextStyle(fontSize: 11)),
            ],
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PostInfo(PostId: post.id)));
          },
        ),
      );
      townTiles.add(townTile);
    }
    return townTiles;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.black
        ),
        backgroundColor: Colors.white,
        title: const Center(
            child: Text('동네정보 검색', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
        actions: [
          Container(
              color: Colors.white,
              width: 50,
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(left:20, right:20, top:10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () async {
                    // await writeComment(post.id, _commentController.text);
                    FocusScope.of(context).unfocus();
                  },
                  icon:  Icon(Icons.search),
                ),
                labelText: '검색할 정보를 입력해주세요...',
              ),
              onSubmitted: (value) async {
                await searchTownInfo(_searchController.text);
              },
            ),
          ),
          ...createTownListTiles()
        ],
      ),
    );
  }


  Future<void> searchTownInfo(String keyword) async {
    print('keyword : $keyword');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    String url = '${dotenv.env['BASE_URL']}/api/neighborhood/posts/search?keyword=$keyword';

    final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        }
    );

    final res = jsonDecode(utf8.decode(response.bodyBytes));
    final List<dynamic> responseResult = res['result'];
    print(responseResult);
    List<TownInfo> posts = responseResult.map((data) => TownInfo.fromJson(data)).toList();

    setState(() {
      townList = posts;
    });
  }
}
