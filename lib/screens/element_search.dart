import 'package:flutter/material.dart';
import 'package:forypldbauth/model/category.dart';
import 'package:forypldbauth/model/element.dart';
import 'package:forypldbauth/state/state_management.dart';
import 'package:forypldbauth/values/app_icons.dart';
import 'package:forypldbauth/network/api_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forypldbauth/widgets/element_card.dart';

class SearchElement extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StateSearchElement();
}

class _StateSearchElement extends State<SearchElement> {
  String _name;
  final searchController = TextEditingController();

  int selectedCategory = 6;
  List<DropdownMenuItem<ElementCategory>> _dropdownMenuItems;
  ElementCategory _selectedItem;
  List<ElementCategory> _dropdownItems  = <ElementCategory>[
    ElementCategory.withIcon(0, 'Dresses', categoryIconsPaths[0]),
    ElementCategory.withIcon(1, 'Coats', categoryIconsPaths[1]),
    ElementCategory.withIcon(2, 'Tops', categoryIconsPaths[2]),
    ElementCategory.withIcon(3, 'Bottoms', categoryIconsPaths[3]),
    ElementCategory.withIcon(4, 'Shoes', categoryIconsPaths[4]),
    ElementCategory.withIcon(5, 'Accessory', categoryIconsPaths[5]),
    ElementCategory.withIcon(6, 'All', categoryIconsPaths[0]),
  ];
  List<DropdownMenuItem<ElementCategory>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ElementCategory>> items = List();
    for (ElementCategory listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Center(child: Text(listItem.nameCategory)),
          value: listItem,
        ),
      );
    }
    return items;
  }

  Future<List<MyElement>> _getItems(
      BuildContext context, String name) async {
    var result = await fetchElementsSearch(context.read(userLogged).state.uid, _selectedItem.idCategory, name);
    return result;
  }

  @override
  initState(){
    super.initState();
    _name='';
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _selectedItem = _dropdownMenuItems[6].value;
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.amberAccent,
          leading: IconButton(
            icon: Icon(Icons.keyboard_arrow_left),
            onPressed: () => Navigator.pop(context),
          ),
          title: Padding(
            padding: EdgeInsets.only(top: 10),
            child: TextField(
              controller: searchController,
              autofocus: false,
              decoration: InputDecoration(
                hintText: " Search...",
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  color: Colors.white,
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    setState((){
                      _name = searchController.text;
                    });
                  },
                ),
              ),
            ),
          )
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 5, left: 10, right: 10),
              width: MediaQuery.of(context).size.width,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<ElementCategory>(
                    value: _selectedItem,
                    items: _dropdownMenuItems,
                    onChanged: (value) {
                      setState(() {
                        _selectedItem = value;
                      });
                    }),),
            ),
            Expanded(
              child:
              FutureBuilder(
                future: _getItems(context, _name),
                builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.none ||
                        snapshot.connectionState == ConnectionState.waiting
                    ) {
                      return Center(child: CircularProgressIndicator());
                    }
                    else {
                      if (snapshot.hasData == false || snapshot.data == null) {return Center(child: Text('Nothing'));}
                      else{

                        List<MyElement> elements = snapshot.data;

                        return GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          childAspectRatio: 0.6, //46
                          children: elements.map((e)=> ElementCard(element:e)).toList()
                        );
                      }
                    }
                }
                    )
            ),
          ],
        )
      ),
    );
  }
  
}