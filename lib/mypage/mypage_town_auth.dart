import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:schrodinger_client/login/google_map_section.dart';
import 'package:schrodinger_client/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class Mypagetownauth extends StatefulWidget {
  const Mypagetownauth({super.key});

  @override
  State<Mypagetownauth> createState() => _MypagetownauthState();
}

class _MypagetownauthState extends State<Mypagetownauth> {
  late List<AddressInfo> GetAllList = []; //맨처음에 get으로 받아온거


  String townName = '검색중...';
  bool isMapLoaded = false;
  late TownAddress address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
              color: Colors.black
          ),
          leading:  IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.purple,
              icon: const Icon(Icons.arrow_back)),
          backgroundColor: Colors.white,
          title: const Center(
              child: Text('동네 인증하기', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                ),
                onPressed: (){},
                child: const Icon(Icons.help_outline_rounded, color: Colors.black)),
          ],
        ),
        body: Column(
          children: [
            SingleChildScrollView(
              child: GoogleMapSection(
                isMapLoaded: isMapLoaded,
                updateTownName: (TownAddress townAddress) {
                  setState(() {
                    townName = townAddress.dong;
                    address = townAddress;
                    isMapLoaded = true;
                  });
                },),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    // width: 200,
                    height: 120,
                    // color: Colors.red,
                    child: Text("현재 위치는 '$townName' 입니다.\n\n거주하시는 동네가 맞다면 아래 버튼을 눌러\n동네 인증을 완료해주세요."),
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.main,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.only(top: 16, bottom: 16, left: 90, right: 90)
                    ),
                    onPressed: isMapLoaded ? (){
                      getAll();
                    } : null,
                    child: const Text('동네인증 완료하기', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                )
              ],
            )
          ],
        )
    );
  }
  Future<void> getAll() async { //프로필 받아오는거 post
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    String url = '${dotenv.env['BASE_URL']}/api/users/location';

    Map<String, String> locationData = {
      "city": address.city,
      "dong": address.dong,
      "gu": address.gu,
    };


    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
      body: jsonEncode(locationData),

    );

    final res = jsonDecode(utf8.decode(response.bodyBytes));



    print(res);
    print(response.statusCode);//출력해봄 한번 시험으로


    if (res['isSuccess'] == false) {
      // 실패 시 다이얼로그 표시 후 현재 화면 유지
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("동네 수정 실패"),
            content: Text(res['message']),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text("확인"),
              ),
            ],
          );
        },
      );
    } else {
      // 성공 시 다이얼로그 표시 후 화면 닫기
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("동네 수정 성공"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("동네 정보가 성공적으로 수정되었습니다."),
                SizedBox(height: 10),
                Text("변경된 도시: ${res['result']['city']}"),
                Text("변경된 구: ${res['result']['gu']}"),
                Text("변경된 동: ${res['result']['dong']}"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context); // 이전 화면으로 돌아가기
                },
                child: Text("확인"),
              ),
            ],
          );
        },
      );
    }
    //final List<dynamic> responseResult = res['result'];
    List<AddressInfo> getall = [AddressInfo.fromJson(res)];

    setState(() {
      GetAllList = getall;
    });
  }

}



class AddressInfo {       ////json받아오는 형식
  final bool isSuccess;
  final String code;
  final String message;
  final ResultInfo result;

  AddressInfo({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.result,
  });

  factory AddressInfo.fromJson(Map<String, dynamic> json) {
    return AddressInfo(
      isSuccess: json['isSuccess'] ?? false,
      code: json['code'] ?? "",
      message: json['message'] ?? "",
      result: ResultInfo.fromJson(json['result'] ?? {}),
    );
  }
}

class ResultInfo {
  final int city;
  final int gu;
  final int dong;

  ResultInfo({
    required this.city,
    required this.gu,
    required this.dong,
  });

  factory ResultInfo.fromJson(Map<String, dynamic> json) {
    List<dynamic> expenseList = json['expense'] ?? [];

    return ResultInfo(
      city: json['city'] ?? 0,
      gu: json['gu'] ?? 0,
      dong: json['dong'] ?? 0,
    );
  }
}
