import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('예산 설정')),
        actions: [
          TextButton(onPressed: (){
              Navigator.pushNamed(context,'/AccountBank',arguments: expenditure);
          },
              child: const Text('저장',style: TextStyle(color:Colors.white))),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(27.0),
        child: Center(
          child: ListView(
            children: [
              const Text('이번달 예산을 입력해주세요.',style: TextStyle(fontWeight:FontWeight.bold, fontSize: 30)),
              Container(
                height: 20,
              ),
              const Center(child: Text('지난달보다 절약해보는건 어떨까요?')),
              Container(
                height: 20,
              ),
              Container(
                height: 40,
              ),
              Row(
                children: [
                  Expanded(
                    flex:5,
                    child: TextField(
                      style: const TextStyle(fontSize:30),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '금액을 입력하세요',

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
                      child: Text('원',style: TextStyle(fontWeight:FontWeight.bold, fontSize: 40,color:Colors.deepPurple))),
                ],
              ),


              const Center(child: Text('하루에 대략', style: TextStyle(fontSize:15))),
              Container(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$day원',style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple,fontSize:15)),
                  const Text('을 사용할 수 있어요!', style: TextStyle(fontSize:15))
                ],
              ),
            ],
          ),
        ),

      ),
    );
  }
}





