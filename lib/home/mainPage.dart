import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:schrodinger_client/post/post_info.dart';
import 'package:schrodinger_client/post/post_page.dart';
import 'package:schrodinger_client/style.dart';
import 'package:schrodinger_client/home/hotplace.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../town_info/food_info.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  String schrodinger = "Schrodinger's Living Alone";
  late List<TownInfo> hottestPlace = [];

  @override
  void initState() {
    super.initState();
    initHome();
  }

  void initHome() async {
    await getHotPlaces();
    setState(()  {

    });
  }

  //인기글 Api 통신 함수
  Future<void> getHotPlaces() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    String url = '${dotenv.env['BASE_URL']}/api/neighborhood/posts?sortBy=3&category=3';

    final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        }
    );

    final res = jsonDecode(utf8.decode(response.bodyBytes));
    print(res['result']);
    final List<dynamic> responseResult = res['result'];
    List<TownInfo> hotplaces = responseResult.map((data) => TownInfo.fromJson(data)).toList();

    setState(() {
      hottestPlace = hotplaces.sublist(0, 3);
    });
  }

  //인기글 위젯 생성 함수
  Widget buildHotPlace(BuildContext context, TownInfo hotplace) {
    return InkWell(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostInfo(PostId: hotplace.id),
          ),
        );
        setState(() {
          initHome();
        });
      },
      child: Container(
        width: 130,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: NetworkImage(hotplace.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                hotplace.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.comment,
                  size: 16.0,
                  color: Colors.grey,
                ),
                const SizedBox(width: 5.0),
                Text(
                  '${hotplace.commentCount}개 댓글',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0,
                  ),
                ),
                const SizedBox(width: 15.0),
                const Icon(
                  Icons.remove_red_eye,
                  size: 16.0,
                  color: Colors.grey,
                ),
                const SizedBox(width: 5.0),
                Text(
                  '${hotplace.view}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 7,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColor.main,
            title: Text(schrodinger),
          ),
          body: Column(
            children: [
              const SizedBox(
                child: Text('가계부 예산 부분'),
              ),
              const SizedBox(
                child: Text('가계부 그래프 부분'),
              ),
              Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 8, 8, 0),
                      child: Row(
                          children : [
                            Icon(Icons.local_fire_department, color: Colors.red,),
                            Text('오늘의 인기글'),
                          ]
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: hottestPlace.map((data) {
                            return buildHotPlace(context, data);
                          }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}


