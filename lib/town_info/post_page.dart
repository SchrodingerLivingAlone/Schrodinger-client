import 'package:flutter/material.dart';
import 'package:schrodinger_client/style.dart';

//1.등록하면 글 객체 생성
//2.이미지 GridView 갯수만큼만 띄우기
//3.장소

enum Issue {Restaurant, Facility, Discount, Etc, Together, Ask, PublicInfo}

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {

  Issue _issue = Issue.Restaurant;
  String selectedButton = 'Button 1';

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  void selectButton(String buttonName) {
    setState(() {
      selectedButton = buttonName;
    });
  }
  Color getButtonColor(String buttonName) {
    return selectedButton == buttonName ? Colors.orange : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            iconTheme: const IconThemeData(
            color: Colors.black
        ),
        leading:  IconButton(
          onPressed: () {
            showExitConfirmationDialog(context);

          },
          color: Colors.purple,
          icon: Icon(Icons.arrow_back)),
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
                ElevatedButton(onPressed: (){
                    selectButton('Button 1');
                    _issue = Issue.Restaurant;
                  },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        minimumSize: Size(30, 30),
                        primary: getButtonColor('Button 1'),
                        elevation: 10
                    ),
                    child: Text('맛집', style: TextStyle(fontSize: 13),)
                ),
                ElevatedButton(onPressed: (){
                  selectButton('Button 2');
                  _issue = Issue.Facility;
                },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        minimumSize: Size(30, 30),
                        primary: getButtonColor('Button 2'),
                        elevation: 10),
                    child: Text('시설', style: TextStyle(fontSize: 13),)
                ),
                ElevatedButton(onPressed: (){
                  selectButton('Button 3');
                  _issue = Issue.Discount;
                },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        minimumSize: Size(30, 30),
                        primary: getButtonColor('Button 3'),
                        elevation: 10),
                    child: Text('할인', style: TextStyle(fontSize: 13),)
                ),
                ElevatedButton(onPressed: (){
                  selectButton('Button 4');
                  _issue = Issue.Etc;
                  },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        minimumSize: Size(30, 30),
                        primary: getButtonColor('Button 4'),
                        elevation: 10),
                    child: Text('기타', style: TextStyle(fontSize: 13),)
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: (){
                  selectButton('Button 5');
                  _issue = Issue.Together;
                },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        minimumSize: Size(30, 30),
                        primary: getButtonColor('Button 5'),
                        elevation: 10),
                    child: Text('같이해요', style: TextStyle(fontSize: 13),)
                ),
                ElevatedButton(onPressed: (){
                  selectButton('Button 6');
                  _issue = Issue.Ask;
                },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        minimumSize: Size(30, 30),
                        primary: getButtonColor('Button 6'),
                        elevation: 10),
                    child: Text('질문/요청', style: TextStyle(fontSize: 13),)
                ),
                ElevatedButton(onPressed: (){
                  selectButton('Button 7');
                  _issue = Issue.PublicInfo;
                },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        minimumSize: Size(30, 30),
                        primary: getButtonColor('Button 7'),
                        elevation: 10),
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
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 5),
              child: Container(
                child: TextField(
                  maxLines: null,
                  maxLength: 30,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '제목을 입력하세요.'
                  ),
                  controller: _titleController,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Container( height:1.0,
                width:500.0,
                color:Colors.black,),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 5),
              child: Container(
                child: TextField(
                  maxLines: null,
                  maxLength: 200,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '내용을 입력하세요',
                  ),
                  controller: _contentController,
                ),
              ),
            ),
          ],//children
        ),
      ),
    );
  }
}

Future<bool?> showExitConfirmationDialog(BuildContext context) async {
  return showDialog<bool?>(
    context: context,
    builder: (context) => AlertDialog(
      content: Text('작성중인 글을 취소하시겠습니까?\n작성 취소 시, 작성된 글은 저장되지 않습니다.', style: TextStyle(fontSize: 15),),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('계속 작성', style: TextStyle(color: Colors.blue),),
        ),
        TextButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(true),
          child: Text('작성 취소', style: TextStyle(color: Colors.red),),
        ),
      ],
    ),
  );
}
