import 'package:flutter/material.dart';

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

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
              },
            ),
          ],
          title: Center(
            child: Text(
              '$expense원',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 140,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: ImageCashButton(
                      expense: expense,
                      selectedButtonIndex: selectedButtonIndex,
                      memo: memo,
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Container(
                    child: ImageCardButton(
                      expense: expense,
                      selectedButtonIndex: selectedButtonIndex,
                      memo: memo,
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}

class ImageCardButton extends StatelessWidget {
  final int expense;
  final int selectedButtonIndex;
  final String memo;

  ImageCardButton({
    required this.expense,
    required this.selectedButtonIndex,
    required this.memo
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/spendingRecords',
            arguments: {'expense': expense, 'selectedButtonIndex': 0, 'memo': memo, 'type': '카드'}
        );
      },
      child: Container(
        width: 300.0,
        height: 97.0,
        decoration: BoxDecoration(
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

  ImageCashButton({
    required this.expense,
    required this.selectedButtonIndex,
    required this.memo
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/spendingRecords',
            arguments: {'expense': expense, 'selectedButtonIndex': 0, 'memo': memo, 'type': '현금'}
        );
      },
      child: Container(
        width: 300.0,
        height: 97.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/cash.png'), // 이미지 파일 경로에 맞게 수정
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}