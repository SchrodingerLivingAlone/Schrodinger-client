import 'package:flutter/material.dart';
import 'package:schrodinger_client/account/accountbank.dart';
import 'package:schrodinger_client/style.dart';

class PaymentMethods extends StatefulWidget {
  const PaymentMethods({super.key});

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final expense = args['expense'];
    final selectedButtonIndex = args['selectedButtonIndex'];
    final memo = args['memo'];
    final year = args['year'];
    final month = args['month'];
    final day = args['day'];

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: AppColor.lightBlue,
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.close),
          //     onPressed: () {
          //       Navigator.pushAndRemoveUntil(
          //         context,
          //         MaterialPageRoute(builder: (context) => const AccountBank()),
          //             (route) => false, // 이 조건이 false가 될 때까지 스택에서 모든 페이지를 제거합니다.
          //       );
          //     },
          //   ),
          // ],
          title: Text(
            '$expense원',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: ImageCashButton(
                    expense: expense,
                    selectedButtonIndex: selectedButtonIndex,
                    memo: memo,
                    year: year,
                    month: month,
                    day: day,
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                Container(
                  child: ImageCardButton(
                    expense: expense,
                    selectedButtonIndex: selectedButtonIndex,
                    memo: memo,
                    year: year,
                    month: month,
                    day: day,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ImageCardButton extends StatelessWidget {
  final int expense;
  final int selectedButtonIndex;
  final String memo;
  final String year;
  final String month;
  final String day;


  const ImageCardButton({super.key, 
    required this.expense,
    required this.selectedButtonIndex,
    required this.memo,
    required this.year,
    required this.month,
    required this.day
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/spendingRecords',
            arguments: {'expense': expense, 'selectedButtonIndex': selectedButtonIndex, 'memo': memo, 'type': '카드', 'year': year, 'month': month, 'day': day}
        );
      },
      child: Container(
        width: 300.0,
        height: 97.0,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/card.png'), // 이미지 파일 경로에 맞게 수정
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class ImageCashButton extends StatelessWidget {
  final int expense;
  final int selectedButtonIndex;
  final String memo;
  final String year;
  final String month;
  final String day;

  const ImageCashButton({super.key, 
    required this.expense,
    required this.selectedButtonIndex,
    required this.memo,
    required this.year,
    required this.month,
    required this.day
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/spendingRecords',
            arguments: {'expense': expense, 'selectedButtonIndex': selectedButtonIndex, 'memo': memo, 'type': '현금', 'year': year, 'month': month, 'day': day}
        );
      },
      child: Container(
        width: 300.0,
        height: 97.0,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/cash.png'), // 이미지 파일 경로에 맞게 수정
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}