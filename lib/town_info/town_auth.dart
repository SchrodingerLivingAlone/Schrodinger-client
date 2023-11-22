import 'package:flutter/material.dart';
import 'package:schrodinger_client/style.dart';

class TownAuthPage extends StatefulWidget {
  const TownAuthPage({super.key});

  @override
  State<TownAuthPage> createState() => _TownAuthPageState();
}

class _TownAuthPageState extends State<TownAuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.black
        ),
        leading:  IconButton(
            onPressed: () {
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
      body: Row(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.bottomRight,
          children: [
            Container(
              height: 300,
              color: Colors.grey,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.yellow,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(5)
                  ),
                  onPressed: (){},
                  child: const SizedBox(
                    width: 60,
                    height: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.place),
                        Text('현재위치', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  )
              )
            )

        ],
      )


          )
        ],
      )
    );
  }
}

