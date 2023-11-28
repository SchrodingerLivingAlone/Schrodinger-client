import 'package:flutter/material.dart';
import 'package:schrodinger_client/accountbank.dart';
import 'package:schrodinger_client/town_info/town_page.dart';

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
          icon: Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('로그인',
        style: TextStyle(
        color: Color(0xFF61646B), fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('로그인', style: TextStyle(
                          fontSize: 25,
                        fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
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
                          id = value!;
                        },
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
                            border: UnderlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '비밀번호를 입력해주세요.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          password = value!;
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Container(
                    width: double.infinity, // 화면 전체 너비를 사용하도록 설정
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            print('${id}, ${password}');
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TownPage()));
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF0010A3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                      child: Text('로그인'),
                    ),
                  )
                ],
              ),
            )
        ),
      ),
    );
  }
}