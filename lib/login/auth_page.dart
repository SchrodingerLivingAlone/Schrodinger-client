import 'package:flutter/material.dart';
import 'package:schrodinger_client/login/join_page.dart';
import 'package:schrodinger_client/login/login_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF94D9FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage('assets/슈뢰딩거의 자취 로고 4.png')),
            const Text(
              '슈뢰딩거의 자취',
              style: TextStyle(
                color: Color(0xFF0010A3),
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0010A3)
                    ),
                    child: const Text('로그인',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)
                    ),
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const JoinPage()));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0010A3)
                    ),
                    child: const Text('회원가입',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
