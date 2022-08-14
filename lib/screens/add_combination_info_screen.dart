import 'package:flutter/material.dart';
import 'package:forypldbauth/model/combination.dart';
import 'package:forypldbauth/model/element.dart';
import 'package:forypldbauth/model/occasion.dart';
import 'package:forypldbauth/state/state_management.dart';
import 'package:forypldbauth/values/strings.dart';
import 'package:forypldbauth/values/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forypldbauth/network/api_request.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AddCombinationInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddCombinationInfo();
}

class _AddCombinationInfo extends State<AddCombinationInfo> {
  Combination combinationCurrent;
  List<MyElement> accessories;

  //dropdown menu
  int selectedOccasion = 0;
  List<DropdownMenuItem<Occasion>> _dropdownMenuItems;
  Occasion _selectedItem;
  List<Occasion> _dropdownItems = occasionsAll;
  List<DropdownMenuItem<Occasion>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<Occasion>> items = List();
    for (Occasion listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.nameOccasion),
          value: listItem,
        ),
      );
    }
    return items;
  }

  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _selectedItem = _dropdownMenuItems[0].value;
  }

  TextEditingController _nameController = TextEditingController();
  TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final Map args = ModalRoute.of(context).settings.arguments as Map;
    if (args != null) {
      //if you passed object
      combinationCurrent = args['combination'];
      accessories = combinationCurrent.elementInCombinations
          .where((element) => element.idCategory == 5)
          .toList();
    }

    var heightMainElement = MediaQuery.of(context).size.height / 3;
    var heightSideElement = MediaQuery.of(context).size.height / 6;
    var widthMainElement = MediaQuery.of(context).size.width / 2;
    var widthSideElement = MediaQuery.of(context).size.width / 4;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Add some info'),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    //info
                    TextField(
                      controller: _nameController,
                      style: TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                          hintText: 'Name',
                          hintStyle: TextStyle(color: Colors.black87),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.amber))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 10.0, left: 10.0),
                      width: MediaQuery.of(context).size.width,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Occasion>(
                            value: _selectedItem,
                            items: _dropdownMenuItems,
                            onChanged: (value) {
                              setState(() {
                                _selectedItem = value;
                              });
                            }),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _noteController,
                      style: TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                          hintText: 'Note',
                          hintStyle: TextStyle(color: Colors.black87),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.amber))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),

              //combination
              Row(
                children: [
                  (combinationCurrent.elementInCombinations.firstWhere(
                              (element) => element.idCategory == 0, orElse: () {
                            return null;
                          }) !=
                          null)
                      ? Container(
                          height: heightMainElement * 2,
                          width: widthMainElement,
                          child: (combinationCurrent.elementInCombinations
                                      .firstWhere(
                                          (element) => element.idCategory == 0,
                                          orElse: () {
                                    return null;
                                  }) !=
                                  null)
                              ? Image.network(
                                  combinationCurrent.elementInCombinations
                                      .firstWhere(
                                          (element) => element.idCategory == 0)
                                      .picPath,
                                  fit: BoxFit.contain,
                                )
                              : Container())
                      : Column(
                          children: [
                            Container(
                                height: heightMainElement,
                                width: widthMainElement,
                                child: (combinationCurrent.elementInCombinations
                                            .firstWhere(
                                                (element) =>
                                                    element.idCategory == 2,
                                                orElse: () {
                                          return null;
                                        }) !=
                                        null)
                                    ? Image.network(
                                        combinationCurrent.elementInCombinations
                                            .firstWhere((element) =>
                                                element.idCategory == 2)
                                            .picPath,
                                        fit: BoxFit.contain,
                                      )
                                    : Container()),
                            Container(
                              height: heightMainElement,
                              width: widthMainElement,
                              child: (combinationCurrent.elementInCombinations
                                          .firstWhere(
                                              (element) =>
                                                  element.idCategory == 3,
                                              orElse: () {
                                        return null;
                                      }) !=
                                      null)
                                  ? Image.network(
                                      combinationCurrent.elementInCombinations
                                          .firstWhere((element) =>
                                              element.idCategory == 3)
                                          .picPath,
                                      fit: BoxFit.contain,
                                alignment: Alignment.topCenter,
                                    )
                                  : Container(),
                            ),
                          ],
                        ),
                  Column(
                    children: [
                      Row(
                        children: [
                          //a1
                          Container(
                              //color: Colors.red,
                              height: heightSideElement,
                              width: widthSideElement,
                              child: (accessories.length > 0)
                                  ? Image.network(
                                      accessories[0].picPath,
                                      fit: BoxFit.contain,
                                    )
                                  : Container()),
                          //a2
                          Container(
                              //color: Colors.orangeAccent,
                              height: heightSideElement,
                              width: widthSideElement,
                              child: (accessories.length > 1)
                                  ? Image.network(
                                      accessories[1].picPath,
                                      fit: BoxFit.contain,
                                    )
                                  : Container()),
                        ],
                      ),
                      //coat
                      Container(
                          height: heightMainElement,
                          width: widthMainElement,
                          child: (combinationCurrent.elementInCombinations
                                      .firstWhere(
                                          (element) => element.idCategory == 1,
                                          orElse: () {
                                    return null;
                                  }) !=
                                  null)
                              ? Image.network(
                                  combinationCurrent.elementInCombinations
                                      .firstWhere(
                                          (element) => element.idCategory == 1)
                                      .picPath,
                                  fit: BoxFit.contain,
                                )
                              : Container()),
                      Row(
                        children: [
                          //shoes
                          Container(
                              height: heightSideElement,
                              width: widthSideElement,
                              child: (combinationCurrent.elementInCombinations
                                          .firstWhere(
                                              (element) =>
                                                  element.idCategory == 4,
                                              orElse: () {
                                        return null;
                                      }) !=
                                      null)
                                  ? Image.network(
                                      combinationCurrent.elementInCombinations
                                          .firstWhere((element) =>
                                              element.idCategory == 4)
                                          .picPath,
                                      fit: BoxFit.contain,
                                    )
                                  : Container()),
                          Container(
                              height: heightSideElement,
                              width: widthSideElement,
                              child: (accessories.length > 2)
                                  ? Image.network(
                                      accessories[2].picPath,
                                      fit: BoxFit.contain,
                                    )
                                  : Container()),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        widthMainElement * 5 / 4, 15.0, 0.0, 15.0),
                    child: RaisedButton(
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.amberAccent,
                        onPressed: () async{
                          combinationCurrent.nameCombination =
                              _nameController.text;
                          combinationCurrent.note = _noteController.text;
                          combinationCurrent.idOccasion =
                              _selectedItem.idOccasion;
                          combinationCurrent.idUser =
                              context.read(userLogged).state.uid;
                          combinationCurrent.isPosted = false;

                          //log
//                          print(
//                              'mslg: ${combinationCurrent.nameCombination}, ${combinationCurrent.note}, '
//                              '${combinationCurrent.idOccasion}, ${combinationCurrent.idUser}, '
//                              '${combinationCurrent.isPosted}, ${combinationCurrent.nameCombination}     ');
//                          combinationCurrent.elementInCombinations
//                              .forEach((element) {
//                            print('msgl: info ${element.nameElement}');
//                          });

                          //add to bd
                          var result = await createCombinationApi(context.read(userToken).state, combinationCurrent);

//                          print('${result.toString()}');
                          if (result == 'Created'){
                            Alert(
                                context: context,
                                type: AlertType.success,
                                title: 'Success',
                                desc: 'The combination is successfully uploaded',
                                buttons: [
                                  DialogButton(
                                    child: Text('Go back'),
                                    onPressed: (){
                                      Navigator.pop(context); //close dialog
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                  )
                                ]
                            ).show();
                          }
                          else{
                            Alert(
                                context: context,
                                type: AlertType.error,
                                title: 'Uploading failed',
                                desc: result,
                                buttons: [
                                  DialogButton(
                                    child: Text('ok('),
                                    onPressed: (){
                                      Navigator.pop(context); //close dialog
                                    },
                                  )
                                ]
                            ).show();
                          }
                        }),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
