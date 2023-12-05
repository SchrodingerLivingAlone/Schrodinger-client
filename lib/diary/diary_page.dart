import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:schrodinger_client/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {

  int current = 0;
  final CarouselController _carouselController = CarouselController();
  final imageList = [
    "https://capstoneroomof.s3.ap-northeast-2.amazonaws.com/Image/lhs3.jpgb449133c-4efa-41de-b9d0-bf15dff2c805",
    "https://capstoneroomof.s3.ap-northeast-2.amazonaws.com/Image/lhs3.jpgb449133c-4efa-41de-b9d0-bf15dff2c805",
    "https://schrodinger-cau.s3.ap-northeast-2.amazonaws.com/2509b321-65ce-4fa9-9112-06af0e367e5d.png"
  ];
  bool isScrapped = false;
  bool isLiked = false;
  final _commentController = TextEditingController();
  late List<Post> postList = [];

  @override
  void initState(){
    super.initState();

    getPost();
  }

  Future<void> getPost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    String url = '${dotenv.env['BASE_URL']}/api/diary';

    final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        }
    );

    final res = jsonDecode(utf8.decode(response.bodyBytes));
    final List<dynamic> responseResult = res['result'];
    List<Post> posts = responseResult.map((data) => Post.fromJson(data)).toList();
    setState(() {
      postList = posts;
    });
  }

  Widget sliderWidget () {
    return CarouselSlider (
      carouselController: _carouselController,
      items: imageList.map(
            (imgLink) {
          return Builder(
            builder: (context) {
              return SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Image(
                  fit: BoxFit.contain,
                  image: NetworkImage(
                    imgLink,
                  ),
                ),
              );
            },
          ); // Builder
        },
      ).toList (),
      options: CarouselOptions (
        height: 300,
        viewportFraction: 1.0,
        autoPlay: false,
        autoPlayInterval: const Duration (seconds: 4),
        onPageChanged: (index, reason) {
          setState(() {
            current = index;
          });
        },
      ),
    );
  }//

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft:Radius.circular(30), topRight:Radius.circular(30))
      ),
      // backgroundColor: AppColor.main,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.main,
                      borderRadius: BorderRadius.only(topLeft:Radius.circular(30), topRight:Radius.circular(30))
                  ),
                  height: 70,
                  constraints: BoxConstraints(minWidth: 500, minHeight: 70),
                  child: Center(
                    child: Text('댓글',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        )
                    ),
                  )

                  // color: AppColor.main,
                ),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 15.0, 8.0),
                          child: Container(
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage("https://capstoneroomof.s3.ap-northeast-2.amazonaws.com/Image/lhs3.jpgb449133c-4efa-41de-b9d0-bf15dff2c805"),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('nickname',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight:
                                    FontWeight.bold
                                )
                            ),
                            SizedBox(height: 5),
                            Container(
                              width: 320,
                              child: Text(
                                'xt ttext text textxt text text text textxt text text text textxt t text xt text text textxt t text xt text text textxt t text xt text text textxt t text',
                              ),
                            )
                          ],
                        )
                      ],
                    )
                ),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 15.0, 8.0),
                          child: Container(
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage("https://capstoneroomof.s3.ap-northeast-2.amazonaws.com/Image/lhs3.jpgb449133c-4efa-41de-b9d0-bf15dff2c805"),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('nickname',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight:
                                    FontWeight.bold
                                )
                            ),
                            SizedBox(height: 5),
                            Container(
                              width: 320,
                              child: Text(
                                'xt ttext text textxt text text text textxt text text text textxt t text xt text text textxt t text xt text text textxt t text xt text text textxt t text',
                              ),
                            )
                          ],
                        )
                      ],
                    )
                ),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 15.0, 8.0),
                          child: Container(
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage("https://capstoneroomof.s3.ap-northeast-2.amazonaws.com/Image/lhs3.jpgb449133c-4efa-41de-b9d0-bf15dff2c805"),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('nickname',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight:
                                    FontWeight.bold
                                )
                            ),
                            SizedBox(height: 5),
                            Container(
                              width: 320,
                              child: Text(
                                'xt ttext text textxt text text text textxt text text text textxt t text xt text text textxt t text xt text text textxt t text xt text text textxt t text',
                              ),
                            )
                          ],
                        )
                      ],
                    )
                ),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 15.0, 8.0),
                          child: Container(
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage("https://capstoneroomof.s3.ap-northeast-2.amazonaws.com/Image/lhs3.jpgb449133c-4efa-41de-b9d0-bf15dff2c805"),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('nickname',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight:
                                    FontWeight.bold
                                )
                            ),
                            SizedBox(height: 5),
                            Container(
                              width: 320,
                              child: Text(
                                'xt ttext text textxt text text text textxt text text text textxt t text xt text text textxt t text xt text text textxt t text xt text text textxt t text',
                              ),
                            )
                          ],
                        )
                      ],
                    )
                ),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 15.0, 8.0),
                          child: Container(
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage("https://capstoneroomof.s3.ap-northeast-2.amazonaws.com/Image/lhs3.jpgb449133c-4efa-41de-b9d0-bf15dff2c805"),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('nickname',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight:
                                    FontWeight.bold
                                )
                            ),
                            SizedBox(height: 5),
                            Container(
                              width: 320,
                              child: Text(
                                'xt ttext text textxt text text text textxt text text text textxt t text xt text text textxt t text xt text text textxt t text xt text text textxt t text',
                              ),
                            )
                          ],
                        )
                      ],
                    )
                ),
              ],
            ),
          );
      },
    );
  }


  Widget sliderIndicator() {
    return Align(
      alignment: Alignment. bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment. center,
        children: imageList.asMap().entries.map((entry){
          return GestureDetector(
            onTap: () => _carouselController.animateToPage(entry.key),
            child: Container(
              width: 12,
              height: 12,
              margin:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(current == entry.key ? 0.9 : 0.4),),
            ),
          );// GestureDetector
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
              color: Colors.black
          ),
          leading: IconButton(
              onPressed: (){},
              color: Colors.white,
              icon: const Icon(Icons.add_circle_outline)
          ),
          backgroundColor: AppColor.main,
          title: const Center(
              child: Text('자취일기', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          actions: [
            IconButton(
                onPressed: (){},
                color: Colors.white,
                icon: const Icon(Icons.search)
            ),
          ],
        ),
      body: Column(
        children : [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 15.0, 8.0),
                              child: Container(
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  backgroundImage: NetworkImage("https://capstoneroomof.s3.ap-northeast-2.amazonaws.com/Image/lhs3.jpgb449133c-4efa-41de-b9d0-bf15dff2c805"),
                                ),
                              ),
                            ),
                            const Text('nickname',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight:
                                    FontWeight.bold
                                )
                            ),
                          ],
                        ),
                        IconButton(
                            onPressed: (){},
                            icon: const Icon(Icons.more_horiz)
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        sliderWidget(),
                        sliderIndicator(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: (){
                                setState(() {
                                  isLiked = !isLiked;
                                });
                              },
                              icon: isLiked ? const Icon(Icons.favorite, color: Colors.red,) : const Icon(Icons.favorite_border_outlined),
                            ),
                            IconButton(
                              onPressed: (){},
                              icon: const Icon(Icons.mode_comment_outlined),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: (){
                            setState(() {
                              isScrapped = !isScrapped; // 버튼 클릭 시 상태 변경
                            });
                          },
                          icon: isScrapped ? const Icon(Icons.bookmark) : const Icon(Icons.bookmark_outline),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical:0, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('좋아요 23개', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Text('nickname 오늘 저녁은 간단하게 볶음밥 하루한끼 유튜브는 자취생활의 그저goat.. ...더보기'),
                        TextButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                          ),
                          onPressed: () {
                            _showBottomSheet(context);
                          },
                          child: Text('댓글 8개 모두 보기', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                        ),
                        Text('4분 전', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )

    );
  }

}

class Post {
  int id;
  String content;
  List<String> imageUrls;
  String createdAt;
  String calculatedTime;
  int likeCount;
  int commentCount;
  List<Map<String, String?>> comments;



  Post({
    required this.id,
    required this.content,
    required this.imageUrls,
    required this.createdAt,
    required this.calculatedTime,
    required this.likeCount,
    required this.commentCount,
    required this.comments
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      content: json['content'],
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      createdAt: json['createdAt'],
      calculatedTime: json['calculatedTime'],
      likeCount: json['likeCount'],
      commentCount: json['commentCount'],
      comments: List<Map<String, dynamic>>.from(json['comments'] ?? []).map((comment) {
        return {
          'nickname': comment['nickname'].toString(),
          'comment': comment['comment'].toString(),
          'profile_image': comment['profile_image'].toString(),
        };
      }).toList(),
    );
  }



}
//
// class Comment {
//   final String nickname;
//   final String comment;
//   final String profile_image;
//
//   Comment({required this.nickname, required this.comment, required this.profile_image});
// }