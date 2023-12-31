import 'package:flutter/material.dart';
import 'package:schrodinger_client/style.dart';

class CategoryDropdown extends StatefulWidget {
  late final Function setSortedIndex;
  CategoryDropdown({super.key, required this.setSortedIndex});

  @override
  State<CategoryDropdown> createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  int index = 0;
  final sortCategory = ['최신순', '인기순', '조회순'];

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                  value: index,
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
                    widget.setSortedIndex(value);
                    setState(() {
                      index = value!;
                    });
                  },
                  validator: (value){
                    if(value == 0){
                      return 'Please select the sort';
                    }
                    return null;
                  },
                  selectedItemBuilder: (BuildContext context) {
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
    );
  }
}



