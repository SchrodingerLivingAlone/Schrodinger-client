import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:schrodinger_client/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  bool isCompleted = false;

  late List<ProfileResponse> GetAllList = [];

  @override
  void initState() {
    super.initState();
    getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('마이페이지', style: TextStyle(fontWeight: FontWeight.bold),)),
        leading: Container(width: 50),
        backgroundColor: AppColor.main,
        actions: [
          Container(width: 50),
        ],
      ),

      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xffFFC536),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 3,
                    spreadRadius: 3,
                    offset: Offset(3, 3),
                  ),
                ],
              ), // 노란색 타일
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(40.0, 30.0, 30.0, 30.0),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey,
                          backgroundImage: GetAllList.isNotEmpty ? NetworkImage(GetAllList[0].result.profileImageUrl) : const NetworkImage('https://schrodinger-cau.s3.ap-northeast-2.amazonaws.com/istockphoto-1214428300-612x612.jpeg'),

                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            GetAllList.isNotEmpty ? GetAllList[0].result.nickname :'검색중...',
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(GetAllList.isNotEmpty ? GetAllList[0].result.dong :'검색중...',
                            style: const TextStyle(fontSize: 16))
                        ],
                      ),
                    ],
                  ),
                  // const SizedBox(height: 10),
                ],
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Text('동네정보',style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),

          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color(0xffFF6969),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 1,
                    spreadRadius: 1,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
            ),
            title: const Text('작성한 글',
                style: TextStyle(
                    fontSize: 17, fontWeight: FontWeight.bold
                )
            ),
            onTap: () {
              Navigator.pushNamed(context, '/WrittenPage');
            },
          ),
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color(0xffFFF069),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 1,
                    spreadRadius: 1,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
            ),
            title: const Text('스크랩 글',
                style: TextStyle(
                    fontSize: 17, fontWeight: FontWeight.bold
                )
            ),
            onTap: () {
              Navigator.pushNamed(context, '/CommentPage');
            },
          ),
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color(0xffABFF69),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 1,
                    spreadRadius: 1,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
            ),
            title: const Text('공감한 글',
              style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.bold
              )
            ),
            onTap: () {
              Navigator.pushNamed(context, '/LikePage');
            },
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Text('기타',style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color(0xffAB69FF),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 1,
                    spreadRadius: 1,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
            ),
            title: const Text('동네 인증',
                style: TextStyle(
                    fontSize: 17, fontWeight: FontWeight.bold
                )
            ),
            onTap: () {
              Navigator.pushNamed(context, '/Mypagetownauth');
            },

          ),
        ],
      ),
    );
  }

  Future<void> getAll() async { //프로필 받아오는거 post
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    String url = '${dotenv.env['BASE_URL']}/api/users/profile';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );

    final res = jsonDecode(utf8.decode(response.bodyBytes));

    print(res);
    print(response.statusCode);//출력해봄 한번 시험으로

    //final List<dynamic> responseResult = res['result'];
    List<ProfileResponse> getall = [ProfileResponse.fromJson(res)];

    setState(() {
      GetAllList = getall;
    });
  }

  // Widget _buildProfileImage() {  //이미지 파일 받아오는거 내 첫 시도
  //   if (GetAllList.isNotEmpty && GetAllList[0].result.profileImageUrl.isNotEmpty) {
  //     // If profileImageUrl is not empty, load the image from the server
  //     return Image.network(GetAllList[0].result.profileImageUrl);
  //   } else {
  //     // If profileImageUrl is empty or not available, you can use a default image
  //     return const Placeholder(); // Replace with your default image widget
  //   }
  // }

  Widget _buildProfileImage() {//안되서 이거로 해봤음
    if (GetAllList.isNotEmpty && GetAllList[0].result.profileImageUrl.isNotEmpty) {
      // If profileImageUrl is not empty, use FutureBuilder to load the image
      return FutureBuilder(
        future: http.get(Uri.parse(GetAllList[0].result.profileImageUrl)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            // If the Future is complete and data is available, display the image
            return Image.memory(snapshot.data!.bodyBytes);
          } else {
            // If the Future is not complete or data is not available, display a placeholder or loading indicator
            return const Placeholder(); // Replace with your default image widget or loading indicator
          }
        },
      );
    } else {
      // If profileImageUrl is empty or not available, you can use a default image
      return const Placeholder(); // Replace with your default image widget
    }
  }
  
  
}

class ProfileResponse {  //프로필 정보 받아오는 부분
  final bool isSuccess;
  final String code;
  final String message;
  final ProfileResult result;

  ProfileResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.result,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      isSuccess: json['isSuccess'],
      code: json['code'],
      message: json['message'],
      result: ProfileResult.fromJson(json['result']),
    );
  }
}

class ProfileResult {  //프로필정보에서 결과값받아오는 부분.
  final int id;
  final String dong;
  final String nickname;
  final String profileImageUrl;

  ProfileResult({
    required this.id,
    required this.dong,
    required this.nickname,
    required this.profileImageUrl,
  });

  factory ProfileResult.fromJson(Map<String, dynamic> json) {
    return ProfileResult(
      id: json['id'],
      dong: json['dong'],
      nickname: json['nickname'],
      profileImageUrl: json['profileImageUrl'],
    );
  }
}