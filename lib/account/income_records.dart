import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:schrodinger_client/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    if (selectedButtonIndex == 5) {
      selectedButtonText = '월급';
      color = Colors.greenAccent;
    } else if (selectedButtonIndex == 6) {
      selectedButtonText = '용돈';
      color = Colors.cyanAccent;
    } else if (selectedButtonIndex == 7) {
      selectedButtonText = '이월';
      color = Colors.deepPurpleAccent;
    } else if (selectedButtonIndex == 8) {
      selectedButtonText = '자산인출';
      color = Colors.pinkAccent;
    } else if (selectedButtonIndex == 9) {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                onPressed: () async {
                                  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                  var accessToken = sharedPreferences.getString('accessToken')!;
                                  await sendRequest(context, int.parse(year), int.parse(month), int.parse(day), 1, expense, selectedButtonIndex, 0, memo, accessToken);
                                },
                                child: const Text('저장')
                            )
                          ],
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(right: 40),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.end,
                      //     children: [
                      //       ElevatedButton(
                      //           onPressed: () {
                      //             Navigator.pushNamed(context, '/incomeCategory');
                      //           },
                      //           child: const Text('수정')
                      //       )
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                ],
              ),
            )
        ),
      )
    );
  }

  Future<void> sendRequest(BuildContext context, int year, int month, int day, int type, int price, int transactionCategory, int payCategory, String categoryMemo, String accessToken) async {
    var baseUrl = dotenv.env['BASE_URL'];
    var url = Uri.parse('$baseUrl/api/transactions');

    var body = {
      'year': year,
      'month': month,
      'day': day,
      'type': type,
      'price': price,
      'transactionCategory': transactionCategory,
      'payCategory': payCategory,
      'categoryMemo': categoryMemo,
    };

    print(body);

    try {
      final response = await http.post(
        url,
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print('서버 요청 성공');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false, // 이 조건이 false가 될 때까지 스택에서 모든 페이지를 제거합니다.
        );
      } else {
        print('서버 요청 실패: ${response.statusCode}');
        final Map<String, dynamic> errorJson = jsonDecode(utf8.decode(response.bodyBytes));
        final String errorMessage = errorJson['message'];

        print('에러 메시지: $errorMessage');
        throw Exception('Failed to send request: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('서버 요청 중 오류: $e');
      throw Exception('Failed to send request: $e');
    }
  }
}

class TransactionResponse {
  final bool isSuccess;
  final String code;
  final String message;
  final TransactionResult? result;

  TransactionResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    this.result,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      isSuccess: json['isSuccess'] ?? false,
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      result: json['result'] != null
          ? TransactionResult.fromJson(json['result'])
          : null,
    );
  }
}

class TransactionResult {
  final int type;
  final String transactionCategory;
  final int year;
  final int month;
  final int day;
  final int price;
  final int payCategory;
  final String memo;

  TransactionResult({
    required this.type,
    required this.transactionCategory,
    required this.year,
    required this.month,
    required this.day,
    required this.price,
    required this.payCategory,
    required this.memo,
  });

  factory TransactionResult.fromJson(Map<String, dynamic> json) {
    return TransactionResult(
      type: json['type'] ?? 0,
      transactionCategory: json['transactionCategory'] ?? '',
      year: json['year'] ?? 0,
      month: json['month'] ?? 0,
      day: json['day'] ?? 0,
      price: json['price'] ?? 0,
      payCategory: json['payCategory'] ?? 0,
      memo: json['memo'] ?? '',
    );
  }
}