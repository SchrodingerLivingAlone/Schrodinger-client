import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WrittenPage extends StatefulWidget {
  const WrittenPage({super.key});

  @override
  State<WrittenPage> createState() => _WrittenPageState();
}

class _WrittenPageState extends State<WrittenPage> {

  List<PostResponseDTO> posts = [
    // PostResponseDTO(
    //     id: 9,
    //     dong: "상도동",
    //     neighborhoodPostCategory: "맛집",
    //     title: "TestTitle",
    //     content: "TestContent",
    //     imageUrl: "image1.jpg",
    //     createdAt: "2023-11-27T17:26:02.243349",
    //     view: 0,
    //     likeCount: 1,
    //     commentCount: 1
    // ),
  ];

  @override
  void initState() {
    super.initState();
    // initState에서 데이터 로딩
    loadLikedPosts();
  }

  void loadLikedPosts() async {
    try {
      List<PostResponseDTO> likedPosts = await YourApiService.getLikedPosts();
      setState(() {
        posts = likedPosts;
      });
    } catch (e) {
      // 예외 처리
      print('Error loading liked posts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('작성한 글')),
        backgroundColor: Color(0xFF0010A3),
        actions: [
          IconButton(onPressed: (){
          }, icon:Icon(Icons.settings)),
        ],
      ),

      body: ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(posts[index].title),
          subtitle: Text(posts[index].content),
          onTap: () {
            // Handle post item tap
          },
        );
      },
    ),



    );
  }
}



class PostResponseDTO {
  int id;
  String dong;
  String neighborhoodPostCategory;
  String title;
  String content;
  String imageUrl;
  String createdAt;
  int view;
  int likeCount;
  int commentCount;

  PostResponseDTO({
    required this.id,
    required this.dong,
    required this.neighborhoodPostCategory,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.createdAt,
    required this.view,
    required this.likeCount,
    required this.commentCount,
  });

  PostResponseDTO.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        dong = json['dong'],
        neighborhoodPostCategory = json['neighborhoodPostCategory'],
        title = json['title'],
        content = json['content'],
        imageUrl = json['imageUrl'],
        createdAt = json['createdAt'],
        view = json['view'],
        likeCount = json['likeCount'],
        commentCount = json['commentCount'];
}

class YourApiService {
  static Future<List<PostResponseDTO>> getLikedPosts() async {
    final response = await http.get(Uri.parse('https://your-api-url/api/likes/posts'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      // 변환된 데이터를 PostResponseDTO 리스트로 매핑
      List<PostResponseDTO> posts = data.map((item) => PostResponseDTO.fromJson(item)).toList();

      return posts;
    } else {
      throw Exception('Failed to load liked posts');
    }
  }
}