import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:schrodinger_client/post/post_info.dart';
import 'package:schrodinger_client/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:schrodinger_client/style.dart';
import '../town_info/food_info.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late List<AccountBankInfo> GetAllList = [];

  String schrodinger = "Schrodinger's Living Alone";
  late List<TownInfo> hottestPlace = [];

  @override
  void initState() {
    super.initState();
    initHome();
    getAll();
  }

  void initHome() async {
    await getHotPlaces();
  }

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

  //인기글 Api 통신 함수
  Future<void> getHotPlaces() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    String url = '${dotenv.env['BASE_URL']}/api/neighborhood/posts?sortBy=3&category=3';

    final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        }
    );

    final res = jsonDecode(utf8.decode(response.bodyBytes));
    print(res['result']);
    final List<dynamic> responseResult = res['result'];
    List<TownInfo> hotplaces = responseResult.map((data) => TownInfo.fromJson(data)).toList();

    setState(() {
      int i = hotplaces.length;
      if(i > 5){
        hottestPlace = hotplaces.sublist(0, 5);
      }else{
        hottestPlace = hotplaces.sublist(0, i);
      }
      print(hottestPlace);
    });
  }

  //인기글 위젯 생성 함수
  Widget buildHotPlace(BuildContext context, TownInfo hotplace) {
    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostInfo(PostId: hotplace.id),
          ),
        );
        getHotPlaces();
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8, top: 5, bottom: 10),
        child: Container(
          width: 130,
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 3,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: NetworkImage(hotplace.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  hotplace.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.comment,
                    size: 16.0,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    '${hotplace.commentCount}개 댓글',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                    ),
                  ),
                  const SizedBox(width: 15.0),
                  const Icon(
                    Icons.remove_red_eye,
                    size: 16.0,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    '${hotplace.view}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<PieModel> model = getExpenseDataForPieChart();//파이차트비용가져오기

    int income = GetAllList.isNotEmpty ? GetAllList[0].result.income : 0;
    int budget = GetAllList.isNotEmpty ? GetAllList[0].result.budget : 0;
    int totalExpense = GetAllList.isNotEmpty
        ? GetAllList[0].result.expense.fold<int>(
        0, (previousValue, element) => previousValue + element.price) : 0;

    return DefaultTabController(
        length: 7,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColor.lightBlue,
            title: Text(schrodinger),
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Card(
                    color: const Color(0xFFFBD26C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5, // 그림자 크기
                    child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                    '이번달 예산',
                                  style: TextStyle(
                                    fontSize: 15
                                  ),
                                ),
                                Text(
                                    '${NumberFormat('#,###').format(budget)}원',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.blue
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
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
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
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
                          )

                        ],
                      ),
                    ),
                  ),
                  Stack(
                    children: [

                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: MediaQuery.of(context).size.width, // 화면 좌우로 확장
                        child: Card(
                          elevation: 3,
                          child: Container(
                            height: 200,
                            child: Center(
                              child: CustomPaint(
                                size: Size(200, 200),
                                painter: _PieChart(model),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16.0, 8, 8, 0),
                          child: Row(
                              children : [
                                Icon(Icons.local_fire_department, color: Colors.red,),
                                Text('오늘의 인기글', style: TextStyle(
                                  fontWeight: FontWeight.bold,),),
                              ]
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SingleChildScrollView(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: hottestPlace.map((data) {
                              return buildHotPlace(context, data);
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }

  Future<void> getAll() async { //맨처음에 get으로 받아오는거 1번
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    //String url = '${dotenv.env['BASE_URL']}/api/accountBooks/all';

    MonthYearRequest request = MonthYearRequest(year: 2023, month: DateTime.now().month);
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



    MonthYearRequest request = MonthYearRequest(year: 2023, month: DateTime.now().month);

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