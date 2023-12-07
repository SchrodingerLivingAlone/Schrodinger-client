import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:schrodinger_client/diary/diary_page.dart';
import 'package:schrodinger_client/home.dart';
import 'package:schrodinger_client/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// import '../post/post_adjust.dart';
import '../post/post_page.dart';


class NewDiary extends StatefulWidget {
  const NewDiary({super.key});

  @override
  State<NewDiary> createState() => _NewDiaryState();
}

class _NewDiaryState extends State<NewDiary> {
  final _contentController = TextEditingController();


  Future<int> postNewDiary() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    var url = Uri.parse('${dotenv.env['BASE_URL']}/api/diary');

    var request = http.MultipartRequest('POST', url);
    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Authorization'] = 'Bearer $accessToken';

    request.fields['content'] = _contentController.text;
    List<File> files = [];
    postImages?.forEach((element) {
      files.add(File(element.path));
    });

    for (var file in files) {
      request.files.add(await http.MultipartFile.fromPath('files', file.path));
    }

    final response = await request.send();
    return response.statusCode;
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
              postImages?.clear();
              imagePickerProvider = StateNotifierProvider<ImageState, List<XFile>>((ref) {return ImageState();});
              Navigator.pop(context);
            },
            color: Colors.purple,
            icon: const Icon(Icons.arrow_back)),
        backgroundColor: Colors.white,
        title: const Center(
            child: Text('새 일기', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shadowColor: Colors.transparent,
            ),
            onPressed: () async {
              int statusCode = await postNewDiary();
              if(statusCode == 200) {
                postImages?.clear();
                imagePickerProvider = StateNotifierProvider<ImageState, List<XFile>>((ref) {return ImageState();});
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('사진을 필수로 추가해야합니다 !'),
                      duration: Duration(seconds: 3),
                    )
                );
              }
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
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Text('공유하고 싶은 일상을 작성해주세요!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: ImageWidget(),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10.0, 5.0,8.0,0),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10.0,0,10, 0),
                  child: Text('이미지는 5장까지 업로드할 수 있습니다.', style: TextStyle(fontSize: 12, color: Colors.grey),),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 10, 30, 5),
            child: Container(
              child: TextField(
                maxLines: null,
                maxLength: 200,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '내용을 입력하세요.',
                ),
                controller: _contentController,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
