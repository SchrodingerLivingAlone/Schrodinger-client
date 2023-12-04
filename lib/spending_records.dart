import 'package:flutter/material.dart';

class SpendingRecords extends StatefulWidget {
  const SpendingRecords({super.key});

  @override
  State<SpendingRecords> createState() => _SpendingRecordsState();
}

class _SpendingRecordsState extends State<SpendingRecords> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final expense = args['expense'];
    final selectedButtonIndex = args['selectedButtonIndex'];
    final memo = args['memo'];
    final type = args['type'];
    final year = args['year'];
    final month = args['month'];
    final day = args['day'];
    String selectedButtonText = '';
    Color color = Colors.purple;

    if (selectedButtonIndex == 0) {
      selectedButtonText = '식비';
      color = Colors.pink;
    } else if (selectedButtonIndex == 1) {
      selectedButtonText = '카페/간식';
      color = Colors.orange;
    } else if (selectedButtonIndex == 2) {
      selectedButtonText = '교통';
      color = Colors.blue;
    } else if (selectedButtonIndex == 3) {
      selectedButtonText = '술/유흥';
      color = Colors.green;
    } else if (selectedButtonIndex == 4) {
      selectedButtonText = '기타';
      color = Colors.grey;
    }

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: const Text('정말로 삭제하시겠습니까?'),
                      ),
                      backgroundColor: Colors.orange,
                      actions: [
                        TextButton(
                          onPressed: () {
                          },
                          child: const Text('내역 취소'),
                        ),
                        TextButton(
                          onPressed: () {
                          },
                          child: const Text('내역 유지'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
          title: const Center(
            child: Text(
              '지출내역',
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
                        margin: const EdgeInsets.only(top: 20),
                        width: 50.0, // 버튼의 지름
                        height: 50.0, // 버튼의 지름
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        selectedButtonText,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey, // 텍스트 색상 조절
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50), // 양쪽 끝에 16의 마진을 줌
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '날짜',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '$year.$month.$day',
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
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
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '지불',
                          style: TextStyle(
                              color: Colors.black
                          ),
                        ),
                        Text(
                            '$type'
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
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
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/incomeCategory');
                          },
                          child: const Text('수정')
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
