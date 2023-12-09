import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../post/post_info.dart';
import '../town_info/category_dropdown.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({super.key});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  List<LikeInfo> likeslist = [];

  @override
  void initState() {
    super.initState();
    getLikesPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('스크랩 글')),
        backgroundColor: const Color(0xFF0010A3),
        actions: [
          IconButton(onPressed: (){
          }, icon:const Icon(Icons.settings)),
        ],
      ),

      body: ListView.builder(
        itemCount: likeslist.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top:10, bottom: 10),
            child: ListTile(
              title: Text(likeslist[index].title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text(likeslist[index].content, style: TextStyle(fontSize: 12)),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(likeslist[index].dong),
                      const SizedBox(width: 10),
                      Text('조회 ${likeslist[index].view}'),
                    ],
                  ),
                ],
              ),
              trailing: Column(
                children: [
                  Image.network(
                    likeslist[index].imageUrl,
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
                  Text('댓글 ${likeslist[index].commentCount} 공감 ${likeslist[index].likeCount}', style: TextStyle(fontSize: 11)),
                ],
              ),
              onTap: () {  //*******************************이부분 준혁이거랑 merge해서 연동
                Navigator.push(context, MaterialPageRoute(builder: (context) => PostInfo(PostId: likeslist[index].id)));
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> getLikesPost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    String url = '${dotenv.env['BASE_URL']}/api/scraps';

    final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        }
    );

    final res = jsonDecode(utf8.decode(response.bodyBytes));
    final List<dynamic> responseResult = res['result'];
    List<LikeInfo> likes = responseResult.map((data) => LikeInfo.fromJson(data)).toList();
    print(responseResult);
    setState(() {
      likeslist = likes;
    });
  }

}

class LikeInfo {
  int id;
  String dong;
  String neighborhoodPostCategory;
  String title;
  String content;
  String imageUrl;
  String createdAt;
  int view;
  int likeCount;
  int commentCount;



  LikeInfo({
    required this.id,
    required this.dong,
    required this.neighborhoodPostCategory,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.createdAt,
    required this.view,
    required this.likeCount,
    required this.commentCount,
  });

  factory LikeInfo.fromJson(Map<String, dynamic> json) {
    return LikeInfo(
      id: json['id'],
      dong: json['dong'],
      neighborhoodPostCategory: json['neighborhoodPostCategory'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      createdAt: json['createdAt'],
      view: json['view'],
      likeCount: json['likeCount'],
      commentCount: json['commentCount'],
    );
  }
}
