import 'dart:convert';
import 'dart:core';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:schrodinger_client/post/post_adjust.dart';
import 'package:schrodinger_client/post/post_comment_response.dart';
import 'package:schrodinger_client/post/post_info_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

//TODO 1.게시글 수정 로직 추가
//TODO 2.게시글 삭제 로직 추가
//TODO 3. api 연동

class PostInfo extends StatefulWidget {
  PostInfo({Key? key, required this.PostId}) : super (key: key) ;
  int PostId;

  @override
  State<PostInfo> createState() => _PostInfoState();
}

class _PostInfoState extends State<PostInfo> {

  String writer = ' ';
  String writerProfileImage  = 'https://capstoneroomof.s3.ap-northeast-2.amazonaws.com/Image/kbs1.jpg3dc6ec35-e98b-4290-9609-8793c540fb05';
  String createdTime  = ' ';
  int view = 0;
  String issue = ' ';
  String pos = ' ';
  String title = ' ';
  String content = ' ';
  bool isScrapped = false;
  bool isLiked = false;
  var imageList = [];
  int current = 0;
  List<dynamic> comments = [];

  final CarouselController _carouselController = CarouselController();
  final _commentController = TextEditingController();

  Future<PostInfoResponse> getPostInfo(BuildContext context) async {
    int postId = widget.PostId;
    print(postId);
    var url = '${dotenv.env['BASE_URL']}/api/neighborhood/posts/$postId';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    try {
      final response = await http.get(
          Uri.parse(url),
          headers: {'Authorization' : 'Bearer $accessToken'}
      );
      var temp = utf8.decode(response.bodyBytes);
      print(temp);
      if (response.statusCode == 200) {
        print('Response Body: ${temp}');
        return PostInfoResponse.fromJson(jsonDecode(temp));
      } else {
        print(response.statusCode);
        throw Exception('Failed to load data1: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data2: $e');
    }
  }


  void initPost() async {
    var postInfo = await getPostInfo(context);
    setState(()  {
      //ToDO -> 작성자 닉네임, 작성자 프로필이미지, 공유된 장소 추가로 api받기
      writer = writer;
      writerProfileImage = writerProfileImage;
      createdTime = postInfo.result['calculatedTime'];
      view = postInfo.result['view'];
      issue = postInfo.result['neighborhoodPostCategory'];
      pos = postInfo.result['dong'];
      title = postInfo.result['title'];
      imageList = postInfo.result['imageUrls'];
      content = postInfo.result['content'];
      isScrapped = postInfo.result['scrapped'];
      isLiked = postInfo.result['liked'];
      comments = postInfo.result['comments'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPost();
  }

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
  Widget build(BuildContext context)  {

    return Scaffold(
      resizeToAvoidBottomInset: true, // true값 할당
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.black
        ),
        leading:  IconButton(
            onPressed: () => Navigator.of(context).pop(false),
            color: Colors.purple,
            icon: const Icon(Icons.arrow_back)),
        backgroundColor: Colors.white,
        title: const Center(
            child: Text('동네 정보', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
        actions: [
          IconButton(
            onPressed: () {
              // showMenu 함수를 사용하여 다이얼로그를 표시합니다.
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(1000, 0, 0, 0),
                items: [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('게시글 수정'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('게시글 삭제'),
                  ),
                ],
                elevation: 8.0,
              ).then((value) {
                // 사용자가 선택한 항목에 따라 처리합니다.
                if (value == 'edit') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PostAdjustPage()));
                  print('게시글 수정');
                } else if (value == 'delete') {
                  // 게시글 삭제 api호출.

                  print('게시글 삭제');
                }
              });
            },
            icon: const Icon(Icons.more_horiz, color: Colors.black, size: 30),
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
                       children: [
                         Padding(
                           padding: const EdgeInsets.fromLTRB(8.0, 8.0, 15.0, 8.0),
                           child: Container(
                             child:  CircleAvatar(
                               backgroundColor: Colors.grey,
                               backgroundImage: NetworkImage(writerProfileImage!),
                             ),
                           ),
                         ),
                         Column(
                           children: [
                             Text(writer, style: TextStyle(fontSize: 20),),
                             Text('$createdTime | 조회 $view | $pos '),
                           ],
                         ),
                         const SizedBox(
                           width: 80,
                         ),
                         ElevatedButton(
                             onPressed: (){},
                             style: ElevatedButton.styleFrom(
                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), backgroundColor: Colors.orange,
                                 minimumSize: const Size(30, 30),
                                 elevation: 10
                             ),
                             child:  Text(issue, style: TextStyle(fontSize: 13),)
                         ),
                       ],
                     ),
                   ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    child: SizedBox(width: 500,
                        child: Divider(color: Colors.grey, thickness: 2.0)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                    child: Container(child:  Text(title, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 2.0),
                    child: Container(child:  Text(content, style: TextStyle(fontSize: 20),)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                    child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          sliderWidget(),
                          sliderIndicator(),
                        ],
                      ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.pin_drop_outlined, color: Colors.deepPurple, size: 20,),
                                        Text(pos, style: TextStyle(color: Colors.deepPurple, fontSize: 15),),
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0), // 조절하고 싶은 둥근 정도
                                            ),
                                          backgroundColor: isLiked ? Colors.blue : Colors.white,
                                          shadowColor: Colors.transparent,
                                        ),
                                        onPressed: (){
                                          setState(() {
                                            isLiked = !isLiked;
                                          });
                                        },
                                        child: const Text('공감하기', style: TextStyle(fontSize: 15, color:Colors.black),)
                                    ),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0), // 조절하고 싶은 둥근 정도
                                          ),
                                          backgroundColor: isScrapped ? Colors.orange : Colors.white,
                                          shadowColor: Colors.transparent,
                                        ),
                                        onPressed: (){
                                          setState(() {
                                            isScrapped = !isScrapped; // 버튼 클릭 시 상태 변경
                                          });
                                        },
                                        child: const Text('스크랩', style: TextStyle(fontSize: 15, color:Colors.black),)
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
    ),
    );


  }
}

class Comment {
  final String username;
  final String text;
  final String commenterProfile;

  Comment({required this.commenterProfile, required this.username, required this.text});
}
