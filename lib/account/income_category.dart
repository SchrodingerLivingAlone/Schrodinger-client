import 'package:flutter/material.dart';

class IncomeCategory extends StatefulWidget {
  const IncomeCategory({super.key});

  @override
  State<IncomeCategory> createState() => _IncomeCategoryState();
}

class _IncomeCategoryState extends State<IncomeCategory> {
  int expense = 4500;
  final TextEditingController _memoController = TextEditingController();
  String memoText = "";
  int selectedButtonIndex = -1;

  @override
  Widget build(BuildContext context) {

    final Map<String, dynamic> args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final year = args['year'];
    final month = args['month'];
    final day = args['day'];
    final expense = int.parse(args['amount']);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
            },
          ),
        ],
        title: Center(
          child: Text(
            '$expense원',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.purple,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: _memoController,
                decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: '메모',
                    suffixIcon: GestureDetector(
                      onTap: (){
                        _memoController.clear();
                      },
                      child: const Icon(Icons.close),
                    )
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: CircularButton(
                      color: Colors.greenAccent,
                      onPressed: () {
                        final memo = _memoController.text;
                        if (memo.isEmpty) {
                          print('텍스트가 비어있습니다.');
                        } else {
                          Navigator.pushNamed(context, '/incomeRecords',
                              arguments: {'expense': expense, 'selectedButtonIndex': 0, 'memo': memo, 'year': year, 'month': month, 'day': day}
                          );
                        }
                      },
                      name: '월급',
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: CircularButton(
                      color: Colors.cyanAccent,
                      onPressed: () {
                        final memo = _memoController.text;
                        if (memo.isEmpty) {
                          print('텍스트가 비어있습니다.');
                        } else {
                          Navigator.pushNamed(context, '/incomeRecords',
                              arguments: {'expense': expense, 'selectedButtonIndex': 0, 'memo': memo, 'year': year, 'month': month, 'day': day}
                          );
                        }
                      },
                      name: '용돈',
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: CircularButton(
                      color: Colors.deepPurpleAccent,
                      onPressed: () {
                        final memo = _memoController.text;
                        if (memo.isEmpty) {
                          print('텍스트가 비어있습니다.');
                        } else {
                          Navigator.pushNamed(context, '/incomeRecords',
                              arguments: {'expense': expense, 'selectedButtonIndex': 0, 'memo': memo, 'year': year, 'month': month, 'day': day}
                          );
                        }
                      },
                      name: '이월',
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: CircularButton(
                      color: Colors.pinkAccent,
                      onPressed: () {
                        final memo = _memoController.text;
                        if (memo.isEmpty) {
                          print('텍스트가 비어있습니다.');
                        } else {
                          Navigator.pushNamed(context, '/incomeRecords',
                              arguments: {'expense': expense, 'selectedButtonIndex': 0, 'memo': memo, 'year': year, 'month': month, 'day': day}
                          );
                        }
                      },
                      name: '자산인출',
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: CircularButton(
                      color: Colors.grey,
                      onPressed: () {
                        final memo = _memoController.text;
                        if (memo.isEmpty) {
                          print('텍스트가 비어있습니다.');
                        } else {
                          Navigator.pushNamed(context, '/incomeRecords',
                              arguments: {'expense': expense, 'selectedButtonIndex': 0, 'memo': memo, 'year': year, 'month': month, 'day': day}
                          );
                        }
                      },
                      name: '기타',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircularButton extends StatefulWidget {
  final Color color;
  final VoidCallback onPressed;
  final String name;

  const CircularButton({super.key, 
    required this.color,
    required this.onPressed,
    required this.name
  });

  @override
  _CircularButtonState createState() => _CircularButtonState();
}

class _CircularButtonState extends State<CircularButton> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPressed();
      },
      child: Column(
        children: [
          Container(
            width: 50.0, // 버튼의 지름
            height: 50.0, // 버튼의 지름
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            widget.name,
            style: const TextStyle(
              color: Colors.black, // 텍스트 색상 조절
            ),
          ),
        ],
      ),
    );
  }
}