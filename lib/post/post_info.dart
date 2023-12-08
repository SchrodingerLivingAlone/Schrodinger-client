import 'dart:convert';
import 'dart:core';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  String writerProfileImage  = ' ';
  String createdTime  = ' ';
  int view = 0;
  String issue = ' ';
  String pos = ' ';
  String dong = ' ';
  String title = ' ';
  bool owner = false;
  String content = ' ';
  bool isScrapped = false;
  bool isLiked = false;
  var imageList = [];
  int current = 0;
  List<dynamic> comments = [];
  final _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String postDetails = ' ';

  String currentProfileImage = ' ';

  final CarouselController _carouselController = CarouselController();

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

  Future<void> getCurrentProfile(BuildContext context) async {
    var url = '${dotenv.env['BASE_URL']}/api/users/profile';
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
        CurProfileResponse curProfileResponse = CurProfileResponse.fromJson(jsonDecode(temp));
        currentProfileImage = curProfileResponse.result['profileImageUrl'];
      } else {
        print(response.statusCode);
        throw Exception('Failed to load data1: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data2: $e');
    }
  }

  Future<CommentResponse> addComment(BuildContext context) async {
    int postId = widget.PostId;
    print(postId);
    var url = '${dotenv.env['BASE_URL']}/api/comments/$postId';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    try {
      final response = await http.post(
          Uri.parse(url),
          headers: {
            'Authorization' : 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
          body: json.encode({'comment' : _commentController.text}),
      );


      var temp = utf8.decode(response.bodyBytes);
      print(temp);
      if (response.statusCode == 200) {
        print('Response Body: ${temp}');
        return CommentResponse.fromJson(jsonDecode(temp));
      } else {
        print(response.statusCode);
        throw Exception('Failed to load data1: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data2: $e');
    }
  }

  void likePost(BuildContext context) async {
    int postId = widget.PostId;
    var url = '${dotenv.env['BASE_URL']}/api/likes/$postId';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization' : 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );


      var temp = utf8.decode(response.bodyBytes);
      print(temp);
      if (response.statusCode == 200) {
        print('Response Body: ${temp}');
      } else {
        print(response.statusCode);
        throw Exception('Failed to load data1: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data2: $e');
    }
  }

  void scrapPost(BuildContext context) async {
    int postId = widget.PostId;
    var url = '${dotenv.env['BASE_URL']}/api/scraps/$postId';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization' : 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      var temp = utf8.decode(response.bodyBytes);
      print(temp);
      if (response.statusCode == 200) {
        print('Response Body: ${temp}');
      } else {
        print(response.statusCode);
        throw Exception('Failed to load data1: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data2: $e');
    }
  }

  void deleteComment(BuildContext context, int commentId) async {
    var url = '${dotenv.env['BASE_URL']}/api/comments/$commentId';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization' : 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      var temp = utf8.decode(response.bodyBytes);
      print(temp);
      if (response.statusCode == 200) {
        print('Response Body: ${temp}');
      } else {
        print(response.statusCode);
        throw Exception('Failed to load data1: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data2: $e');
    }
  }

  void deletePost(BuildContext context, int postId) async {
    var url = '${dotenv.env['BASE_URL']}/api/neighborhood/posts/$postId';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization' : 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      var temp = utf8.decode(response.bodyBytes);
      print(temp);
      if (response.statusCode == 200) {
        print('Response Body: ${temp}');
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
    await getCurrentProfile(context);
    setState(()  {
      //ToDO -> 작성자 닉네임, 작성자 프로필이미지, 공유된 장소 추가로 api받기
      writer = postInfo.result['nickname'];
      int writerLen = writer.length;
      // for(int i = 25; i >= writerLen; i--)
      //   writer += ' ';
      writerProfileImage = postInfo.result['profileImage'];
      createdTime = postInfo.result['calculatedTime'];
      view = postInfo.result['view'];
      issue = postInfo.result['neighborhoodPostCategory'];
      dong = postInfo.result['dong'];
      pos = postInfo.result['place'];
      title = postInfo.result['title'];
      imageList = postInfo.result['imageUrls'];
      content = postInfo.result['content'];
      isScrapped = postInfo.result['scrapped'];
      isLiked = postInfo.result['liked'];
      comments = postInfo.result['comments'];
      owner = postInfo.result['owner'];
      postDetails = '$createdTime | 조회 $view | $dong ';
      int postDetailsLen = postDetails.length;
      // for(int i = 25; i >= postDetailsLen; i--)
      //   postDetails += ' ';
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
           Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(comment['profile_image']),
            ),
          ),
           Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(comment['nickname'], style: TextStyle(fontSize: 10),),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(comment['comment'], style: TextStyle(fontSize: 15),),
                  ],
                ),
              ],
            ),
          ),
          TextButton(
              onPressed: (){
                if(comment['owner']){
                  checkDeleteComment(context, comment['id']);
                }else{
                  showNotCommentOwner(context);
                }
              },
              child: const Text('삭제')
          ),
        ],

      ));
    }
    return tiles;
  }

  Future<bool?> checkDeleteComment(BuildContext context, int commentId) async {
    return showDialog<bool?>(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('댓글을 삭제하시겠습니까?', style: TextStyle(fontSize: 15),),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              deleteComment(context, commentId);
              initPost();
              Navigator.of(context).pop(false);
              },
            child: const Text('확인', style: TextStyle(color: Colors.blue),),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소', style: TextStyle(color: Colors.blue),),
          ),
        ],
      ),
    );
  }

  Future<bool?> showNotCommentOwner(BuildContext context) async {
    return showDialog<bool?>(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('본인이 작성한 댓글이 아닙니다.', style: TextStyle(fontSize: 15),),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('확인', style: TextStyle(color: Colors.blue),),
          ),
        ],
      ),
    );
  }

  Future<bool?> showNotPostOwner(BuildContext context) async {
    return showDialog<bool?>(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('본인이 작성한 글이 아닙니다.', style: TextStyle(fontSize: 15),),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('확인', style: TextStyle(color: Colors.blue),),
          ),
        ],
      ),
    );
  }

  Future<bool?> deleteSuccess(BuildContext context) async {
    return showDialog<bool?>(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('성공적으로 글을 삭제하였습니다.', style: TextStyle(fontSize: 15),),
        actions: <Widget>[
          TextButton(
            onPressed: () { Navigator.of(context).pop(true); Navigator.of(context).pop(true);},
            child: const Text('확인', style: TextStyle(color: Colors.blue),),
          ),
        ],
      ),
    );
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
                  // const PopupMenuItem(
                  //   value: 'edit',
                  //   child: Text('게시글 수정'),
                  // ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('게시글 삭제'),
                  ),
                ],
                elevation: 8.0,
              ).then((value) {
                if(owner){
                  if (value == 'delete') {
                    deletePost(context, widget.PostId);
                    deleteSuccess(context);
                  }
                  // else if (value == 'edit') {
                  //   Navigator.push(context, MaterialPageRoute(builder: (context) => PostAdjustPage(postId : widget.PostId)));
                  //   initPost();
                  //   print('게시글 수정');
                  // }
                }else{
                  showNotPostOwner(context);
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
                     padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                     child: Expanded(
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Row(
                             mainAxisAlignment: MainAxisAlignment.start,
                             children: [
                               Padding(
                                 padding: const EdgeInsets.fromLTRB(8.0, 0, 15.0, 0),
                                 child: Container(
                                   child:  CircleAvatar(
                                     radius: 25,
                                     backgroundColor: Colors.grey,
                                     backgroundImage: NetworkImage(writerProfileImage!),
                                   ),
                                 ),
                               ),
                               Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                       Text(writer, style: TextStyle(fontSize: 17), textAlign: TextAlign.start,),
                                       Text(postDetails),
                                 ],
                               ),
                             ],
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
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0), // 조절하고 싶은 둥근 정도
                                            ),
                                          backgroundColor: Colors.white,
                                          shadowColor: Colors.transparent,
                                        ),
                                        onPressed: (){
                                          setState(() {
                                            likePost(context);
                                            isLiked = !isLiked;
                                          });
                                        },
                                        child: Icon(Icons.thumb_up, color: isLiked ? Colors.blue : Colors.grey,),
                                        //child: const Text('공감하기', style: TextStyle(fontSize: 15, color:Colors.black),)
                                    ),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0), // 조절하고 싶은 둥근 정도
                                          ),
                                          backgroundColor: Colors.white,
                                          shadowColor: Colors.transparent,
                                        ),
                                        onPressed: (){
                                          setState(() {
                                              scrapPost(context);
                                              isScrapped = !isScrapped; // 버튼 클릭 시 상태
                                            // 변경
                                          });
                                        },
                                        child: Icon(Icons.star, color: isScrapped ? Colors.yellow : Colors.grey,),
                                        //child: const Text('스크랩', style: TextStyle(fontSize: 15, color:Colors.black),)
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
              Row(
                children: [
                  Padding(
                    padding : EdgeInsets.fromLTRB(0, 0, 8.0, 0),
                    child : CircleAvatar(
                      backgroundImage:  NetworkImage(currentProfileImage),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () async {
                          await addComment(context);
                          _commentController.clear();
                          _focusNode.unfocus();
                          initPost();
                        },
                        icon: Icon(Icons.send),),
                      labelText: '댓글을 입력하세요.',
                        
                      ),
                      controller: _commentController,
                      focusNode: _focusNode,
                    ),
                  ),
                ],
              ),
          ),
      ],
    ),
    );
  }
}

class Comment {
  final String nickname;
  final String comment;
  final String profile_image;
  final int id;
  final bool owner;

  Comment({required this.nickname, required this.comment, required this.profile_image, required this.owner, required this.id});

  Map<String, dynamic> toJson() {
    return {
      'profile_image': profile_image,
      'nickname': nickname,
      'comment': comment,
      'owner' : owner,
      'id' : id,
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        profile_image: json["profile_image"],
        nickname: json["nickname"],
        comment: json["comment"],
        owner: json["owner"],
        id : json["id"]
    );
  }
}
