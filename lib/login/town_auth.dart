import 'package:flutter/material.dart';
import 'package:schrodinger_client/login/google_map_section.dart';
import 'package:schrodinger_client/style.dart';

class TownAuthPage extends StatefulWidget {
  const TownAuthPage({super.key});

  @override
  State<TownAuthPage> createState() => _TownAuthPageState();
}

class _TownAuthPageState extends State<TownAuthPage> {
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
                    Navigator.pushNamed(context, '/join', arguments: address);
                  } : null,
                  child: const Text('동네인증 완료하기', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
              )
            ],
          )
        ],
      )
    );
  }
}
