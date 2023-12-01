import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:schrodinger_client/town_info/category_dropdown.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FoodInfoPage extends StatefulWidget {
  const FoodInfoPage({super.key});

  @override
  State<FoodInfoPage> createState() => _FoodInfoPageState();
}

class _FoodInfoPageState extends State<FoodInfoPage> {

  late List<Foods> foodList = [];

  @override
  void initState() {
    super.initState();
    getFoodPost();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const CategoryDropdown(),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: ListTile(
            title: foodList.isNotEmpty ? Text(foodList[1].title) : null,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Text(foodList[1].content,
                  style: TextStyle(fontSize: 12),),
                SizedBox(height: 5),
                Row(
                  children: [
                    Text('전농동'),
                    SizedBox(width: 10),
                    Text('4분 전'),
                    SizedBox(width: 10),
                    Text('조회 46'),
                  ],
                ),

              ],
            ),
            trailing: Column(
              children: [
                Image.network('https://schrodinger-cau.s3.ap-northeast-2.amazonaws.com/5789760b-6a2e-4731-baea-2d96691a6c7c.png', width: 60, height: 40,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      // 이미지 로드 완료됨
                      return child;
                    } else {
                      // 이미지 로드 중
                      return const CircularProgressIndicator(); // 로딩 중 표시할 위젯
                    }
                  },
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return Image.asset('assets/card.png'); // 오류 발생 시 기본 이미지
                  },
                ),
                Text('댓글 3 공감 5', style: TextStyle(fontSize: 11))
              ],
            ),
            onTap: () {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: ListTile(
            title: const Text('내가 생각한 맛집 어디???'),
            subtitle: const Text('유명한 백미당에 가봤는데 후기에서 봤던거랑 다르게...'),
            trailing: const Icon(Icons.square, size: 50, color: Colors.red),
            onTap: () {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: ListTile(
            title: const Text('내가 생각한 맛집 어디???'),
            subtitle: const Text('유명한 백미당에 가봤는데 후기에서 봤던거랑 다르게...'),
            trailing: const Icon(Icons.square, size: 50, color: Colors.red),
            onTap: () {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: ListTile(
            title: const Text('내가 생각한 맛집 어디???'),
            subtitle: const Text('유명한 백미당에 가봤는데 후기에서 봤던거랑 다르게...'),
            trailing: const Icon(Icons.square, size: 50, color: Colors.red),
            onTap: () {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: ListTile(
            title: const Text('내가 생각한 맛집 어디???'),
            subtitle: const Text('유명한 백미당에 가봤는데 후기에서 봤던거랑 다르게...'),
            trailing: const Icon(Icons.square, size: 50, color: Colors.red),
            onTap: () {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: ListTile(
            title: const Text('내가 생각한 맛집 어디???'),
            subtitle: const Text('유명한 백미당에 가봤는데 후기에서 봤던거랑 다르게...'),
            trailing: const Icon(Icons.square, size: 50, color: Colors.red),
            onTap: () {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: ListTile(
            title: const Text('내가 생각한 맛집 어디???'),
            subtitle: const Text('유명한 백미당에 가봤는데 후기에서 봤던거랑 다르게...'),
            trailing: const Icon(Icons.square, size: 50, color: Colors.red),
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Future<void> getFoodPost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    String url = '${dotenv.env['BASE_URL']}/api/neighborhood/posts?sortBy=0&category=0';

    final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        }
    );

    final res = jsonDecode(utf8.decode(response.bodyBytes));
    final List<dynamic> responseResult = res['result'];
    List<Foods> foods = responseResult.map((data) => Foods.fromJson(data)).toList();

    setState(() {
      foodList = foods;
    });
  }
}

class Foods {
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



  Foods({
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

  factory Foods.fromJson(Map<String, dynamic> json) {
    return Foods(
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
