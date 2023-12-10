import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:schrodinger_client/account/calendar/calendar_page.dart';
import 'package:schrodinger_client/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';


class AccountBank extends StatefulWidget {
  const AccountBank({super.key});


  @override
  State<AccountBank> createState() => _AccountBankState();
}

class _AccountBankState extends State<AccountBank> {

  late List<AccountBankInfo> GetAllList = []; //맨처음에 get으로 받아온거

  final _monthList = List.generate(12, (i)=>'${i+1}');//월 선택하기

  var _selectedmonthValue = '12';//맨처음에는 그냥 11월로 나오게 설정


  @override
  void initState() {
    super.initState();
    getAll();
  }

  @override
  Widget build(BuildContext context) {
    //final result = ModalRoute.of(context)?.settings.arguments as int? ?? 0;

    List<PieModel> model = getExpenseDataForPieChart();//파이차트비용가져오기

    // 소득, 예산 및 총 지출 받는 변수 선언
    int income = GetAllList.isNotEmpty ? GetAllList[0].result.income : 0;
    int budget = GetAllList.isNotEmpty ? GetAllList[0].result.budget : 0;
    int totalExpense = GetAllList.isNotEmpty
        ? GetAllList[0].result.expense.fold<int>(
        0, (previousValue, element) => previousValue + element.price) : 0;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '가계부',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20
              ),
            ),
          ),
        ),
        backgroundColor: AppColor.lightBlue,
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            offset: const Offset(0, 50),
            onSelected: (value) {
              if (value == 'expense') {
                Navigator.pushNamed(context, '/ExpensePage');
              } else if (value == 'income') {
                Navigator.pushNamed(context, '/IncomePage');
              } else if (value == 'budget') {
                Navigator.pushNamed(context, '/BudgetPage', arguments: int.parse(_selectedmonthValue));
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'expense',
                  child: Text('지출 내역 추가'),
                ),
                PopupMenuDivider(),
                const PopupMenuItem<String>(
                  value: 'income',
                  child: Text('수입 내역 추가'),
                ),
                PopupMenuDivider(),
                const PopupMenuItem<String>(
                  value: 'budget',
                  child: Text('예산 설정'),
                ),
              ];
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            icon: Icon(Icons.add),
          ),
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CalendarPage()));
              },
              icon: const Icon(Icons.calendar_month)
          )
        ],
      ),

      body:Column(
        children: [
          Container(//월 선택하기
            //padding: const EdgeInsets.fromLTRB(8.0,1.0,8.0,1.0),
            margin: EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [   //뭔가를 선택했을때 리스트가 나오면서 그중하나 선택하게 하는 경우
                DropdownButton(
                  value: _selectedmonthValue,
                  items: _monthList.map(
                        (point) => DropdownMenuItem(
                      value: point,
                      child: Text('$point월'),
                    ),
                  ).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedmonthValue = value!;
                      getAll();
                    });
                  },
                    underline: Container()
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.grey,
            height: 1,
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 지출 부분
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '지출',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        '${NumberFormat('#,###').format(totalExpense)}원',
                        style: const TextStyle(
                            fontSize: 15,
                            color: Colors.red
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 1, // 세로 선의 너비
                height: 50, // 세로 선의 높이
                color: Colors.grey, // 선의 색상
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '수입',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        '${NumberFormat('#,###').format(income)}원',
                        style: const TextStyle(
                            fontSize: 15,
                            color: Colors.blue
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Divider(
            color: Colors.grey,
            height: 1,
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          const SizedBox(
            height: 20,
          ),
          Card(
            color: const Color(0xFFFBD26C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5, // 그림자 크기
            child: Container(
              width: MediaQuery.of(context).size.width - 50,
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '이번달 남은 예산은 ${NumberFormat('#,###').format(budget)}원이에요',
                      style: const TextStyle(
                          fontSize: 15
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '너무 잘하고 있어요!',
                      style: TextStyle(
                          fontSize: 15
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          CustomPaint(
            size: const Size(200, 200),
            painter: _PieChart(model),
          ),
          const Divider(
            color: Colors.grey,
            height: 1,
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          _buildExpenseDetailsList(),
        ],
      ),
    );
  }

  Future<void> getAll() async { //맨처음에 get으로 받아오는거 1번
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    //String url = '${dotenv.env['BASE_URL']}/api/accountBooks/all';

    MonthYearRequest request = MonthYearRequest(year: 2023, month: int.parse(_selectedmonthValue));
    print(request.month);

    final url = '${dotenv.env['BASE_URL']}/api/accountBooks/all';
    final queryParameters = request.toJson();
    final queryParams = queryParameters.entries
        .map((entry) => '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value.toString())}')
        .join('&');
    final fullUrl = '$url?$queryParams';

    print(fullUrl);
    final response = await http.get(
      Uri.parse(fullUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );

    final res = jsonDecode(utf8.decode(response.bodyBytes));
    print(res);
    if (response.statusCode == 200) {
      //final dynamic responseResult = res['result'];
      List<AccountBankInfo> getall = [AccountBankInfo.fromJson(res)];
      print(response.statusCode);//잘되는지 테스트
      print(2);


      setState(() {
        GetAllList = getall;
      });
    } else {
      // 실패 시 /api/accountBooks/budget 로 POST 요청을 보냄.
      await createAccountBook();
    }
  }

  Future<void> createAccountBook() async {
    //맨처음에 가계부가 없어서 get실패시에 post로 가계부생성하는작업 수행하는 상황
    //budget 0으로 해서 가계부 생성
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    String url = '${dotenv.env['BASE_URL']}/api/accountBooks/budget';

    MonthYearRequest request = MonthYearRequest(year: 2023, month: int.parse(_selectedmonthValue));

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
      body: jsonEncode({
        'budget': 0,
        'month': request.month,
        'year': request.year,
      }),
    );

    final res = jsonDecode(utf8.decode(response.bodyBytes));

    print(response.statusCode);
    print(res['isSuccess']);
    print('post들어왔다가 나갔어용');

    if (response.statusCode == 200 && res['isSuccess']) {
      // 성공적으로 가계부를 생성한 경우, 새로운 정보를 받아옵니다.
      await getAll();
    } else {
      // 가계부 생성에 실패한 경우, 적절한 오류 처리를 진행합니다.
      print('Failed to create account book');
    }
  }

  //////////파이차트 부분표출하도록 하는 함수
  List<PieModel> getExpenseDataForPieChart() {
    // ExpenseItem 목록에서 PieModel 목록으로 변환
    List<ExpenseItem> expenseItems = GetAllList.isNotEmpty
        ? GetAllList[0].result.expense
        : [];

    // 총 지출액 계산
    int totalExpense = expenseItems.fold<int>(
        0, (previousValue, element) => previousValue + element.price);

    // 비율 얼마인지 계산
    List<PieModel> model = [];
    for (var expense in expenseItems) {
      double ratio = expense.price / totalExpense;
      model.add(PieModel(ratio: ratio, color: getExpenseCategoryColor(expense.transactionCategory)));
    }

    return model;
  }
  //////지금부터 추가한 항목들임 listtile로 지출내역 보여주기 위해서
  Widget _buildExpenseDetailsList() {
    List<ExpenseItem> expenseItems = GetAllList.isNotEmpty
        ? GetAllList[0].result.expense
        : [];

    int totalExpense = expenseItems.fold<int>(
        0, (previousValue, element) => previousValue + element.price);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: expenseItems.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            height: 40,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: getExpenseCategoryColor(expenseItems[index].transactionCategory),
                radius: 17.0,
              ),
              title: Text(expenseItems[index].transactionCategory),
              subtitle: Text('${(expenseItems[index].price / totalExpense * 100).toStringAsFixed(2)}%'),
              trailing: Text(
                  '${NumberFormat('#,###').format(expenseItems[index].price)}원',
                style: TextStyle(
                  fontSize: 16
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}



class MonthYearRequest {
  final int year;
  final int month;

  MonthYearRequest({
    required this.year,
    required this.month,
  });

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'month': month,
    };
  }
}

class AccountBankInfo {       ////json받아오는 형식
  final bool isSuccess;
  final String code;
  final String message;
  final ResultInfo result;

  AccountBankInfo({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.result,
  });

  factory AccountBankInfo.fromJson(Map<String, dynamic> json) {
    return AccountBankInfo(
      isSuccess: json['isSuccess'] ?? false,
      code: json['code'] ?? "",
      message: json['message'] ?? "",
      result: ResultInfo.fromJson(json['result'] ?? {}),
    );
  }
}

class ResultInfo {
  final int expenditure;
  final int income;
  final int budget;
  final List<ExpenseItem> expense;

  ResultInfo({
    required this.expenditure,
    required this.income,
    required this.budget,
    required this.expense,
  });

  factory ResultInfo.fromJson(Map<String, dynamic> json) {
    List<dynamic> expenseList = json['expense'] ?? [];
    List<ExpenseItem> expenseItems = expenseList
        .map((expense) => ExpenseItem.fromJson(expense))
        .toList();
    return ResultInfo(
      expenditure: json['expenditure'] ?? 0,
      income: json['income'] ?? 0,
      budget: json['budget'] ?? 0,
      expense: expenseItems,
    );
  }
}

class ExpenseItem {
  final String transactionCategory;
  final int price;

  ExpenseItem({
    required this.transactionCategory,
    required this.price,
  });

  factory ExpenseItem.fromJson(Map<String, dynamic> json) {
    return ExpenseItem(
      transactionCategory: json['transactionCategory'] ?? '',
      price: json['price'] ?? 0,
    );
  }
}


class Dialog extends StatelessWidget {//오른쪽 상단에 + 버튼눌렀을때 나오는거
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
            Navigator.pushNamed(context, '/ExpensePage',);
          }, child: const Text('지출 내역 추가'),),
          ElevatedButton(onPressed:(){//버튼 누르면 수입내역으로 넘어감
            Navigator.pop(context);
            Navigator.pushNamed(context,'/IncomePage');
          }, child: const Text('수입 내역 추가'),),
          ElevatedButton(onPressed:(){ //버튼 누르면 예산설정페이지로 넘어감.
            Navigator.pop(context);
            Navigator.pushNamed(context, '/BudgetPage');
          }, child: const Text('예산 설정'),),

        ],
      ),

    );
  }
}


class PieModel {
  final double ratio; // 비율 추가
  final Color color;

  PieModel({
    required this.ratio,
    required this.color,
  });
}

class _PieChart extends CustomPainter {
  final List<PieModel> data;

  _PieChart(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    Paint circlePaint = Paint()..color = Colors.white;
    Paint shadowPaint = Paint()
      ..color = Colors.grey.withOpacity(0.5) // 그림자 색상 및 투명도
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    Offset offset = Offset(size.width / 2, size.width / 2); //원의 중심좌표
    double radius = (size.width / 2) * 0.8;

    canvas.drawCircle(offset, radius, shadowPaint);//그래프에 그림자 그리기
    canvas.drawCircle(offset, radius, circlePaint);

    double _startPoint = 0.0;
    for (int i = 0; i < data.length; i++) {
      double _startAngle = 2 * math.pi * data[i].ratio; // 비율로 계산
      double _nextAngle = 2 * math.pi * data[i].ratio;
      circlePaint.color = data[i].color;

      canvas.drawArc(
        Rect.fromCircle(center: Offset(size.width / 2, size.width / 2), radius: radius),
        -math.pi / 2 + _startPoint,
        _nextAngle,
        true,
        circlePaint,
      );
      _startPoint = _startPoint + _startAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // 데이터가 변경되면 다시 그려야 하도록 수정
    if (oldDelegate is _PieChart) {
      return !listEquals(data, oldDelegate.data);
    }
    return false;
  }
}




Color getExpenseCategoryColor(String category) {  //카테고리 색 정하기
  switch (category) {
    case '식비':
      return const Color(0xffFF6161);
    case '카페/간식':
      return const Color(0xffFF9F69);
    case '교통':
      return const Color(0xff69FFC9);
    case '술/유흥':
      return const Color(0xffFFF069);
    case '기타':
      return const Color(0xff727272);
    default:
      return Colors.grey; // 기본값은 회색으로 지정
  }
}



