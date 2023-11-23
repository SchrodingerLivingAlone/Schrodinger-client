import 'package:flutter/material.dart';

class IncomeRecords extends StatefulWidget {
  const IncomeRecords({super.key});

  @override
  State<IncomeRecords> createState() => _IncomeRecordsState();
}

class _IncomeRecordsState extends State<IncomeRecords> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final expense = args['expense'];
    final selectedButtonIndex = args['selectedButtonIndex'];
    final memo = args['memo'];
    final year = args['year'];
    final month = args['month'];
    final day = args['day'];
    String selectedButtonText = '';
    Color color = Colors.purple;

    if (selectedButtonIndex == 0) {
      selectedButtonText = '월급';
      color = Colors.greenAccent;
    } else if (selectedButtonIndex == 1) {
      selectedButtonText = '용돈';
      color = Colors.cyanAccent;
    } else if (selectedButtonIndex == 2) {
      selectedButtonText = '이월';
      color = Colors.deepPurpleAccent;
    } else if (selectedButtonIndex == 3) {
      selectedButtonText = '자산인출';
      color = Colors.pinkAccent;
    } else if (selectedButtonIndex == 4) {
      selectedButtonText = '기타';
      color = Colors.grey;
    }

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Text('정말로 삭제하시겠습니까?'),
                      ),
                      backgroundColor: Colors.orange,
                      actions: [
                        TextButton(
                          onPressed: () {
                          },
                          child: Text('내역 취소'),
                        ),
                        TextButton(
                          onPressed: () {
                          },
                          child: Text('내역 유지'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
          title: Center(
            child: Text(
              '수입내역',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
      ),
      body: Center(
        child: Material(
            elevation: 5, // 원하는 elevation 값
            child: Container(
              width: 300,
              height: 400,
              decoration: BoxDecoration(
                color: Colors.grey[100],
              ),
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          width: 50.0, // 버튼의 지름
                          height: 50.0, // 버튼의 지름
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          '$selectedButtonText',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey, // 텍스트 색상 조절
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50), // 양쪽 끝에 16의 마진을 줌
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '날짜',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '${year}.${month}.${day}',
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '금액',
                            style: TextStyle(
                                color: Colors.black
                            ),
                          ),
                          Text(
                              '$expense원'
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '메모',
                            style: TextStyle(
                                color: Colors.black
                            ),
                          ),
                          Text(
                              '$memo'
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/incomeCategory');
                            },
                            child: Text('수정')
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
        ),
      )
    );
  }
}
