import 'package:capstone/accountbank.dart';
import 'package:flutter/material.dart';

class ManageProfiles extends StatefulWidget {
  const ManageProfiles({super.key});

  @override
  State<ManageProfiles> createState() => _ManageProfilesState();
}

class _ManageProfilesState extends State<ManageProfiles> {
  final _formKey = GlobalKey<FormState>();
  String newnickname='';
  String newageGender='';
  TextEditingController _nicknameController = TextEditingController();
  TextEditingController _ageGenderController = TextEditingController();
  bool isPublic = false; //공개,비공개변수
  String originalnickname ='';
  bool dialogShown = false; //최초 1회만 다이얼로그를 띄우기 위한 변수

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {//미리 dialog보여주기 위해서추가
      _loadFormData();
    });
  }

  _showDialogIfNeeded() {//만약 한번이라도 눌렸었다면 _showdialog함수 실행안하도록 하는 함수.
    if (!dialogShown) {
      _showDialog();
      dialogShown = true;
    }
  }

  _showDialog() {   //닉네임 30일안에 못바꾼다는 경고문구.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 20,
          actions: [
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  '확인',
                  style: TextStyle(fontSize: 20, color: Colors.deepPurple),
                ),
              ),
            ),
          ],
          content: const Text(
            "닉네임은 30일마다 \n 1번만 수정할 수 있습니다.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
          contentPadding: const EdgeInsets.only(top: 30),
        );
      },
    );
  }

  _modify() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 20,
          content: const Text(
            "닉네임은 30일마다 1번만 수정할 수 있습니다.\n 정말 수정하시겠어요?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10),
          ),
          contentPadding: const EdgeInsets.only(top: 30),

          actions: [
            Column(
              children: [
                Center(
                  child: TextButton(
                    onPressed: () {
                      _nicknameController.text=originalnickname;
                      FocusScope.of(context).unfocus();
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      '수정 취소',
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      '수정 계속',
                      style: TextStyle(fontSize: 20, color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),

          ],
        );
      },
    );
  }



  _loadFormData() {
    final Map<String, String>? arguments =
    ModalRoute.of(context)!.settings.arguments as Map<String, String>?;
    final String nickname = arguments?['nickname'] ?? '';
    final String ageGender = arguments?['ageGender'] ?? '';

    _nicknameController.text = nickname;
    _ageGenderController.text = ageGender;
    originalnickname = nickname;
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){//빈곳터치하면 키보드 내려가기
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('프로필 관리')),
          backgroundColor: Color(0xFF0010A3),
          actions: [
            TextButton(onPressed: (){
              setState(() {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  print('${newnickname},${newageGender},공개여부 : $isPublic');  //제대로 입력받았는지 확인
                  Navigator.pop(context);

                }
              });
            },
                //완료버튼 누르면 닉네임고쳐진거 디비에 바뀌어서 저장되도록 설정.
                child: Text('완료',style: TextStyle(color:Colors.yellow))),
          ],
        ),

        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 120,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('닉네임', style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                        ),
                      ],
                    ),
                    TextFormField(
                      onTap:(){//만약 닉네임을 바꾼지 30일이 안되었으면, 조건 설정해줘서 그때만 뜰 수 있게 세팅.
                        _showDialogIfNeeded();
                      },
                      controller: _nicknameController,
                      decoration: InputDecoration(
                        //hintText: '',
                        border: UnderlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '닉네임을 입력해주세요.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        newnickname = value!;
                      },
                      onEditingComplete: (){
                        _modify();
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('나이대/성별', style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                        ),

                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _ageGenderController,
                            decoration: InputDecoration(
                              //hintText: '',
                              border: UnderlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '나이대/성별을 입력해주세요.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              newageGender = value!;
                            },
                          ),
                        ),
                        Switch(
                          value: isPublic,
                          onChanged: (value) {
                            setState(() {
                              isPublic = value;
                            });
                          },
                        ),
                        Text(
                          isPublic ? '공개' : '비공개',
                          style: TextStyle(fontSize: 15,backgroundColor: Colors.purple,),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('우리 동네', style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('전농동', style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                        TextButton(onPressed:(){}, //이거 누르면 동네설정으로 넘어가도록
                            child: Row(
                              children: [
                                Text('동네 설정'),
                                SizedBox(width:8),
                                Icon(Icons.settings),
                              ],
                            ))
                      ],

                    ),

                  ],
                ),
              )
          ),


        ),




      ),
    );
  }
}
