import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final int _selectedIndex=3;
  bool isCompleted = false;


  //이거 디비에서 받아와야함 원래
  String nickname='dooly22';
  String ageGender='20대/여';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('마이페이지')),
        backgroundColor: const Color(0xFF0010A3),
        actions: [
          IconButton(onPressed: (){
          }, icon:const Icon(Icons.settings)),
        ],
      ),

      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Container(
              color: const Color(0xFFFFD300), // 노란색 타일
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        // child: Image(
                        //   image: AssetImage(
                        //
                        //   ),
                        //   width: 100,
                        //   height: 100,
                        // ),
                        width: 100,
                        height:100,

                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue, // Add your image or change the color
                        ),
                      ),
                      const SizedBox(width: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nickname,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            ageGender,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context,'/ManageProfiles',
                            arguments: {
                              'nickname': nickname,
                              'ageGender' : ageGender,
                            }
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF800080),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                      child: const Text(
                        '프로필 관리',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text('동네정보',style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),

          const SizedBox(
            height:10,
          ),

          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.red, // 아이콘 색깔 조절
              child: Icon(Icons.border_color),
            ),
            title: const Text('작성한 글'),
            onTap: () {
              Navigator.pushNamed(context, '/WrittenPage');
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.yellow, // 아이콘 색깔 조절
              child: Icon(Icons.whatshot),
            ),
            title: const Text('스크랩 글'),
            onTap: () {

            },
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.green, // 아이콘 색깔 조절
              child: Icon(Icons.thumb_up),
            ),
            title: const Text('공감한 글'),
            onTap: () {

            },
          ),

          const SizedBox(
            height:10,
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text('기타',style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),

          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.purple, // 아이콘 색깔 조절
              child: Icon(Icons.room),
            ),
            title: const Text('동네 인증'),
            onTap: () {

            },
          ),



        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: '가계부'),
          BottomNavigationBarItem(icon: Icon(Icons.post_add), label: '동네정보'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
        ],
        currentIndex: _selectedIndex,
        //onTap: _onItemTapped,
      ),
    );
  }
}