import 'package:flutter/material.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  final _controller = TextEditingController();
  String expenseamount = '';
  final _monthList = List.generate(11, (i)=>'${i+1}');
  final _dayList = List.generate(30, (i)=>'${i+1}');
  final _yearList = List.generate(30,(i)=> '${i+2000}');
  var _selectedmonthValue = '1';
  var _selecteddayValue = '1';
  var _selectedyearValue = '2000';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('2023/05/22'),
            IconButton(
              onPressed: () {

              },
              icon: Icon(Icons.expand_more),
            )

          ],

        ),
        actions: [
          IconButton(onPressed: (){
            Navigator.pushNamed(context,'/AccountBank');
          }, icon:Icon(Icons.close)),
        ],
      ),

      body: ListView(
        children: [
          SizedBox(height:40),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 240,
                child: TextField(
                  style: TextStyle(fontSize:30),
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Enter amount', // 힌트 텍스트 설정
                    suffixText: '원', // 입력란 뒤에 추가할 텍스트
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          SizedBox(height:80),
          Container(
            width: double.infinity,
            child: Text('날짜 선택',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                decoration: TextDecoration.combine([
                  TextDecoration.underline,
                  TextDecoration.overline,
                ]),
              ),
            ),
          ),
          SizedBox(height:20),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0,1.0,8.0,1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton( //뭔가를 선택했을때 리스트가 나오면서 그중하나 선택하게 하는 경우

                  value: _selectedyearValue,
                  items: _yearList.map(
                          (point) => DropdownMenuItem(
                          value: point,
                          child: Text(point))).toList(),
                  onChanged: (value){
                    setState(() {
                      _selectedyearValue = value!;
                    });
                  },
                ),
                Text('년', style: TextStyle(fontSize: 15)),
                DropdownButton( //뭔가를 선택했을때 리스트가 나오면서 그중하나 선택하게 하는 경우

                  value: _selectedmonthValue,
                  items: _monthList.map(
                          (point) => DropdownMenuItem(
                          value: point,
                          child: Text(point))).toList(),
                  onChanged: (value){
                    setState(() {
                      _selectedmonthValue = value!;
                    });
                  },
                ),
                Text('월', style: TextStyle(fontSize: 15)),
                DropdownButton( //뭔가를 선택했을때 리스트가 나오면서 그중하나 선택하게 하는 경우

                  value: _selecteddayValue,
                  items: _dayList.map(
                          (point) => DropdownMenuItem(
                          value: point,
                          child: Text(point))).toList(),
                  onChanged: (value){
                    setState(() {
                      _selecteddayValue = value!;
                    });
                  },
                ),
                Text('일', style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(30.0),
                child: TextButton(onPressed: (){
                  setState(() {
                    expenseamount = _controller.text.trim();
                  });
                  //여기에 현수꺼 코드 넣어서 날짜랑 금액 넘기면 됨.
                  Navigator.pushNamed(context, '/incomeCategory',
                      arguments:{'year':_selectedyearValue,
                        'month':_selectedmonthValue,'day':_selecteddayValue,'amount': expenseamount
                      }
                  );

                },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                    ),
                    child: Text('다음',
                      style: TextStyle(color: Colors.white),)),
              ),
            ],
          ),

        ],
      ),
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
            IconButton(onPressed: (){},icon: Icon(Icons.close)),
          ],
        ),
      ],

      content: Column(
        children: [
          Row(

          ),
        ],

      ),

    );
  }
}






