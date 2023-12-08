import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:schrodinger_client/style.dart';
import 'package:schrodinger_client/town_info/home_info.dart';
import 'package:schrodinger_client/town_info/food_info.dart';
import 'package:schrodinger_client/town_info/facility_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  bool isCompleted = false;
  String schrodinger = "Schrodinger's Living Alone";

  @override
  void initState(){
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 7,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColor.main,
            title: Text(schrodinger),
          ),
          body: Column(
            children: [
              SizedBox(
                child: Text('가계부 예산 부분'),
              ),
              SizedBox(
                child: Text('가계부 그래프 부분'),
              ),
              Row(
                children: [
                  Row(
                    children : [
                      Icon(Icons.local_fire_department, color: Colors.red,),
                      Text('오늘의 동네 핫플')
                    ]
                  )
                ]
              ),
            ],
          ),
        )
    );
  }
}