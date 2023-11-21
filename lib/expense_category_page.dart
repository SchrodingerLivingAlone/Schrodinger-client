import 'package:flutter/material.dart';

class ExpenseCategoryPage extends StatefulWidget {
  const ExpenseCategoryPage({super.key});

  @override
  State<ExpenseCategoryPage> createState() => _ExpenseCategoryPageState();
}

class _ExpenseCategoryPageState extends State<ExpenseCategoryPage> {
  int expense = 4500;
  final TextEditingController _memoController = TextEditingController();
  String memoText = "";
  int selectedButtonIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  color: theme.colorScheme.primary,
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
                margin: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: CircularButton(
                        color: Colors.pink,
                        onPressed: () {
                          final memo = _memoController.text;
                          if (memo.isEmpty) {
                            print('텍스트가 비어있습니다.');
                          } else {
                            Navigator.pushNamed(context, '/paymentMethods',
                                arguments: {'expense': expense, 'selectedButtonIndex': 0, 'memo': memo}
                            );
                          }
                        },
                        name: '식비',
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: CircularButton(
                        color: Colors.orange,
                        onPressed: () {
                          final memo = _memoController.text;
                          if (memo.isEmpty) {
                            print('텍스트가 비어있습니다.');
                          } else {
                            Navigator.pushNamed(context, '/paymentMethods',
                                arguments: {'expense': expense, 'selectedButtonIndex': 0, 'memo': memo}
                            );
                          }
                        },
                        name: '카페/간식',
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: CircularButton(
                        color: Colors.blue,
                        onPressed: () {
                          final memo = _memoController.text;
                          if (memo.isEmpty) {
                            print('텍스트가 비어있습니다.');
                          } else {
                            Navigator.pushNamed(context, '/paymentMethods',
                                arguments: {'expense': expense, 'selectedButtonIndex': 0, 'memo': memo}
                            );
                          }
                        },
                        name: '교통',
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: CircularButton(
                        color: Colors.green,
                        onPressed: () {
                          final memo = _memoController.text;
                          if (memo.isEmpty) {
                            print('텍스트가 비어있습니다.');
                          } else {
                            Navigator.pushNamed(context, '/paymentMethods',
                                arguments: {'expense': expense, 'selectedButtonIndex': 0, 'memo': memo}
                            );
                          }
                        },
                        name: '술/유흥',
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: CircularButton(
                        color: Colors.grey,
                        onPressed: () {
                          final memo = _memoController.text;
                          if (memo.isEmpty) {
                            print('텍스트가 비어있습니다.');
                          } else {
                            Navigator.pushNamed(context, '/paymentMethods',
                                arguments: {'expense': expense, 'selectedButtonIndex': 0, 'memo': memo}
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
        )
    );
  }
}

class CircularButton extends StatefulWidget {
  final Color color;
  final VoidCallback onPressed;
  final String name;

  CircularButton({
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
          SizedBox(height: 8.0),
          Text(
            '${widget.name}',
            style: TextStyle(
              color: Colors.black, // 텍스트 색상 조절
            ),
          ),
        ],
      ),
    );
  }
}