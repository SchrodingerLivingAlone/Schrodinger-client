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
//TODO 3.위치 버튼 누르면 장소 검색 page로 이동 -> 장소 검색해서 해당 장소로

enum Issue {Restaurant, Facility, Discount, Etc, Together, Ask, PublicInfo}

class PostAdjustPage extends StatefulWidget {
  const PostAdjustPage({super.key});

  @override
  State<PostAdjustPage> createState() => _PostAdjustPageState();
}

class _PostAdjustPageState extends State<PostAdjustPage> {
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
            icon: const Icon(Icons.arrow_back)),
        backgroundColor: Colors.white,
        title: const Padding(
            padding: EdgeInsets.fromLTRB(80, 10, 0, 8),
            child: Text('게시물 수정', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
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
                //수정 api 호출
                Navigator.pop(context);
              });
            },
            child: const Text('완료',
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), backgroundColor: getButtonColor('Button 1'),
                        minimumSize: const Size(30, 30),
                        elevation: 10
                    ),
                    child: const Text('맛집', style: TextStyle(fontSize: 13),)
                ),
                ElevatedButton(onPressed: (){
                  selectButton('Button 2');
                  _issue = Issue.Facility;
                },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), backgroundColor: getButtonColor('Button 2'),
                        minimumSize: const Size(30, 30),
                        elevation: 10),
                    child: const Text('시설', style: TextStyle(fontSize: 13),)
                ),
                ElevatedButton(onPressed: (){
                  selectButton('Button 3');
                  _issue = Issue.Discount;
                },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), backgroundColor: getButtonColor('Button 3'),
                        minimumSize: const Size(30, 30),
                        elevation: 10),
                    child: const Text('할인', style: TextStyle(fontSize: 13),)
                ),
                ElevatedButton(onPressed: (){
                  selectButton('Button 4');
                  _issue = Issue.Etc;
                },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), backgroundColor: getButtonColor('Button 4'),
                        minimumSize: const Size(30, 30),
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), backgroundColor: getButtonColor('Button 5'),
                        minimumSize: const Size(30, 30),
                        elevation: 10),
                    child: const Text('같이해요', style: TextStyle(fontSize: 13),)
                ),
                ElevatedButton(onPressed: (){
                  selectButton('Button 6');
                  _issue = Issue.Ask;
                },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), backgroundColor: getButtonColor('Button 6'),
                        minimumSize: const Size(30, 30),
                        elevation: 10),
                    child: const Text('질문/요청', style: TextStyle(fontSize: 13),)
                ),
                ElevatedButton(onPressed: (){
                  selectButton('Button 7');
                  _issue = Issue.PublicInfo;
                },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), backgroundColor: getButtonColor('Button 7'),
                        minimumSize: const Size(30, 30),
                        elevation: 10),
                    child: const Text('공공정보', style: TextStyle(fontSize: 13),)
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
              child: ImageWidget(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 5.0,8.0,0),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10.0,0,10, 0),
                    child: Text('이미지는 5장까지 업로드할 수 있습니다.', style: TextStyle(fontSize: 12, color: Colors.grey),),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), backgroundColor: Colors.deepPurple,
                        minimumSize: const Size(20, 20),
                        elevation: 10),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const PostSearch()));
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.pin_drop_outlined, color: Colors.white,),
                        Text('위치', style: TextStyle(color: Colors.white),),
                        //사용자의 원래 위치로 초기화해놓고 -> 갔다오면 해당 식당으로 바뀌기.
                      ],
                    ),
                  ),
                ],
              ),
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
      content: const Text('수정중인 글을 취소하시겠습니까?\n', style: TextStyle(fontSize: 15),),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('계속 수정', style: TextStyle(color: Colors.blue),),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            Navigator.of(context).pop(true);
          },
          child: const Text('수정 취소', style: TextStyle(color: Colors.red),),
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











