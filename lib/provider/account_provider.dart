import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:schrodinger_client/home.dart';

class ExpenseItemProvider extends ChangeNotifier {
  int? year;
  int? month;
  int? day;
  int? type;
  int? price;
  int? transactionCategory;
  int? payCategory;
  String? categoryMemo;

  void updateData({
    int? newYear,
    int? newMonth,
    int? newDay,
    int? newType,
    int? newPrice,
    int? newTransactionCategory,
    int? newPayCategory,
    String? newCategoryMemo,
  }) {
    year = newYear ?? year;
    month = newMonth ?? month;
    day = newDay ?? day;
    type = newType ?? type;
    price = newPrice ?? price;
    transactionCategory = newTransactionCategory ?? transactionCategory;
    payCategory = newPayCategory ?? payCategory;
    categoryMemo = newCategoryMemo ?? categoryMemo;

    notifyListeners();
  }

  Future<void> sendRequest(
      BuildContext context,
      String accessToken
      ) async {
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
        var responseBody = response.body;
        print('에러 메시지: $responseBody');
        throw Exception('Failed to send request: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('서버 요청 중 오류: $e');
      throw Exception('Failed to send request: $e');
    }
  }
}