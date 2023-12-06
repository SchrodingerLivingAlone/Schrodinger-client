import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:schrodinger_client/login/google_map_section.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:schrodinger_client/login/login_page.dart';

File? profileImageFile;

class JoinPage extends StatefulWidget {
  const JoinPage({super.key});

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String nickname = '';
  String city = '';
  String gu = '';
  String dong = '';
  ProfileButton profileButton = const ProfileButton();

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
          title: const Text('회원가입',
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
                      print(email);
                      print(password);
                      print(nickname);
                      print('city: $city');
                      print('gu: $gu');
                      print('dong: $dong');

                      if (profileImageFile == null) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('프로필 사진 설정'),
                              content: const Text('프로필 사진을 설정해주세요.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('확인'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        print('$profileImageFile');
                        join(context, profileImageFile!);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                              (route) => false, // 이 조건이 false가 될 때까지 스택에서 모든 페이지를 제거합니다.
                        );
                      }
                    }
                  });
                },
                child: const Text(
                  '다음',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0010A3)),
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: profileButton,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: textController,
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/town/auth');  //스택에 넣지 않고 화면 전환만
                        },
                        decoration: InputDecoration(
                            hintText: townAddress == null ? '우리 동네' : '${townAddress.city} ${townAddress.gu} ${townAddress.dong}',
                            suffixIcon: const Icon(Icons.place),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0)),
                        onSaved: (value) {
                          if (townAddress != null) {
                            city = townAddress.city;
                            gu = townAddress.gu;
                            dong = townAddress.dong;
                          }
                        },
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
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
                            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '아이디를 입력해주세요.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          email = value!.trim();
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        padding: const EdgeInsets.only(left: 5),
                        child: const Text('이메일 아이디를 입력해주세요.', style: TextStyle(
                          color: Colors.grey
                        ),),
                      )
                    ],
                  ),
                  const SizedBox(
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
                            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '비밀번호를 입력해주세요.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          password = value!.trim();
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        padding: const EdgeInsets.only(left: 5),
                        child: const Text('비밀번호를 입력해주세요.(영문 + 숫자)', style: TextStyle(
                            color: Colors.grey
                        ),),
                      )
                    ],
                  ),
                  const SizedBox(
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
                            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '닉네임을 입력해주세요.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          nickname = value!.trim();
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        padding: const EdgeInsets.only(left: 5),
                        child: const Text('닉네임을 입력해주세요.', style: TextStyle(
                            color: Colors.grey
                        ),),
                      )
                    ],
                  ),
                ],
              ),
            )
          ),
        )
    );
  }

  Future<JoinResponse> join(BuildContext context, File profileImage) async {
    var baseUrl = dotenv.env['BASE_URL'];
    var url = Uri.parse('$baseUrl/api/users/sign-up');

    var request = http.MultipartRequest('POST', url);
    request.headers['Content-Type'] = 'multipart/form-data';

    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['nickname'] = nickname;
    request.fields['city'] = city;
    request.fields['gu'] = gu;
    request.fields['dong'] = dong;

    var imageStream = http.ByteStream(Stream.castFrom(profileImage.openRead()));
    var length = await profileImage.length();
    var multipartFile = http.MultipartFile('file', imageStream, length, filename: 'file', contentType: MediaType('image', 'jpeg'));
    request.files.add(multipartFile);

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      Map<String, dynamic> jsonMap = json.decode(responseBody);

      // 맵에서 값 추출
      var isSuccess = jsonMap["isSuccess"];
      var code = jsonMap["code"];
      var message = jsonMap["message"];
      var result = jsonMap["result"];

      if (response.statusCode == 200) {
        // 성공적으로 응답 받은 경우의 처리
        print('회원가입 성공');
        print(responseBody);
        return JoinResponse.fromJson(json.decode(await response.stream.bytesToString()));
      } else {
        // 서버 응답이 실패인 경우의 처리
        print('회원가입 실패: ${response.statusCode}');
        print('에러 메시지: $responseBody');
        throw Exception('Failed to join: ${response.reasonPhrase}');
      }
    } catch (e) {
      // 에러 발생 시의 처리
      throw Exception('Failed to join: $e');
    }
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
              profileImageFile = imageFile;
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

  File? getStoredImage() {
    print('여기까지는 오케이$_storedImage');

    return _storedImage;
  }
}

class JoinResponse {
  final bool isSuccess;
  final String code;
  final String message;
  final String? result;

  JoinResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.result
  });

  factory JoinResponse.fromJson(Map<String, dynamic> json) {
    return JoinResponse(
        isSuccess: json["isSuccess"],
        code: json["code"],
        message: json["message"],
        result: (json['result'])
    );
  }
}

class SignUp{
  final String email;
  final String password;
  final String nickname;
  final String city;
  final String gu;
  final String dong;
  final dynamic multipartFiles;

  SignUp({
    required this.email,
    required this.password,
    required this.nickname,
    required this.city,
    required this.gu,
    required this.dong,
    required this.multipartFiles
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'nickname': nickname,
      'city': city,
      'gu': gu,
      'dong': dong,
      'multipartFiles': multipartFiles
    };
  }
}

class SignUpRequest {
  final SignUp signup;
  final File file;

  SignUpRequest({required this.signup, required this.file});

  Map<String, dynamic> toJson() {
    return {
      'signup': signup.toJson(),
      'file': file,
    };
  }
}