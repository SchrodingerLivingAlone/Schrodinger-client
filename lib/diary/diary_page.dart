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

    // getPost();
  }

  // Future<void> getPost() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? accessToken = prefs.getString('accessToken');
  //   String url = '${dotenv.env['BASE_URL']}/api/neighborhood/posts/10';
  //
  //   final response = await http.get(
  //       Uri.parse(url),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $accessToken'
  //       }
  //   );
  //
  //   final res = jsonDecode(utf8.decode(response.bodyBytes));
  //
  //   final responseResult = res['result'];
  //   print(res);
  //   List<Post> posts = responseResult.map((data) => Post.fromJson(data)).toList();
  //   print(posts);
  //   setState(() {
  //     postList = posts;
  //   });
  // }
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
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                              child: SizedBox(width: 400,
                                  child: Divider(color: Colors.grey, thickness: 1.0)),
                            ),
                            Container(
                              child: ListView(
                                shrinkWrap : true,
                                physics : const NeverScrollableScrollPhysics(),
                                children: getContent(),
                              ),
                            )
                          ]
                      )
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
            child:
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                suffixIcon: Icon(Icons.star),
                labelText: '댓글을 입력하세요.',
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
  String dong;
  String neighborhoodPostCategory;
  String title;
  String content;
  List<String> imageUrls;
  String createdAt;
  String calculatedTime;
  int view;
  int likeCount;
  int commentCount;
  List<Map<String, String?>> comments;



  Post({
    required this.id,
    required this.dong,
    required this.neighborhoodPostCategory,
    required this.title,
    required this.content,
    required this.imageUrls,
    required this.createdAt,
    required this.calculatedTime,
    required this.view,
    required this.likeCount,
    required this.commentCount,
    required this.comments
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      dong: json['dong'],
      neighborhoodPostCategory: json['neighborhoodPostCategory'],
      title: json['title'],
      content: json['content'],
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      createdAt: json['createdAt'],
      calculatedTime: json['calculatedTime'],
      view: json['view'],
      likeCount: json['likeCount'],
      commentCount: json['commentCount'],
      comments: List<Map<String, String?>>.from(json['comments'] ?? []).map((comment) {
        return {
          'nickname': comment['nickname'],
          'comment': comment['comment'],
          'profile_image': comment['profile_image'],
        };
      }).toList(),
    );
  }



}

class Comment {
  final String username;
  final String text;

  Comment({required this.username, required this.text});
}

List<Comment> comments = [
  Comment(username: 'User1', text: '첫 번째 댓글입니다.'),
  Comment(username: 'User2', text: '두 번째 댓글입니다.'),
  Comment(username: 'User3', text: '세 번째 댓글입니다.'),
  Comment(username: 'User4', text: '네 번째 댓글입니다.'),
  Comment(username: 'User5', text: '다섯 번째 댓글입니다.'),
  // 여기에 필요한 만큼 댓글을 추가할 수 있습니다.
];


List<Widget> getContent(){
  List<Widget> tiles = [];
  for (var comment in comments) {
    tiles.add(Row(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(),
        ),
        const Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('nickname', style: TextStyle(fontSize: 10),),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('comment', style: TextStyle(fontSize: 15),),
                ],
              ),
            ],
          ),
        ),
        TextButton(onPressed: (){}, child: const Text('삭제')),
      ],

    ));
  }
  return tiles;
}

