import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:schrodinger_client/login/google_map_section.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({super.key});

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    final townAddress = ModalRoute.of(context)!.settings.arguments as TownAddress?;

    @override
    void dispose() {
      textController.dispose();
      super.dispose();
    }

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('회원가입',
              style: TextStyle(
                  color: Color(0xFF61646B), fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 1,
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                    }
                  });
                },
                child: Text(
                  '다음',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0010A3)),
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: ProfileButton(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: '아이디',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '아이디를 입력해주세요.';
                          }
                          return null;
                        },
                        onSaved: (value) {

                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        padding: EdgeInsets.only(left: 5),
                        child: Text('이메일 아이디를 입력해주세요.', style: TextStyle(
                          color: Colors.grey
                        ),),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: '비밀번호',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '비밀번호를 입력해주세요.';
                          }
                          return null;
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        padding: EdgeInsets.only(left: 5),
                        child: Text('비밀번호를 입력해주세요.(영문 + 숫자)', style: TextStyle(
                            color: Colors.grey
                        ),),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: '닉네임',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '닉네임을 입력해주세요.';
                          }
                          return null;
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        padding: EdgeInsets.only(left: 5),
                        child: Text('닉네임을 입력해주세요.', style: TextStyle(
                            color: Colors.grey
                        ),),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: textController,
                        onTap: () {
                          Navigator.pushNamed(context, '/town/auth');
                        },
                        decoration: InputDecoration(
                          hintText: townAddress == null ? '우리 동네' : '${townAddress.city} ${townAddress.gu} ${townAddress.dong}',
                          suffixIcon: Icon(Icons.place),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0)),
                      )
                    ],
                  )
                ],
              ),
            )
          ),
        )
    );
  }
}

class ProfileButton extends StatefulWidget {
  const ProfileButton({super.key});

  @override
  State<ProfileButton> createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton> {
  File? _storedImage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _takePicture().then((imageFile) {
          if (imageFile != null) {
            setState(() {
              _storedImage = imageFile;
            });
          }
        });
      },
      child: _buildProfileImage()
    );
  }

  Widget _buildProfileImage() {
    if (_storedImage != null) {
      // 저장된 이미지가 있으면 해당 이미지를 표시
      return ClipOval(
        child: Image.file(
          _storedImage!,
          width: 100.0,
          height: 100.0,
          fit: BoxFit.cover, // 이미지를 둥근 영역에 맞추기 위해 추가
        ),
      );
    } else {
      // 저장된 이미지가 없으면 기본 이미지를 표시
      return ClipOval(
        child: Image.asset(
          'assets/profile_image.png',
          width: 100.0,
          height: 100.0,
          fit: BoxFit.cover, // 이미지를 둥근 영역에 맞추기 위해 추가
        ),
      );
    }
  }

  Future<File?> _takePicture() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );
    return imageFile != null ? File(imageFile.path) : null;
  }
}
