import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:schrodinger_client/style.dart';
import 'package:schrodinger_client/town_info/ImageUploader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:schrodinger_client/post/post_search.dart';

//TODO 1.등록하면 글 객체 생성 -> api완성 후 합칠때
//TODO 2.위치 버튼 누르면 장소 검색 page로 이동 -> 장소 검색해서 해당 장소 return해서 String으로 띄워주기
//TODO 3.밑에 한줄 더해서 위치띄우기.

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
  String searchedLocation = '흑석동';//사용자의 현재위치 넣어놓기

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
          icon: const Icon(Icons.arrow_back)),
        backgroundColor: Colors.white,
        title: const Center(
            child: Text('새 게시물', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shadowColor: Colors.transparent,
            ),
            //onPressed: (){
              //
              //글 객체 생성해서 맞는 자료구조(배열)에 추가하기
              //자료구조는 규한이랑 얘기해보기
              //
              //Navigator.pop(context);
            //},
            onPressed: () {
              setState(() {
                Navigator.pushNamed(context, '/post_info');
              });
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
                  child: const Text('주제', style: TextStyle(fontSize: 15,color: Colors.black, fontWeight: FontWeight.bold)),
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
                        minimumSize: const Size(30, 30),
                        primary: getButtonColor('Button 1'),
                        elevation: 10
                    ),
                    child: const Text('맛집', style: TextStyle(fontSize: 13),)
                ),
                ElevatedButton(onPressed: (){
                  selectButton('Button 2');
                  _issue = Issue.Facility;
                },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        minimumSize: const Size(30, 30),
                        primary: getButtonColor('Button 2'),
                        elevation: 10),
                    child: const Text('시설', style: TextStyle(fontSize: 13),)
                ),
                ElevatedButton(onPressed: (){
                  selectButton('Button 3');
                  _issue = Issue.Discount;
                },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        minimumSize: const Size(30, 30),
                        primary: getButtonColor('Button 3'),
                        elevation: 10),
                    child: const Text('할인', style: TextStyle(fontSize: 13),)
                ),
                ElevatedButton(onPressed: (){
                  selectButton('Button 4');
                  _issue = Issue.Etc;
                  },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        minimumSize: const Size(30, 30),
                        primary: getButtonColor('Button 4'),
                        elevation: 10),
                    child: const Text('기타', style: TextStyle(fontSize: 13),)
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
                        minimumSize: const Size(30, 30),
                        primary: getButtonColor('Button 5'),
                        elevation: 10),
                    child: const Text('같이해요', style: TextStyle(fontSize: 13),)
                ),
                ElevatedButton(onPressed: (){
                  selectButton('Button 6');
                  _issue = Issue.Ask;
                },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        minimumSize: const Size(30, 30),
                        primary: getButtonColor('Button 6'),
                        elevation: 10),
                    child: const Text('질문/요청', style: TextStyle(fontSize: 13),)
                ),
                ElevatedButton(onPressed: (){
                  selectButton('Button 7');
                  _issue = Issue.PublicInfo;
                },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        minimumSize: const Size(30, 30),
                        primary: getButtonColor('Button 7'),
                        elevation: 10),
                    child: const Text('공공정보', style: TextStyle(fontSize: 13),)
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
              child: ImageWidget(),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.0, 5.0,8.0,0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0,0,10, 0),
                    child: const Text('이미지는 5장까지 업로드할 수 있습니다.', style: TextStyle(fontSize: 12, color: Colors.grey),),
                  ),

                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        minimumSize: const Size(20, 20),
                        primary: Colors.deepPurple,
                        elevation: 10),
                    onPressed: () async {
                      // 두 번째 페이지로 이동하고 반환값을 받습니다.
                      searchedLocation = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostSearch(
                            curLocation: searchedLocation,
                            onStringReturned: (value) {
                              setState(() {
                                searchedLocation = value;
                              });
                            },
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(Icons.pin_drop_outlined, color: Colors.white,),
                        Text(searchedLocation, style: TextStyle(color: Colors.white),),
                        //사용자의 원래 위치로 초기화해놓고 -> 갔다오면 해당 식당으로 바뀌기.
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: TextField(
                  maxLength: 30,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  decoration: const InputDecoration(
                    hintText: '제목을 입력하세요.',
                    border: UnderlineInputBorder(),
                  ),
                  controller: _titleController,
                ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 5),
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
      content: const Text('작성중인 글을 취소하시겠습니까?\n작성 취소 시, 작성된 글은 저장되지 않습니다.', style: TextStyle(fontSize: 15),),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('계속 작성', style: TextStyle(color: Colors.blue),),
        ),
        TextButton(
          onPressed: () {
              Navigator.of(context).pop(true);
              Navigator.of(context).pop(true);
            },
          child: const Text('작성 취소', style: TextStyle(color: Colors.red),),
        ),
      ],
    ),
  );
}
//////////////////////////////////////////////////////
//Image 업로드 코드
//////////////////////////////////////////////////////
final imagePickerProvider = StateNotifierProvider<ImageState, List<XFile>>((ref) {
  return ImageState();
});

class ImageState extends StateNotifier<List<XFile>> {
  ImageState() : super(<XFile>[]);
  final ImagePickerService picker = ImagePickerService();

  @override
  set state(List<XFile> value) {
    super.state = value;
  }

  delImage(XFile image) {
    var list = [...super.state];
    list.remove(image);
    state = list;
  }

  void addImage(List<XFile> value) {
    var list = [...super.state];
    if (list.isEmpty) {
      state = value;
    } else {
      list.addAll(value);
      list.toSet().toList();
      state = list;
    }
    if (super.state.length > 5) {
      state = super.state.sublist(0, 5);
      Fluttertoast.showToast(msg: '최대 5개의 이미지를 업로드할 수 있습니다.');
    }
  }

  Future getImage() async {
    picker.pickImage().then((value) {
      addImage(value);
    }).catchError((onError) {
      Fluttertoast.showToast(msg: 'failed to get image');
    });
  }
}

class ImageWidget extends ConsumerWidget {
  const ImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double imgBoxSize = ((MediaQuery.of(context).size.width - 32) / 5) - 4;
    final images = ref.watch(imagePickerProvider);

    Widget imageBox(XFile img) => GestureDetector(
        onTap: () => ref.read(imagePickerProvider.notifier).delImage(img),
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: imgBoxSize,
            height: imgBoxSize,
            child: Stack(children: [
              Center(
                  child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: Image.file(File(img.path)).image),
                          borderRadius: BorderRadius.circular(10)),
                      width: imgBoxSize,
                      height: imgBoxSize)),
              Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10)),
                      child: Icon(Icons.close,
                          size: 15, color: Colors.grey[400])))
            ])));


    return Row(children: [
      if (images.length == 5) ...[
        ...images.map((e) => imageBox(e)).toList(),
      ] else ...[
        ...images.map((e) => imageBox(e)).toList(),
        InkWell(
            onTap: () => ref.read(imagePickerProvider.notifier).getImage(),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: MediaQuery.of(context).size.width * 0.17,
              height: MediaQuery.of(context).size.width * 0.17,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image, color: Colors.grey[400]!),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'image',
                    style: TextStyle(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0),
                  )
                ],
              ),
            ))
      ]
    ]);
  }
}


// Future<LoginResponse> login(BuildContext context, String email, String password) async {
//   var url = 'http://13.124.153.160:8081/api/users/login';
//
//   // 요청에 전송할 데이터
//   var body = {
//     'email': email,
//     'password': password,
//   };
//
//   try {
//     final response = await http.post(
//         Uri.parse(url),
//         body: json.encode(body),
//         headers: {'Content-Type': 'application/json'}
//     );
//
//     if (response.statusCode == 200) {
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TownPage()));
//       print('Response Body: ${response.body}');
//       return LoginResponse.fromJson(json.decode(response.body));
//     } else {
//       throw Exception('Failed to load data: ${response.statusCode}');
//     }
//   } catch (e) {
//     throw Exception('Failed to load data: $e');
//   }
// }
// }
//
// class LoginResponse {
//   final bool isSuccess;
//   final String code;
//   final String message;
//   final Result result;
//
//   LoginResponse({
//     required this.isSuccess,
//     required this.code,
//     required this.message,
//     required this.result
//   });
//
//   factory LoginResponse.fromJson(Map<String, dynamic> json) {
//     return LoginResponse(
//         isSuccess: json["isSuccess"],
//         code: json["code"],
//         message: json["message"],
//         result: Result.fromJson(json['result'])
//     );
//   }
// }
//
// class Result{
//   final TokenInfo tokenInfo;
//   final String nickName;
//
//   Result({
//     required this.tokenInfo,
//     required this.nickName
//   });
//
//   factory Result.fromJson(Map<String, dynamic> json) {
//     return Result(
//       tokenInfo: TokenInfo.fromJson(json['tokenInfo']),
//       nickName: json['nickName'],
//     );
//   }
// }
//
// class TokenInfo {
//   final String grantType;
//   final String accessToken;
//   final String refreshToken;
//   final dynamic refreshTokenExpirationTime;
//
//   TokenInfo({
//     required this.grantType,
//     required this.accessToken,
//     required this.refreshToken,
//     required this.refreshTokenExpirationTime
//   });
//
//   factory TokenInfo.fromJson(Map<String, dynamic> json) {
//     return TokenInfo(
//       grantType: json['grantType'],
//       accessToken: json['accessToken'],
//       refreshToken: json['refreshToken'],
//       refreshTokenExpirationTime: json['refreshTokenExpirationTime'],
//     );
//   }
// }








