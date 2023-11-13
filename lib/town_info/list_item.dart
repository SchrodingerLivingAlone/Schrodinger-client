import 'package:flutter/material.dart';
import 'package:schrodinger_client/style.dart';

class ListItem extends StatefulWidget {
  final String title;
  const ListItem({Key?key, required this.title}) : super(key: key);

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25, right: 10, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.title, style: const TextStyle(fontSize: 20)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                    )
                ),
                onPressed: (){},
                child:const Text('더보기 >', style: TextStyle(fontSize: 15, color: Colors.grey)),
              ),
            ],
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
        Container(
            height: 10,
            color: AppColor.lightGrey
        ),
      ],
    );
  }
}



