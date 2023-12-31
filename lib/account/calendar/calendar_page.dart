import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

var dayOfWeek = '';
var month = '';
var day = 0;
var year = 0;
var accessToken = '';
List<bool> dotList = List.empty();
List<TransactionsResult> tList = List.empty();

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

Future<void> initializeData() async {
  DateTime today = DateTime.now();

  month = '${today.month}';
  day = today.day;
  year = today.year;
  switch (today.weekday) {
    case 1:
      dayOfWeek = '월요일';
      break;
    case 2:
      dayOfWeek = '화요일';
      break;
    case 3:
      dayOfWeek = '수요일';
      break;
    case 4:
      dayOfWeek = '목요일';
      break;
    case 5:
      dayOfWeek = '금요일';
      break;
    case 6:
      dayOfWeek = '토요일';
      break;
    case 7:
      dayOfWeek = '일요일';
      break;
    default:
      dayOfWeek = '알 수 없음';
  }

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  accessToken = sharedPreferences.getString('accessToken')!;
  await getCalendarDotData(int.parse(month), year, accessToken);
  tList = List.empty();
}

class _CalendarPageState extends State<CalendarPage> {
  Color? priceColor;

  @override
  void initState() {
    super.initState();

    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
            '가계부',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          TableCalendarScreen(
            onDateSelected: (DateTime selectedDay) async {
              SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
              var accessToken = sharedPreferences.getString('accessToken');
              setState(() {
                switch (selectedDay.weekday) {
                  case 1:
                    dayOfWeek = '월요일';
                    break;
                  case 2:
                    dayOfWeek = '화요일';
                    break;
                  case 3:
                    dayOfWeek = '수요일';
                    break;
                  case 4:
                    dayOfWeek = '목요일';
                    break;
                  case 5:
                    dayOfWeek = '금요일';
                    break;
                  case 6:
                    dayOfWeek = '토요일';
                    break;
                  case 7:
                    dayOfWeek = '일요일';
                    break;
                  default:
                    dayOfWeek = '알 수 없음';
                }
                month = '${selectedDay.month}';
                day = selectedDay.day;
              });
            },
          ),
          const Divider(
            color: Colors.grey,
            height: 1,
            thickness: 1,
            indent: 0,
            endIndent: 0,
          ),
          Container(
            margin: const EdgeInsets.only(left: 15, top: 10),
            child: Row(
              children: [
                Text(
                  '$month월 $day일 $dayOfWeek',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.left,
                ),
              ]
            ),
          ),
          Expanded(
            child: tList.isEmpty
                ? const Center(
              child: Text('데이터가 없습니다.'),
            )
                : ListView.builder(
              itemCount: tList.length,
              itemBuilder: (c, i) {
                checkPriceColor(i);
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3 - 20,
                        child: Text(
                          tList[i].transactionCategory,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3 - 20,
                        child: Text(
                          tList[i].memo,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3 - 20,
                        child: Text(
                          '${NumberFormat('#,###').format(tList[i].price)}',
                          style: TextStyle(color: priceColor),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void checkPriceColor(int i) {
    if (tList[i].type == 0) {
      priceColor = Colors.red;
    } else {
      priceColor = Colors.blue;
    }
  }
}

Future<void> getCalendarDotData(int month, int year, String accessToken) async {
  var baseUrl = dotenv.env['BASE_URL'];
  var url = Uri.parse('$baseUrl/api/accountBooks/calendar');
  dotList = List.empty();

  try {
    final response = await http.get(
      url.replace(queryParameters: {'month': '$month', 'year': '$year'}),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );
    Map<String, dynamic> jsonMap = json.decode(utf8.decode(response.bodyBytes));
    CalendarDotResponse calendarDotResponse = CalendarDotResponse.fromJson(jsonMap);

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      dotList = calendarDotResponse.result.transactionArray;
      print('dotList = $dotList');
      print('데이터: $data');
    } else {
      final data = json.decode(utf8.decode(response.bodyBytes));
      print('데이터: $data');
      print('요청 실패: ${response.statusCode}');
      print('에러 메시지: $data');
    }
  } catch (e) {
    print('네트워크 오류: $e');
  }
}

Future<void> getCalendarAllData(int day, int month, int year, String accessToken) async {
  var baseUrl = dotenv.env['BASE_URL'];
  var url = Uri.parse('$baseUrl/api/transactions');
  tList = List.empty();

  try {
    final response = await http.get(
      url.replace(queryParameters: {'day': '$day', 'month': '$month', 'year': '$year'}),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    Map<String, dynamic> jsonMap = json.decode(utf8.decode(response.bodyBytes));
    TransactionsResponse transactionsResponse = TransactionsResponse.fromJson(jsonMap);

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      print(transactionsResponse.result.transactions);
      tList = transactionsResponse.result.transactions;
      print('tList = $tList');
      print('데이터: $data');
    } else {
      final data = json.decode(utf8.decode(response.bodyBytes));
      print('데이터: $data');
      print('요청 실패: ${response.statusCode}');
      print('에러 메시지: $data');
    }
  } catch (e) {
    print('네트워크 오류: $e');
  }
}

class Event {
  String title;
  Color color;

  Event(this.title, this.color);
}

class TableCalendarScreen extends StatefulWidget {
  final void Function(DateTime) onDateSelected;
  const TableCalendarScreen({Key? key, required this.onDateSelected}) : super(key: key);

  @override
  State<TableCalendarScreen> createState() => _TableCalendarScreenState();
}

class _TableCalendarScreenState extends State<TableCalendarScreen> {
  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  Map<DateTime, List<Event>> events = {};

  @override
  void initState() {
    super.initState();

    initializeData();
    setDotDate();
  }

  DateTime focusedDay = DateTime.now();


  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {

    return TableCalendar(
      locale: 'ko_KR',
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: focusedDay,
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      onDaySelected: _onDaySelected,
      onPageChanged: _onPageChanged,
      selectedDayPredicate: (DateTime day) {
        return isSameDay(selectedDay, day);
      },
      eventLoader: _getEventsForDay,
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = focusedDay;
    });
    await getCalendarAllData(selectedDay.day, selectedDay.month, selectedDay.year, accessToken);
    widget.onDateSelected(selectedDay);
  }

  void _onPageChanged(DateTime newMonth) async {
    DateTime newSelectedDay = DateTime(newMonth.year, newMonth.month, 1);
    selectedDay = newSelectedDay;
    _onDaySelected(selectedDay, selectedDay); // onDaySelected 호출
    await getCalendarDotData(selectedDay.month, selectedDay.year, accessToken);
    initEvent();
    setDotDate();
  }

  void setDotDate() {
    setState(() {
      for (int i = 0; i < dotList.length; i++) {
        if (dotList[i] == true) {
          Map<DateTime, List<Event>> map = {DateTime.utc(selectedDay.year, selectedDay.month, i) : [ Event('title', Colors.deepPurple) ]};
          events.addAll(map);
        }
      }
    });
  }

  void initEvent() {
    events = {};
  }
}

class CalendarDotResponse {
  final bool isSuccess;
  final String code;
  final String message;
  final Result result;

  CalendarDotResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.result,
  });

  factory CalendarDotResponse.fromJson(Map<String, dynamic> json) {
    return CalendarDotResponse(
      isSuccess: json['isSuccess'],
      code: json['code'],
      message: json['message'],
      result: Result.fromJson(json['result']),
    );
  }
}

class Result {
  final int lastDay;
  final List<bool> transactionArray;

  Result({
    required this.lastDay,
    required this.transactionArray,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      lastDay: json['lastDay'],
      transactionArray: List<bool>.from(json['transactionArray']),
    );
  }
}

class TransactionsResponse{
  final bool isSuccess;
  final String code;
  final String message;
  final Transactions result;

  TransactionsResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.result
  });

  factory TransactionsResponse.fromJson(Map<String, dynamic> json) {
    return TransactionsResponse(
      isSuccess: json['isSuccess'],
      code: json['code'],
      message: json['message'],
      result: Transactions.fromJson(json['result']),
    );
  }
}

class Transactions{
  final List<TransactionsResult> transactions;

  Transactions({
    required this.transactions
  });

  factory Transactions.fromJson(Map<String, dynamic> json) {
    return Transactions(
      transactions: (json['transactions'] as List<dynamic>)
          .map((item) => TransactionsResult.fromJson(item))
          .toList(),
    );
  }
}

class TransactionsResult{
  final int type;
  final String transactionCategory;
  final int year;
  final int month;
  final int day;
  final int price;
  final int payCategory;
  final String memo;

  TransactionsResult({
    required this.type,
    required this.transactionCategory,
    required this.year,
    required this.month,
    required this.day,
    required this.price,
    required this.payCategory,
    required this.memo
  });

  factory TransactionsResult.fromJson(Map<String, dynamic> json) {
    return TransactionsResult(
        type: json['type'],
        transactionCategory: json['transactionCategory'],
        year: json['year'],
        month: json['month'],
        day: json['day'],
        price: json['price'],
        payCategory: json['payCategory'],
        memo: json['memo']
    );
  }
}