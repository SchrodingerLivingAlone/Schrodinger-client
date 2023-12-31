import 'package:flutter/material.dart';
import 'package:schrodinger_client/home.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String id = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('로그인',
        style: TextStyle(
        color: Color(0xFF61646B), fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 150,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('로그인', style: TextStyle(
                          fontSize: 25,
                        fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: '이메일 아이디',
                            border: UnderlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '아이디를 입력해주세요.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          id = value!.trim();
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
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: '비밀번호',
                            border: UnderlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '비밀번호를 입력해주세요.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          password = value!.trim();
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  SizedBox(
                    width: double.infinity, // 화면 전체 너비를 사용하도록 설정
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          print('$id, $password');
                          var loginResponse = await login(context, id, password);
                          var accessToken = loginResponse.result.tokenInfo.accessToken;
                          var refreshToken = loginResponse.result.tokenInfo.refreshToken;
                          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                          sharedPreferences.setString('accessToken', accessToken);
                          sharedPreferences.setString('refreshToken', refreshToken);
                          print('accessToken: $accessToken, refreshToken: $refreshToken');
                        }
                      },
                      // onPressed: (){
                      //   Navigator.pushNamed(context, '/town');
                      // },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0010A3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                      child: const Text('로그인'),
                    ),
                  )
                ],
              ),
            )
        ),
      ),
    );
  }

  Future<LoginResponse> login(BuildContext context, String email, String password) async {
    var baseUrl = dotenv.env['BASE_URL'];
    var url = '$baseUrl/api/users/login';

    // 요청에 전송할 데이터
    var body = {
      'email': email,
      'password': password,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'}
      );

      if (response.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false, // 이 조건이 false가 될 때까지 스택에서 모든 페이지를 제거합니다.
        );
        print('Response Body: ${response.body}');
        return LoginResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}

class LoginResponse {
  final bool isSuccess;
  final String code;
  final String message;
  final Result result;

  LoginResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.result
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
        isSuccess: json["isSuccess"],
        code: json["code"],
        message: json["message"],
        result: Result.fromJson(json['result'])
    );
  }
}

class Result{
  final TokenInfo tokenInfo;
  final String nickName;

  Result({
    required this.tokenInfo,
    required this.nickName
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      tokenInfo: TokenInfo.fromJson(json['tokenInfo']),
      nickName: json['nickName'],
    );
  }
}

class TokenInfo {
  final String grantType;
  final String accessToken;
  final String refreshToken;
  final dynamic refreshTokenExpirationTime;

  TokenInfo({
    required this.grantType,
    required this.accessToken,
    required this.refreshToken,
    required this.refreshTokenExpirationTime
  });

  factory TokenInfo.fromJson(Map<String, dynamic> json) {
    return TokenInfo(
      grantType: json['grantType'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      refreshTokenExpirationTime: json['refreshTokenExpirationTime'],
    );
  }
}