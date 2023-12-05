import 'dart:core';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:schrodinger_client/post/post_adjust.dart';

//TODO 1.게시글 수정 로직 추가
//TODO 2.게시글 삭제 로직 추가
//TODO 3.댓글 입력창
//TODO 4.댓글 ui -> 삭제, 수정가능하도록 ListTile이 아닌 widget으로 바꿔보기

class PostInfo extends StatefulWidget {
  const PostInfo({super.key});

  @override
  State<PostInfo> createState() => _PostInfoState();
}

class _PostInfoState extends State<PostInfo> {
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
                             child: const CircleAvatar(
                               backgroundColor: Colors.grey,
                               //backgroundImage: ,
                             ),
                           ),
                         ),
                         const Column(
                           children: [
                             Text('nicknamePosition', style: TextStyle(fontSize: 20),),
                             Text('5분전 | 조회 46 | 전눙동 '),
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
                             child: const Text('IssuePos', style: TextStyle(fontSize: 13),)
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
                    child: Container(child: const Text('TitlePosition', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 2.0),
                    child: Container(child: const Text('contentPosition', style: TextStyle(fontSize: 20),)),
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
                                const Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.pin_drop_outlined, color: Colors.deepPurple, size: 20,),
                                        Text('위치', style: TextStyle(color: Colors.deepPurple, fontSize: 15),),
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
