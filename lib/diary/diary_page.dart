import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:schrodinger_client/diary/new_diary.dart';
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
  final _commentController = TextEditingController();
  bool isScrapped = false;
  bool isLiked = false;
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

  Future<void> writeComment(int diaryId, String comment) async {
    String url = '${dotenv.env['BASE_URL']}/api/diary/comments/$diaryId';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    var body = {
      'comment': comment
    };


    final response = await http.post(
        Uri.parse(url),
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        }
    );

    if (response.statusCode == 200) {
      await getPost();
    }
  }

  Widget sliderWidget (List<String> imageUrls) {
    return CarouselSlider (
      carouselController: _carouselController,
      items: imageUrls.map(
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
  }

  Widget sliderIndicator(List<String> imageUrls) {
    return Align(
      alignment: Alignment. bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment. center,
        children: imageUrls.asMap().entries.map((entry){
          return GestureDetector(
            onTap: () => _carouselController.animateToPage(entry.key),
            child: Container(
              width: 12,
              height: 12,
              margin:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(current == entry.key ? 0.9 : 0.4),),
            ),
          );// GestureDetector
        }).toList(),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, Post post) {
    showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft:Radius.circular(30), topRight:Radius.circular(30))
      ),
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft:Radius.circular(30), topRight:Radius.circular(30))
                        ),
                        height: 70,
                        constraints: const BoxConstraints(minWidth: 500, minHeight: 70, maxHeight: 100),
                        child: const Center(
                          child: Column(
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(top: 20, bottom: 20),
                                  child: Text('댓글',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black
                                      )
                                  ),
                              ),

                              Divider(
                                color: Colors.black,
                                height: 1,
                                thickness: 0.5,
                              )
                            ]
                          ),
                        )

                        // color: AppColor.main,
                      ),
                      commentWidget(post.comments),
                    ],
                  ),
                ),
            ),


          ],
        );
      },
    );
  }

  Widget postWidget() {
    return Column(
      children: postList.map((post) => Column(
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
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(post.profileImage),
                      ),
                    ),
                    Text(post.nickname,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
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
                sliderWidget(post.imageUrls),
                sliderIndicator(post.imageUrls),
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
                      onPressed: () async {
                        setState(() {
                          isLiked = !isLiked;
                        });
                        await updateLikeStatus(post.id);
                      },
                      icon: post.liked ? const Icon(Icons.favorite, color: Colors.red,) : const Icon(Icons.favorite_border_outlined),
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
            padding: const EdgeInsets.symmetric(vertical:0, horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('좋아요 ${post.likeCount}개', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Container(
                        width: 350,
                        child: Text('${post.nickname} ${post.content}'),
                      ),
                      post.comments.isNotEmpty ?
                      TextButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                        ),
                        onPressed: post.comments.isNotEmpty ? () {
                          _showBottomSheet(context, post);
                        } : null,
                        child: post.comments.isNotEmpty ? Text('댓글 ${post.commentCount}개 모두 보기', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)) : Text(''),
                      ) : const SizedBox(height: 10),
                      Text(post.calculatedTime, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      Container(
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(right: 15.0),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage('https://schrodinger-cau.s3.ap-northeast-2.amazonaws.com/fc4b0530-dec3-435d-abf3-94142685c2fd.jpg'),
                              ),
                            ),
                            suffixIcon: IconButton(
                                onPressed: () async {
                                  await writeComment(post.id, _commentController.text);
                                  _commentController.clear();
                                  FocusScope.of(context).unfocus();
                                },
                                icon:  Icon(Icons.send),
                            ),
                            labelText: '댓글 달기...',
                          ),
                          onSubmitted: (value) async {
                            await writeComment(post.id, value);
                            _commentController.clear();
                          },
                        ),
                      ),
                      const SizedBox(height: 10),

                    ],
                  ),
                ),
              ],
            )

          ),
        ],
      )).toList()
    );
  }

  Widget commentWidget(List<Comment> comments) {
    return Column(
        children: comments.map((comment) =>
        Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 15.0, 8.0),
                child: CircleAvatar(
                  // backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(comment.profile_image),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(comment.nickname,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      )
                  ),
                  // SizedBox(height: 5),
                  Container(
                    width: 320,
                    child: Text(
                        comment.comment,
                        style: TextStyle(
                            fontSize: 16,
                        )
                    ),
                  )
                ],
              )
          ],
        )
    )).toList());
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
              color: Colors.black
          ),
          leading: IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => NewDiary()));
              },
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
                  postWidget(),
                ],
              )
            ),
          ),
        ],
      )
    );
  }

  Future<void> updateLikeStatus(int diaryId) async {
    String url = '${dotenv.env['BASE_URL']}/api/diary/likes/$diaryId';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      }
    );

    if (response.statusCode == 200) {
    await getPost();
    }
  }



}

class Post {
  int id;
  String content;
  List<String> imageUrls;
  String profileImage;
  String nickname;
  String createdAt;
  String calculatedTime;
  int likeCount;
  int commentCount;
  List<Comment> comments;
  bool liked;


  Post({
    required this.id,
    required this.content,
    required this.imageUrls,
    required this.profileImage,
    required this.nickname,
    required this.createdAt,
    required this.calculatedTime,
    required this.likeCount,
    required this.commentCount,
    required this.comments,
    required this.liked
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      content: json['content'],
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      profileImage: json['profileImage'],
      nickname: json['nickname'],
      createdAt: json['createdAt'],
      calculatedTime: json['calculatedTime'],
      likeCount: json['likeCount'],
      commentCount: json['commentCount'],
      comments: List<Map<String, dynamic>>.from(json['comments'] ?? []).map((comment) {
        return Comment(
          userId: comment['userId'].toString(),
          commentId: comment['commentId'].toString(),
          nickname: comment['nickname'].toString(),
          comment: comment['comment'].toString(),
          profile_image: comment['profile_image'].toString(),
        );
      }).toList(),
      liked: json['liked']
    );
  }
}


class Comment {
  final String userId;
  final String commentId;
  final String nickname;
  final String comment;
  final String profile_image;

  Comment({required this.userId, required this.commentId, required this.nickname, required this.comment, required this.profile_image});
}