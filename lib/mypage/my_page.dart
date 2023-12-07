import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final int _selectedIndex=3;
  bool isCompleted = false;

  //추가하는 부분
  late List<ProfileResponse> GetAllList = []; //맨처음에 get으로 받아온거

  @override
  void initState() {
    super.initState();
    getAll();
  }

  //이거 서버에서 받아와야함 원래
  // String nickname='dooly22';
  //String ageGender='20대/여';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('마이페이지')),
        backgroundColor: const Color(0xFF0010A3),
        actions: [
          IconButton(onPressed: (){
          }, icon:const Icon(Icons.settings)),
        ],
      ),

      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Container(
              color: const Color(0xFFFFD300), // 노란색 타일
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(//유저 프로필사진 삽입
                        padding: const EdgeInsets.all(10),
                        width: 100,
                        height: 100,
                        child: _buildProfileImage(),
                      ),
                      const SizedBox(width: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            GetAllList.isNotEmpty ? GetAllList[0].result.nickname :'',
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          // Text(
                          //   ageGender,
                          //   style: const TextStyle(fontSize: 18),
                          // ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context,'/ManageProfiles',
                            arguments: {
                              'nickname': GetAllList.isNotEmpty ? GetAllList[0].result.nickname : '',
                              //'ageGender' : ageGender,
                            }
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF800080),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                      child: const Text(
                        '프로필 관리',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text('동네정보',style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),

          const SizedBox(
            height:10,
          ),

          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.red, // 아이콘 색깔 조절
              child: Icon(Icons.border_color),
            ),
            title: const Text('작성한 글'),
            onTap: () {
              Navigator.pushNamed(context, '/WrittenPage');
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.yellow, // 아이콘 색깔 조절
              child: Icon(Icons.whatshot),
            ),
            title: const Text('스크랩 글'),
            onTap: () {

            },
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.green, // 아이콘 색깔 조절
              child: Icon(Icons.thumb_up),
            ),
            title: const Text('공감한 글'),
            onTap: () {

            },
          ),

          const SizedBox(
            height:10,
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text('기타',style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),

          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.purple, // 아이콘 색깔 조절
              child: Icon(Icons.room),
            ),
            title: const Text('동네 인증'),
            onTap: () {},
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