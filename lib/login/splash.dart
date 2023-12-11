import 'package:flutter/material.dart';
import 'package:schrodinger_client/home.dart';
import 'package:schrodinger_client/login/auth_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    
    Future.delayed(const Duration(seconds: 2), () async {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      var accessToken = sharedPreferences.getString('accessToken');
      // if (accessToken != null) {
      //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
      // } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthPage()));
      // }
    });
    
    return Scaffold(
      backgroundColor: const Color(0xFF94D9FF),
      body: Center(
        child: Image.asset('assets/슈뢰딩거의 자취 로고 4.png'),
      ),
    );
  }
}