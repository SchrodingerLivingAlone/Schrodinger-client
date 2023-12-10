import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:schrodinger_client/account/accountbank.dart';
import 'package:schrodinger_client/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:schrodinger_client/style.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  final _expenditurecontroller = TextEditingController(); //이번달 예산 입력변수
  @override
  void dispose(){
    _expenditurecontroller.dispose();
    super.dispose();
  }
  var expenditure =0;
  var day =0;

  late List<BudgetResponse> PutAllList = []; //맨처음에 get으로 받아온거


  @override
  Widget build(BuildContext context) {

    //가게부 홈에서 선택한 월 받아오기.
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('예산 설정')),
        backgroundColor: AppColor.lightBlue,
        actions: [
          TextButton(onPressed: (){
            putAll();  //버튼 누르면 이거 동작******************************
            Navigator.pushNamed(context,'/home');
          },
              child: const Text('저장',style: TextStyle(color:Colors.white))
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(27.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20,),
              const Text('이번달 예산을 입력해주세요.',style: TextStyle(fontWeight:FontWeight.bold, fontSize: 20)),
              Container(
                height: 20,
              ),
              const Center(child: Text('지난달보다 절약해보는건 어떨까요?🔥', style: TextStyle(color: Colors.grey),)),
              Container(
                height: 20,
              ),
              Container(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex:20,
                    child: TextField(
                      style: const TextStyle(fontSize:20),
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                        labelText: '금액을 입력하세요',
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                      controller: _expenditurecontroller,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          expenditure = int.tryParse(value) ?? 0;
                          day = expenditure~/30;
                        });
                      },
                    ),
                  ),
                  const Expanded(
                      flex:1,
                      child: Text('원',style: TextStyle(fontWeight:FontWeight.bold, fontSize: 25,color:Colors.black))),
                ],
              ),


              Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      const Text(
                          '하루에 대략',
                          style: TextStyle(
                              fontSize:15
                          )
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('$day원',style: const TextStyle(fontWeight: FontWeight.bold, color: AppColor.lightBlue,fontSize:15)),
                          const Text('을 사용할 수 있어요!', style: TextStyle(fontSize:15))
                        ],
                      ),
                    ],
                  )
              ),


            ],
          ),
        ),

      ),
    );
  }

  Future<void> putAll() async { //프로필 받아오는거 post
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    String url = '${dotenv.env['BASE_URL']}/api/accountBooks/budget';
    final month = ModalRoute.of(context)?.settings.arguments as int? ?? 0;
    print(month);
    MonthYearRequest request = MonthYearRequest(year: 2023, month: month);//지금은 월지정

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
      body: jsonEncode({
        'budget': expenditure,
        'month': request.month,
        'year': request.year,
      }),
    );

    final res = jsonDecode(utf8.decode(response.bodyBytes));

    print(res);
    print('예산입력 잘 되었어요.');
    //final List<dynamic> responseResult = res['result'];
    List<BudgetResponse> putall = [BudgetResponse.fromJson(res)];

    setState(() {
      PutAllList = putall;
    });
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

class BudgetResponse {  //예산정보 받아오는 부분
  final bool isSuccess;
  final String code;
  final String message;
  final BudgetResult result;

  BudgetResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.result,
  });

  factory BudgetResponse.fromJson(Map<String, dynamic> json) {
    return BudgetResponse(
      isSuccess: json['isSuccess'],
      code: json['code'],
      message: json['message'],
      result: BudgetResult.fromJson(json['result']),
    );
  }
}

class BudgetResult {  //프로필정보에서 결과값받아오는 부분.
  final int budget;
  final String year;
  final String month;

  BudgetResult({
    required this.budget,
    required this.year,
    required this.month,
  });

  factory BudgetResult.fromJson(Map<String, dynamic> json) {
    return BudgetResult(
      budget: json['budget'],
      year: json['year'],
      month: json['month'],
    );
  }
}




