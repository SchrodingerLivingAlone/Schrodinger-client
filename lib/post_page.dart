import 'package:flutter/material.dart';
import 'package:schrodinger_client/style.dart';

//1.주제 누르면 하나만 선택되게 (색바꾸기)
//2.주제, 내용 입력받기
//3.이미지 GridView 갯수만큼만 띄우기
//4.장소

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.black
        ),
        backgroundColor: Colors.white,
        title: const Center(
            child: Text('새 게시물', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shadowColor: Colors.transparent,
            ),
            onPressed: (){
              //
              //글 객체 생성해서 맞는 자료구조(배열)에 추가하기
              //자료구조는 규한이랑 얘기해보기
              //
              Navigator.pop(context);
            },
            child: const Text('등록',
              style: TextStyle(
                color: AppColor.yellow,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: ListView(

          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 0, 5),
              child: Container(
                  child: Text('주제', style: TextStyle(fontSize: 15,color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: (){},
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        minimumSize: Size(30, 30),
                        primary: Colors.grey, elevation: 10),
                    child: Text('맛집', style: TextStyle(fontSize: 13),)
                ),
                ElevatedButton(onPressed: (){},
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        minimumSize: Size(30, 30),
                        primary: Colors.grey, elevation: 10),
                    child: Text('시설', style: TextStyle(fontSize: 13),)
                ),
                ElevatedButton(onPressed: (){},
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        minimumSize: Size(30, 30),
                        primary: Colors.grey, elevation: 10),
                    child: Text('할인', style: TextStyle(fontSize: 13),)
                ),
                ElevatedButton(onPressed: (){},
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        minimumSize: Size(30, 30),
                        primary: Colors.grey, elevation: 10),
                    child: Text('기타', style: TextStyle(fontSize: 13),)
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: (){},
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        minimumSize: Size(30, 30),
                        primary: Colors.grey, elevation: 10),
                    child: Text('같이해요', style: TextStyle(fontSize: 13),)
                ),
                ElevatedButton(onPressed: (){},
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        minimumSize: Size(30, 30),
                        primary: Colors.grey, elevation: 10),
                    child: Text('질문/요청', style: TextStyle(fontSize: 13),)
                ),
                ElevatedButton(onPressed: (){},
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        minimumSize: Size(30, 30),
                        primary: Colors.grey, elevation: 10),
                    child: Text('공공정보', style: TextStyle(fontSize: 13),)
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 10, 10),
              child: Stack(
                children: [
                  Container(

                  ),
                  Column(
                    children: [
                      ElevatedButton(onPressed: (){},
                          style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              minimumSize: Size(30, 30),
                              primary: Colors.grey, elevation: 10,
                              backgroundColor: Colors.white,
                          ),
                          child: Text('+', style: TextStyle(color: Colors.black,fontSize: 20),)
                      ),
                      Text('0/5', style: TextStyle(fontSize: 15),),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 0, 5),
              child: Container(
                child: Text('제목', style: TextStyle(fontSize: 15,color: Colors.grey, fontWeight: FontWeight.bold)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Container( height:1.0,
                width:500.0,
                color:Colors.black,),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 0, 5),
              child: Container(
                child: Text('내용을 입력하세요', style: TextStyle(fontSize: 15,color: Colors.grey, fontWeight: FontWeight.bold)),
              ),
            ),
          ],//children
        ),
      ),
    );
  }
}