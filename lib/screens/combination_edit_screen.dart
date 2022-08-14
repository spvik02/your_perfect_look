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

class CombinationEditScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CombinationEditScreenState();
}

class _CombinationEditScreenState extends State<CombinationEditScreen> {
  Combination combinationCurrent;
  List<MyElement> accessories;


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

    _nameController.text = combinationCurrent.nameCombination;
    _nameController.selection = TextSelection.fromPosition(TextPosition(offset: _nameController.text.length));
    _noteController.text = (combinationCurrent.note == null) ? '' :combinationCurrent.note;
    _noteController.selection = TextSelection.fromPosition(TextPosition(offset: _noteController.text.length));

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
      body: SafeArea(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
                        //color: Colors.red,
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
                        //color: Colors.orangeAccent,
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
                        //color: Colors.orangeAccent,
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
                            //color: Colors.red,
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
                            //color: Colors.orangeAccent,
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
              //info
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      style: TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.amber))),
                      onSubmitted: (val) {
                        combinationCurrent.nameCombination = val;
                      },
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
                      onSubmitted: (val) {
                        combinationCurrent.note = val;
                      },
                    ),

                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        widthMainElement * 5 / 4, 0.0, 0.0, 15.0),
                    child: RaisedButton(
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.amber,
                        onPressed: () async{
                          print('edit ${combinationCurrent.idCombination}, ${combinationCurrent.nameCombination}, ${combinationCurrent.note}, '
                              '${combinationCurrent.idOccasion}, ${combinationCurrent.idUser}, ${combinationCurrent.isPosted}');
                          //put
                          var result = await putCombinationInfo(context.read(userToken).state,
                              combinationCurrent);

                          //check result
                          if (result == 'Updated'){
                            print('$result');
                          }
                          else{
                            print(' no updated $result');
                          }
                          Navigator.of(context).pop();
                        }),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      ));
  }
}
