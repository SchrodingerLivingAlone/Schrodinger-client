import 'package:flutter/material.dart';
import 'package:schrodinger_client/style.dart';

class HomeInfoPage extends StatefulWidget {
  const HomeInfoPage({super.key});

  @override
  State<HomeInfoPage> createState() => _HomeInfoPageState();
}

class _HomeInfoPageState extends State<HomeInfoPage> {
  int sortIndex = 0;
  final sortCategory = ['카테고리', '최신순', '인기순'];

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        ListView(
          children: [
            Stack(
              alignment: Alignment.centerRight,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    width: 120, // <-- Your width
                    height: 50,
                    child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.yellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                        ),
                      ),
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      value: sortIndex,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      items: List.generate(3, (i){
                      return DropdownMenuItem(
                        value: i,
                        child: Text(sortCategory[i]),
                        );
                      }),
                      onChanged: (value){
                      setState(() {
                        sortIndex = value!;
                        });
                      },
                      validator: (value){
                      if(value == 0){
                        return 'Please select the sort';
                        }
                        return null;
                        },
                      selectedItemBuilder: (BuildContext context) { //<-- SEE HERE
                        return sortCategory.map((String value) {
                          return Text(
                            value,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16
                              ),
                          );
                        }).toList();
                      }),

                    onPressed: (){},
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top:10, bottom: 10),
              child: ListTile(
                title: const Text('기대치에 못미쳤던.. 백미당 후기'),
                subtitle: const Text('유명한 백미당에 가봤는데 후기에서 봤던거랑 다르게...'),
                trailing: const Icon(Icons.square, size: 50),
                onTap: (){},
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:10, bottom: 10),
              child: ListTile(
                title: const Text('기대치에 못미쳤던.. 백미당 후기'),
                subtitle: const Text('유명한 백미당에 가봤는데 후기에서 봤던거랑 다르게...'),
                trailing: const Icon(Icons.square, size: 50),
                onTap: (){},
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:10, bottom: 10),
              child: ListTile(
                title: const Text('기대치에 못미쳤던.. 백미당 후기'),
                subtitle: const Text('유명한 백미당에 가봤는데 후기에서 봤던거랑 다르게...'),
                trailing: const Icon(Icons.square, size: 50),
                onTap: (){},
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:10, bottom: 10),
              child: ListTile(
                title: const Text('기대치에 못미쳤던.. 백미당 후기'),
                subtitle: const Text('유명한 백미당에 가봤는데 후기에서 봤던거랑 다르게...'),
                trailing: const Icon(Icons.square, size: 50),
                onTap: (){},
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:10, bottom: 10),
              child: ListTile(
                title: const Text('기대치에 못미쳤던.. 백미당 후기'),
                subtitle: const Text('유명한 백미당에 가봤는데 후기에서 봤던거랑 다르게...'),
                trailing: const Icon(Icons.square, size: 50),
                onTap: (){},
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:10, bottom: 10),
              child: ListTile(
                title: const Text('기대치에 못미쳤던.. 백미당 후기'),
                subtitle: const Text('유명한 백미당에 가봤는데 후기에서 봤던거랑 다르게...'),
                trailing: const Icon(Icons.square, size: 50),
                onTap: (){},
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:10, bottom: 10),
              child: ListTile(
                title: const Text('기대치에 못미쳤던.. 백미당 후기'),
                subtitle: const Text('유명한 백미당에 가봤는데 후기에서 봤던거랑 다르게...'),
                trailing: const Icon(Icons.square, size: 50),
                onTap: (){},
              ),
            ),
          ],
        ),

        ListTile(
          leading: const Icon(Icons.search),
          title: const Text('Search'),
          trailing: const Icon(Icons.navigate_next),
          onTap: (){},
        ),
        ListTile(
          leading: const Icon(Icons.refresh),
          title: const Text('Refresh'),
          trailing: const Icon(Icons.navigate_next),
          onTap: (){},
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          trailing: const Icon(Icons.navigate_next),
          onTap: (){},
        ),
        ListTile(
          leading: const Icon(Icons.search),
          title: const Text('Search'),
          trailing: const Icon(Icons.navigate_next),
          onTap: (){},
        ),
        ListTile(
          leading: const Icon(Icons.refresh),
          title: const Text('Refresh'),
          trailing: const Icon(Icons.navigate_next),
          onTap: (){},
        ),
        ListTile(
          leading: const Icon(Icons.refresh),
          title: const Text('ㅁㄴㅇㅁㄴㅇㅁㄴ'),
          trailing: const Icon(Icons.navigate_next),
          onTap: (){},
        ),
      ],
    );
  }
}



