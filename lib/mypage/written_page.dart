import 'package:flutter/material.dart';

class WrittenPage extends StatefulWidget {
  const WrittenPage({super.key});

  @override
  State<WrittenPage> createState() => _WrittenPageState();
}

class _WrittenPageState extends State<WrittenPage> {

  List<PostResponseDTO> posts = [
    PostResponseDTO(
      title: 'Post 1',
      content: 'Content of Post 1',
      author: 'Author 1',
      time: '10:00 AM',
      views: 100,
      comments: 20,
      likes: 50,
      imageUrl: 'url_of_image_1',
    ),
    PostResponseDTO(
      title: 'Post 2',
      content: 'Content of Post 2',
      author: 'Author 2',
      time: '11:30 AM',
      views: 150,
      comments: 30,
      likes: 70,
      imageUrl: 'url_of_image_2',
    ),

  ];


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
  String title;
  String content;
  String author;
  String time;
  int views;
  int comments;
  int likes;
  String imageUrl;

  PostResponseDTO({
    required this.title,
    required this.content,
    required this.author,
    required this.time,
    required this.views,
    required this.comments,
    required this.likes,
    required this.imageUrl,
  });
}