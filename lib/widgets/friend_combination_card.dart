import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:forypldbauth/model/appuser.dart';
import 'package:forypldbauth/model/combination.dart';
import 'package:forypldbauth/model/element.dart';
import 'package:forypldbauth/network/api_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forypldbauth/state/state_management.dart';
import 'package:forypldbauth/values/strings.dart';

class FriendCombinationCard extends StatelessWidget {
  final Combination combination;

  FriendCombinationCard({Key key, this.combination}) : super(key: key);

  Future<List<MyElement>> _getElements(
      BuildContext context, int idCombination) async {
    var result = await fetchElementsByIdCombination(idCombination);

    return result;
  }

  Future<Appuser> _getUser(
      BuildContext context, String idUser) async {

    print('${context.read(userToken).state}');
    var result = await getUserDetail(context.read(userToken).state, idUser);

    return result;
  }


  @override
  Widget build(BuildContext context) {

    var heightMainElement = MediaQuery.of(context).size.height / 6 - 10;
    var heightSideElement = MediaQuery.of(context).size.height / 12 - 5;
    var widthMainElement = MediaQuery.of(context).size.width / 4 - 10;
    var widthSideElement = MediaQuery.of(context).size.width / 8 - 5;

    return GestureDetector(
      child: Card(
        elevation: 6, //6
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 8),
              child: FutureBuilder(
                future: _getUser(context,combination.idUser),
                builder: (ctx6, snapshot6){
                  if (snapshot6.connectionState == ConnectionState.none ||
                    snapshot6.connectionState == ConnectionState.waiting ||
                    snapshot6.hasData == false) {
                    return Text('friend name');
                  } else {
                    Appuser user6 =  snapshot6.data;
                    return Text(user6.name);
                  }
                },
              ),
            ),


            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  padding: EdgeInsets.all(0),
                  width: 200,
                  height: heightMainElement *2,
                  child: FutureBuilder(
                    //initialData: null,
                      future: _getElements(context, combination.idCombination),
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none ||
                            snapshot.connectionState == ConnectionState.waiting ||
                            snapshot.hasData == null) {
                          return Center(
                              child: Placeholder(
                                color: Colors.amberAccent,
                                fallbackHeight: 200.0,
                                fallbackWidth: 200.0,
                              ));

                        } else {

                          List<MyElement> elementsInCombination = snapshot.data;
                          List<MyElement> accessories = elementsInCombination
                              .where((element) => element.idCategory == 5).toList();

                          //combination
                          return Row(
                            children: [
                              (elementsInCombination.firstWhere(
                                      (element) => element.idCategory == 0,
                                  orElse: () {return null;}) != null)
                                  ? Container(
                                  height: heightMainElement * 2,
                                  width: widthMainElement,
                                  child: (elementsInCombination.firstWhere(
                                          (element) => element.idCategory == 0, orElse: () {
                                    return null;}) != null)
                                      ? Image.network(
                                    elementsInCombination
                                        .firstWhere((element) => element.idCategory == 0)
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
                                      child: (elementsInCombination.firstWhere((element) => element.idCategory == 2,
                                          orElse: (){return null;}) != null)
                                          ? Image.network(
                                        elementsInCombination
                                            .firstWhere((element) => element.idCategory == 2)
                                            .picPath,
                                        fit: BoxFit.contain,
                                      )
                                          : Container()
                                  ),
                                  Container(
                                    //color: Colors.red,
                                      height: heightMainElement,
                                      width: widthMainElement,
                                      child: (elementsInCombination.firstWhere((element) => element.idCategory == 3,
                                          orElse: (){return null;}) != null)
                                          ? Image.network(
                                        elementsInCombination
                                            .firstWhere((element) => element.idCategory == 3)
                                            .picPath,
                                        fit: BoxFit.contain,
                                      )
                                          : Container()
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
                                        //color: Colors.red,
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
                                      child: (elementsInCombination.firstWhere(
                                              (element) => element.idCategory == 1, orElse: () {
                                        return null;}) != null)
                                          ? Image.network(
                                        elementsInCombination
                                            .firstWhere((element) =>
                                        element.idCategory == 1)
                                            .picPath,
                                        fit: BoxFit.contain,
                                      )
                                          : Container()),
                                  Row(
                                    children: [
                                      //shoes
                                      Container(
                                        // color: Colors.red,
                                          height: heightSideElement,
                                          width: widthSideElement,
                                          child: (elementsInCombination.firstWhere(
                                                  (element) => element.idCategory == 4, orElse: () {
                                            return null;}) != null)
                                              ? Image.network(
                                            elementsInCombination
                                                .firstWhere((element) =>
                                            element.idCategory == 4)
                                                .picPath,
                                            fit: BoxFit.contain,
                                          )
                                              : Container()),
                                      //a2
                                      Container(
                                        //color: Colors.red,
                                          height: heightSideElement,
                                          width: widthSideElement,
                                          child: (accessories.length > 2)
                                              ? Image.network(
                                            accessories[2].picPath,
                                            fit: BoxFit.contain,
                                          )
                                              : Container()),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          );
                        }
                      }),
                ),
              ],
            ),

            //info
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                    '${combination.nameCombination}',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 4.0,
                  ), //4
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () async{
        var result = await findUser(
            combination.idUser, context.read(userToken).state);
        Appuser userModel;
        if (result == 'User Not found') {
          print('cannot get user bcs not found');
        } else {
          userModel = Appuser.fromJson(json.decode(result));
          Navigator.of(context).pushNamed(routeFriendProfile, arguments: {'Friend': userModel});
        }
      },
    );
  }
}
