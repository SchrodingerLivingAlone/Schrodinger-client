import 'package:flutter/material.dart';
import 'package:schrodinger_client/account/accountbank.dart';
import 'package:schrodinger_client/account/expense_category_page.dart';
import 'package:schrodinger_client/provider/account_provider.dart';
import 'package:schrodinger_client/style.dart';
import 'package:provider/provider.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  final _controller = TextEditingController();
  String expenseamount = '';
  final _monthList = List.generate(12, (i)=>'${i+1}');
  List<String> _dayList = [];
  final _yearList = List.generate(30,(i)=> '${i+2000}');
  var _selectedmonthValue = '12';
  var _selecteddayValue = '1';
  var _selectedyearValue = '2023';

  @override
  void initState() {
    super.initState();

    _updateDayList();
  }

  void _updateDayList() {
    _dayList = _generateDayList(_selectedyearValue, _selectedmonthValue);
    _selecteddayValue = _dayList.isNotEmpty ? _dayList[0] : '1';
  }

  List<String> _generateDayList(String year, String month) {
    int daysInMonth = DateTime(int.parse(year), int.parse(month) + 1, 0).day;
    return List.generate(daysInMonth, (i) => '${i + 1}');
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (BuildContext context) => ExpenseItemProvider(),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: Text('$_selectedyearValue.$_selectedmonthValue.$_selecteddayValue의 지출 내역', style: TextStyle(fontSize: 18),),
          centerTitle: true,
          backgroundColor: AppColor.lightBlue,
          actions: [
            IconButton(onPressed: (){
              Navigator.pushNamed(context,'/AccountBank');
            }, icon:const Icon(Icons.close)),
          ],
        ),

        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height:80),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text('금액을 입력해주세요.', style: TextStyle(fontSize: 15, color: Colors.grey),
                          )
                      ),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: TextField(
                      style: const TextStyle(fontSize:25),
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: '금액 입력', // 힌트 텍스트 설정
                        suffixText: '원', // 입력란 뒤에 추가할 텍스트
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height:30),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Text('날짜를 선택해주세요.', style: TextStyle(fontSize: 15, color: Colors.grey),
                      )
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width - 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [   //뭔가를 선택했을때 리스트가 나오면서 그중하나 선택하게 하는 경우
                    Row(
                      children: [
                        DropdownButton(
                          value: _selectedyearValue,
                          items: _yearList.map(
                                (point) => DropdownMenuItem(
                              value: point,
                              child: Text(point),
                            ),
                          ).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedyearValue = value!;
                              _updateDayList();
                            });
                          },
                        ),
                        const Text('년', style: TextStyle(fontSize: 15)),
                      ],
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Row(
                      children: [
                        DropdownButton(
                          value: _selectedmonthValue,
                          items: _monthList.map(
                                (point) => DropdownMenuItem(
                              value: point,
                              child: Text(point),
                            ),
                          ).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedmonthValue = value!;
                              _updateDayList();
                            });
                          },
                        ),
                        const Text('월', style: TextStyle(fontSize: 15)),
                      ],
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Row(
                      children: [
                        DropdownButton(
                          value: _selecteddayValue,
                          items: _dayList.map(
                                (point) => DropdownMenuItem(
                              value: point,
                              child: Text(point),
                            ),
                          ).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selecteddayValue = value!;
                            });
                          },
                        ),
                        const Text('일', style: TextStyle(fontSize: 15)),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    width: MediaQuery.of(context).size.width - 40,
                    child: TextButton(onPressed: (){
                      setState(() {
                        expenseamount = _controller.text.trim();
                      });
                      //여기에 현수꺼 코드 넣어서 날짜랑 금액 넘기면 됨.
                      Navigator.pushNamed(context, '/expenseCategory',
                          arguments:{'year':_selectedyearValue,
                            'month':_selectedmonthValue,'day':_selecteddayValue,'amount': expenseamount
                          }
                      );
                      context.read<ExpenseItemProvider>().year = int.parse(_selectedyearValue);
                      context.read<ExpenseItemProvider>().month = int.parse(_selectedmonthValue);
                      context.read<ExpenseItemProvider>().day = int.parse(_selecteddayValue);
                      context.read<ExpenseItemProvider>().price = int.parse(expenseamount);

                      print('프로바이더에 저장');
                      print(context.read<ExpenseItemProvider>().year);
                      print(context.read<ExpenseItemProvider>().month);
                      print(context.read<ExpenseItemProvider>().day);
                      print(context.read<ExpenseItemProvider>().price);
                    },
                        style: TextButton.styleFrom(
                          backgroundColor: AppColor.lightBlue,
                        ),
                        child: const Text('다음',
                          style: TextStyle(color: Colors.white),)),
                  ),
                ],
              ),

            ],
          ),
        ),
      )
    );
  }
}

class BottomDialog extends StatelessWidget {
  const BottomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      actions: [
        Column(
          children: [
            IconButton(onPressed: (){},icon: const Icon(Icons.close)),
          ],
        ),
      ],

      content: const Column(
        children: [
          Row(

          ),
        ],

      ),

    );
  }
}






