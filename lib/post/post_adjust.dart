// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http_parser/http_parser.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:schrodinger_client/post/postPage.dart';
// import 'package:schrodinger_client/post/post_info.dart';
// import 'package:schrodinger_client/style.dart';
// import 'package:schrodinger_client/town_info/ImageUploader.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:schrodinger_client/post/post_search.dart';
// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'dart:convert';
//
// import 'package:shared_preferences/shared_preferences.dart';
//
//
// //TODO 1.등록하면 글 객체 생성 -> api
// List<XFile> ? postImages = [];
//
// enum Issue {RESTAURANT, FACILITY, SHARE_INFORMATION, TOGETHER, COMMUNICATION, ETC}
//
// class PostAdjustPage extends StatefulWidget{
//   PostAdjustPage({required this.postId, super.key});
//   int postId;
//
//   @override
//   State<PostAdjustPage> createState() => _PostAdjustPageState();
// }
//
// class _PostAdjustPageState extends State<PostAdjustPage>{
//   Issue _issue = Issue.RESTAURANT;
//   String selectedButton = 'Button 1';
//   final _titleController = TextEditingController();
//   final _contentController = TextEditingController();
//   String searchedLocation = '위치';//사용자의 현재위치 넣어놓기
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     initLocation();
//   }
//
//   void initLocation() async {
//     var getPositionResponse = await getPosition(context);
//     setState(() {
//       searchedLocation = getPositionResponse.result.currentLocation;
//     });
//   }
//
//   void selectButton(String buttonName) {
//     setState(() {
//       selectedButton = buttonName;
//     });
//   }
//   Color getButtonColor(String buttonName) {
//     return selectedButton == buttonName ? Colors.orange : Colors.grey;
//   }
//
//
//   Future<GetPositionResponse> getPosition(BuildContext context) async {
//     var url = '${dotenv.env['BASE_URL']}/api/neighborhood/posts/location';
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? accessToken = prefs.getString('accessToken');
//     try {
//       final response = await http.get(
//           Uri.parse(url),
//           headers: {'Authorization' : 'Bearer $accessToken'}
//       );
//
//       if (response.statusCode == 200) {
//         print('Response Body: ${response.body}');
//         return GetPositionResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
//       } else {
//         print(response.statusCode);
//         throw Exception('Failed to load data1: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Failed to load data2: $e');
//     }
//   }
//
//   Future<PostPageResponse> PostPost(BuildContext context) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? accessToken = prefs.getString('accessToken');
//     var url = Uri.parse('${dotenv.env['BASE_URL']}/api/neighborhood/posts');
//
//     String category;
//     switch(_issue){
//       case Issue.RESTAURANT:
//         category = '0';
//         break;
//       case Issue.FACILITY:
//         category = '1';
//         break;
//       case Issue.SHARE_INFORMATION:
//         category = '2';
//         break;
//       case Issue.TOGETHER:
//         category = '3';
//         break;
//       case Issue.COMMUNICATION:
//         category = '4';
//         break;
//       case Issue.ETC:
//         category = '5';
//         break;
//     }
//
//     var request = http.MultipartRequest('POST', url);
//     request.headers['Content-Type'] = 'multipart/form-data';
//     request.headers['Authorization'] = 'Bearer $accessToken';
//
//
//     request.fields['category'] = category.toString();
//     request.fields['title'] = _titleController.text;
//     request.fields['content'] = _contentController.text;
//     request.fields['place'] = searchedLocation;
//     List<File> files = [];
//     postImages?.forEach((element) {
//       files.add(File(element!.path));
//     });
//
//     for (var file in files) {
//       request.files.add(await http.MultipartFile.fromPath('files', file.path));
//     }
//
//     try {
//       var response = await request.send();
//
//       if (response.statusCode == 200) {
//         print('게시글 등록 성공');
//         var responseBody = await response.stream.bytesToString();
//         Map<String, dynamic> jsonMap = json.decode(responseBody);
//
//
//         var isSuccess = jsonMap["isSuccess"];
//         var code = jsonMap["code"];
//         var message = jsonMap["message"];
//         var result = jsonMap["result"];
//
//         return PostPageResponse.fromJson(jsonMap);
//       } else {
//         throw Exception('Failed to load data: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Failed to load data: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(
//             color: Colors.black
//         ),
//         leading:  IconButton(
//             onPressed: () {
//               postImages?.clear();
//               showExitConfirmationDialog(context);
//             },
//             color: Colors.purple,
//             icon: const Icon(Icons.arrow_back)),
//         backgroundColor: Colors.white,
//         title: const Center(
//             child: Text('새 게시물', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
//         actions: [
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.white,
//               shadowColor: Colors.transparent,
//             ),
//             // onPressed: () async {
//             //   var postPostResponse = await PostPost(context);
//             //   if(postPostResponse.isSuccess == true){
//             //     print(postPostResponse.message);
//             //     postImages?.clear();
//             //     imagePickerProvider = StateNotifierProvider<ImageState, List<XFile>>((ref) {return ImageState();});
//             //     showPostonfirmationDialog(context);
//             //   }
//             // },
//             onPressed: () async {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => PostInfo(PostId: 14,),//11,
//                 ),
//               );
//             },
//             child: const Text('등록',
//               style: TextStyle(
//                 color: AppColor.yellow,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Container(
//         color: Colors.white,
//         child: ListView(
//           children: [
//             Padding(
//               padding: const EdgeInsets.fromLTRB(30, 10, 0, 5),
//               child: Container(
//                 child: const Text('주제', style: TextStyle(fontSize: 15,color: Colors.black, fontWeight: FontWeight.bold)),
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(onPressed: (){
//                   selectButton('Button 1');
//                   _issue = Issue.RESTAURANT;
//                 },
//                     style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), backgroundColor: getButtonColor('Button 1'),
//                         minimumSize: const Size(30, 30),
//                         elevation: 10
//                     ),
//                     child: const Text('맛집', style: TextStyle(fontSize: 13),)
//                 ),
//                 ElevatedButton(onPressed: (){
//                   selectButton('Button 2');
//                   _issue = Issue.FACILITY;
//                 },
//                     style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), backgroundColor: getButtonColor('Button 2'),
//                         minimumSize: const Size(30, 30),
//                         elevation: 10),
//                     child: const Text('시설', style: TextStyle(fontSize: 13),)
//                 ),
//                 ElevatedButton(onPressed: (){
//                   selectButton('Button 3');
//                   _issue = Issue.SHARE_INFORMATION;
//                 },
//                     style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), backgroundColor: getButtonColor('Button 3'),
//                         minimumSize: const Size(30, 30),
//                         elevation: 10),
//                     child: const Text('정보공유', style: TextStyle(fontSize: 13),)
//                 ),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(onPressed: (){
//                   selectButton('Button 4');
//                   _issue = Issue.ETC;
//                 },
//                     style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), backgroundColor: getButtonColor('Button 4'),
//                         minimumSize: const Size(30, 30),
//                         elevation: 10),
//                     child: const Text('같이해요', style: TextStyle(fontSize: 13),)
//                 ),
//                 ElevatedButton(onPressed: (){
//                   selectButton('Button 5');
//                   _issue = Issue.TOGETHER;
//                 },
//                     style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//                         minimumSize: const Size(30, 30),
//                         primary: getButtonColor('Button 5'),
//                         elevation: 10),
//                     child: const Text('소통해요', style: TextStyle(fontSize: 13),)
//                 ),
//                 ElevatedButton(onPressed: (){
//                   selectButton('Button 6');
//                   _issue = Issue.ETC;
//                 },
//                     style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), backgroundColor: getButtonColor('Button 6'),
//                         minimumSize: const Size(30, 30),
//                         elevation: 10),
//                     child: const Text('기타', style: TextStyle(fontSize: 13),)
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Padding(
//               padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
//               child: ImageWidget(),
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(10.0, 5.0,8.0,0),
//               child: Row(
//                 children: [
//                   const Padding(
//                     padding: EdgeInsets.fromLTRB(10.0,0,10, 0),
//                     child: Text('이미지는 5장까지 업로드할 수 있습니다.', style: TextStyle(fontSize: 12, color: Colors.grey),),
//                   ),
//                 ],
//               ),
//             ),
//             Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), backgroundColor: Colors.deepPurple,
//                         minimumSize: const Size(20, 20),
//                         elevation: 10),
//                     onPressed: () async {
//                       searchedLocation = await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => PostSearch(
//                             curLocation: searchedLocation,
//                             onStringReturned: (value) {
//                               setState(() {
//                                 searchedLocation = value;
//                               });
//                             },
//                           ),
//                         ),
//                       );
//                     },
//                     child: Row(
//                       children: [
//                         const Icon(Icons.pin_drop_outlined, color: Colors.white,),
//                         Text(searchedLocation, style: const TextStyle(color: Colors.white),),
//                         //사용자의 원래 위치로 초기화해놓고 -> 갔다오면 해당 식당으로 바뀌기.
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
//               child: TextField(
//                 maxLength: 30,
//                 maxLengthEnforcement: MaxLengthEnforcement.enforced,
//                 decoration: const InputDecoration(
//                   hintText: '제목을 입력하세요.',
//                   border: UnderlineInputBorder(),
//                 ),
//                 controller: _titleController,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(30, 10, 30, 5),
//               child: Container(
//                 child: TextField(
//                   maxLines: null,
//                   maxLength: 200,
//                   maxLengthEnforcement: MaxLengthEnforcement.enforced,
//                   decoration: const InputDecoration(
//                     border: InputBorder.none,
//                     hintText: '내용을 입력하세요.',
//                   ),
//                   controller: _contentController,
//                 ),
//               ),
//             ),
//           ],//children
//         ),
//       ),
//     );
//   }
// }
//
// Future<bool?> showExitConfirmationDialog(BuildContext context) async {
//   return showDialog<bool?>(
//     context: context,
//     builder: (context) => AlertDialog(
//       content: const Text('작성중인 글을 취소하시겠습니까?\n작성 취소 시, 작성된 글은 저장되지 않습니다.', style: TextStyle(fontSize: 15),),
//       actions: <Widget>[
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(false),
//           child: const Text('계속 작성', style: TextStyle(color: Colors.blue),),
//         ),
//         TextButton(
//           onPressed: () {
//             postImages?.clear();
//             imagePickerProvider = StateNotifierProvider<ImageState, List<XFile>>((ref) {return ImageState();});
//             Navigator.of(context).pop(true);
//             Navigator.of(context).pop(true);
//           },
//           child: const Text('작성 취소', style: TextStyle(color: Colors.red),),
//         ),
//       ],
//     ),
//   );
// }
//
// Future<bool?> showPostonfirmationDialog(BuildContext context) async {
//   return showDialog<bool?>(
//     context: context,
//     builder: (context) => AlertDialog(
//       content: const Text('성공적으로 글을 게시하였습니다.', style: TextStyle(fontSize: 15),),
//       actions: <Widget>[
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop(true);
//             Navigator.of(context).pop(true);
//           },
//           child: const Text('확인', style: TextStyle(color: Colors.red),),
//         ),
//       ],
//     ),
//   );
// }
// //////////////////////////////////////////////////////
// //Image 업로드 코드
// //////////////////////////////////////////////////////
//
// var imagePickerProvider = StateNotifierProvider<ImageState, List<XFile>>((ref) {return ImageState();});
//
// class ImageState extends StateNotifier<List<XFile>> {
//   ImageState() : super(<XFile>[]);
//   final ImagePickerService picker = ImagePickerService();
//
//   @override
//   set state(List<XFile> value) {
//     super.state = value;
//   }
//
//   clear(){
//     super.state = [];
//   }
//
//   delImage(XFile image) async {
//     var list = [...super.state];
//     ////
//     postImages?.remove(image);
//     list.remove(image);
//     state = list;
//   }
//
//   void addImage(List<XFile> value) async {
//     var list = [...super.state];
//     if (list.isEmpty) {
//       state = value;
//     } else {
//       ////
//       list.addAll(value);
//       list.toSet().toList();
//       state = list;
//     }
//     if (super.state.length > 5) {
//       state = super.state.sublist(0, 5);
//       Fluttertoast.showToast(msg: '최대 5개의 이미지를 업로드할 수 있습니다.');
//     }
//   }
//
//   Future getImage() async {
//     picker.pickImage().then((value) {
//       postImages?.addAll(value);
//       addImage(value);
//     }).catchError((onError) {
//       Fluttertoast.showToast(msg: 'failed to get image');
//     });
//   }
// }
//
// class GetPositionResponse {
//   final bool isSuccess;
//   final String code;
//   final String message;
//   final GetLocationResult result;
//
//   GetPositionResponse({
//     required this.isSuccess,
//     required this.code,
//     required this.message,
//     required this.result
//   });
//
//   factory GetPositionResponse.fromJson(Map<String, dynamic> json) {
//     return GetPositionResponse(
//         isSuccess: json["isSuccess"],
//         code: json["code"],
//         message: json["message"],
//         result: GetLocationResult.fromJson(json['result'])
//     );
//   }
// }
//
// class GetLocationResult{
//   final String currentLocation;
//
//   GetLocationResult({
//     required this.currentLocation
//   });
//
//   factory GetLocationResult.fromJson(Map<String, dynamic> json) {
//     return GetLocationResult(
//       currentLocation: json['town'],
//     );
//   }
// }
//
//
// class PostPageResponse {
//   final bool isSuccess;
//   final String code;
//   final String message;
//   final PostPageResult result;
//
//   PostPageResponse({
//     required this.isSuccess,
//     required this.code,
//     required this.message,
//     required this.result
//   });
//
//   factory PostPageResponse.fromJson(Map<String, dynamic> json) {
//     return PostPageResponse(
//         isSuccess: json["isSuccess"],
//         code: json["code"],
//         message: json["message"],
//         result: PostPageResult.fromJson(json['result'])
//     );
//   }
// }
//
// class PostPageResult{
//   final int id;
//   final String dong;
//   final String neighborhoodPostCategory;
//   final String title;
//   final String content;
//   final String place;
//   final List<dynamic> imageUrls;
//   final String createdAt;
//   final int view;
//
//   PostPageResult({
//     required this.id,
//     required this.dong,
//     required this.neighborhoodPostCategory,
//     required this.title,
//     required this.content,
//     required this.place,
//     required this.imageUrls,
//     required this.createdAt,
//     required this.view,
//   });
//
//   factory PostPageResult.fromJson(Map<String, dynamic> json) {
//     return PostPageResult(
//       id : json['id'],
//       dong : json['dong'],
//       neighborhoodPostCategory: json['neighborhoodPostCategory'],
//       title: json['title'],
//       content: json['content'],
//       place: json['place'],
//       imageUrls: json['imageUrls'],
//       createdAt: json['createdAt'],
//       view: json['view'],
//     );
//   }
// }
//
//
//
//
//
