import 'package:capstone/budgetpage.dart';
import 'package:flutter/material.dart';
import 'expensepage.dart';


class AccountBank extends StatelessWidget {
  const AccountBank({super.key});

  @override
  Widget build(BuildContext context) {
    final result = ModalRoute.of(context)?.settings.arguments as int? ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('가계부')),
        actions: [
          IconButton(onPressed: (){  //+버튼생성
            showDialog(
              context: context,
              builder: (context){
                return Dialog();
                //지출내역추가, 수입내역 추가, 예산 설정 탭 들어갈수있도록
              },
            );
          },icon: Icon(Icons.add)),

        ],
      ),

      body: Column(
        children: [
          SizedBox(height: 40),
          Center(
            child: Container(
                color: Colors.yellow,
                padding: EdgeInsets.all(30.0),
                child:
                  Column(
                    children: [
                      Text('이번달 남은 예산은 ${result}원 이에요.'),
                      Text('너무 잘하고 있어요!'),
                    ],
                  ),

            ),
          ),
        ],
      ),
    );
  }
}


class Dialog extends StatelessWidget {
  const Dialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.topRight,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(onPressed:(){//버튼 누르면 지출내역으로 넘어감
            Navigator.pop(context);
            Navigator.pushNamed(context, '/ExpensePage');
          }, child: Text('지출 내역 추가'),),
          ElevatedButton(onPressed:(){//버튼 누르면 수입내역으로 넘어감
            Navigator.pop(context);
            Navigator.pushNamed(context,'/IncomePage');
          }, child: Text('수입 내역 추가'),),
          ElevatedButton(onPressed:(){ //버튼 누르면 예산설정페이지로 넘어감.
            Navigator.pop(context);
            Navigator.pushNamed(context, '/BudgetPage');
          }, child: Text('예산 설정'),),

        ],
      ),

    );
  }
}

class IncomePage extends StatelessWidget {
  const IncomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


