import 'package:flutter/material.dart';
import 'package:schrodinger_client/login/auth_page.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthPage()));
    });
    
    return Scaffold(
      backgroundColor: Color(0xFF94D9FF),
      body: Center(
        child: Image.asset('assets/슈뢰딩거의 자취 로고 4.png'),
      ),
    );
  }
}