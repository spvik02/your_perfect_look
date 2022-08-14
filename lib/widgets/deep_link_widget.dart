import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forypldbauth/model/appuser.dart';
import 'package:forypldbauth/model/combination.dart';
import 'package:forypldbauth/model/element.dart';
import 'package:forypldbauth/state/state_management.dart';
import 'package:forypldbauth/network/api_request.dart';

class DeepLinkWidget extends StatelessWidget{
  final String val;

  DeepLinkWidget({Key key, this.val}) : super(key: key);

  int idCombination;


  Future<Appuser> _getUserDetail(BuildContext context, String idUser) async {

    final user = context.read(userLogged).state;
    final token = await user.getIdToken();

    var result = await getUserDetail(token, idUser);

    return result;
  }

  @override
  Widget build(BuildContext context) {

    var uri = Uri.dataFromString(val);
    idCombination = int.tryParse(uri.pathSegments[3]);

    var heightMainElement = MediaQuery.of(context).size.height / 3 - 8;
    var heightSideElement = MediaQuery.of(context).size.height / 6;
    var widthMainElement = MediaQuery.of(context).size.width / 2 - 4;
    var widthSideElement = MediaQuery.of(context).size.width / 4 - 2;

    
    return Scaffold(
        body:SafeArea(
          child: Container(
            color:Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder(
                    future: fetchCombination(idCombination),
                    builder: (context1, snapshot1) {
                      if (snapshot1.connectionState == ConnectionState.none ||
                        snapshot1.connectionState == ConnectionState.waiting ||
                        snapshot1.hasData == false) {
                        return Center(
                          child: Text('wait'),
                        );}
                      else {
                        if (snapshot1.data == null) {
                            return Container(
                            child: Text('it seems nothing here'),);}
                        else {
                          Combination combinationResult = snapshot1.data;
                          return Column(
                              children: [
                                FutureBuilder(
                                  future: _getUserDetail(context, combinationResult.idUser),
                                  builder: (context2, snapshot2){
                                    if (snapshot2.connectionState == ConnectionState.none ||
                                        snapshot2.connectionState == ConnectionState.waiting ||
                                        snapshot2.hasData == false) {
                                      return Container(
                                        width: MediaQuery.of(context).size.width,
                                        color: Colors.amberAccent,
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Center(
                                            child: Text(
                                              'wait',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ),);}
                                    else{
                                      if (snapshot2.data == null) {
                                        return Container(
                                          child: Text('it seems nothing here'),);}
                                      else {
                                        Appuser friend = snapshot2.data;
                                        return Container(
                                          width: MediaQuery.of(context).size.width,
                                          color: Colors.amberAccent,
                                          child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Center(
                                              child: Text(
                                                friend.name,
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ),);
                                      }
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: Text(
                                    combinationResult.nameCombination,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(height: 5,),
                                (combinationResult.note.isEmpty)
                                    ? Container(
                                  height: 0,
                                )
                                    : Text(combinationResult.note),
                                SizedBox(height: 15,),
                                Center(
                                  child: FutureBuilder(
                                    future:
                                    fetchElementsByIdCombination(
                                        combinationResult
                                            .idCombination),
                                    builder: (context3, snapshot3) {
                                      if (snapshot3.connectionState ==
                                          ConnectionState.none ||
                                          snapshot3.connectionState ==
                                              ConnectionState
                                                  .waiting ||
                                          snapshot3.hasData == null) {
                                        return Center(
                                            child: Placeholder(
                                              fallbackHeight:
                                              heightMainElement * 2,
                                              fallbackWidth: 200.0,
                                            ));
                                      } else {
                                        List<MyElement>
                                        elementsInCombination =
                                            snapshot3.data;
                                        List<MyElement> accessories =
                                        elementsInCombination
                                            .where((element) =>
                                        element
                                            .idCategory ==
                                            5)
                                            .toList();

                                        //combination
                                        return Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceEvenly,
                                          children: [
                                            (elementsInCombination
                                                .firstWhere(
                                                    (element) =>
                                                element
                                                    .idCategory ==
                                                    0,
                                                orElse:
                                                    () {
                                                  return null;
                                                }) !=
                                                null)
                                                ? Container(
                                                height:
                                                heightMainElement *
                                                    2,
                                                width:
                                                widthMainElement,
                                                child: (elementsInCombination.firstWhere(
                                                        (element) =>
                                                    element.idCategory ==
                                                        0,
                                                    orElse:
                                                        () {
                                                      return null;
                                                    }) !=
                                                    null)
                                                    ? Image
                                                    .network(
                                                  elementsInCombination
                                                      .firstWhere((element) =>
                                                  element.idCategory ==
                                                      0)
                                                      .picPath,
                                                  fit: BoxFit
                                                      .contain,
                                                )
                                                    : Container())
                                                : Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .end,
                                              children: [
                                                Container(
                                                    height:
                                                    heightMainElement,
                                                    width:
                                                    widthMainElement,
                                                    child: (elementsInCombination.firstWhere((element) => element.idCategory == 2, orElse:
                                                        () {
                                                      return null;
                                                    }) !=
                                                        null)
                                                        ? Image
                                                        .network(
                                                      elementsInCombination.firstWhere((element) => element.idCategory == 2).picPath,
                                                      fit:
                                                      BoxFit.contain,
                                                    )
                                                        : Container()),
                                                Container(
                                                    height:
                                                    heightMainElement,
                                                    width:
                                                    widthMainElement,
                                                    child: (elementsInCombination.firstWhere((element) => element.idCategory == 3, orElse:
                                                        () {
                                                      return null;
                                                    }) !=
                                                        null)
                                                        ? Image
                                                        .network(
                                                      elementsInCombination.firstWhere((element) => element.idCategory == 3).picPath,
                                                      fit:
                                                      BoxFit.contain,
                                                    )
                                                        : Container()),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Row(
                                                  children: [
                                                    //a1
                                                    Container(
                                                        height:
                                                        heightSideElement,
                                                        width:
                                                        widthSideElement,
                                                        child: (accessories
                                                            .length >
                                                            0)
                                                            ? Image
                                                            .network(
                                                          accessories[0]
                                                              .picPath,
                                                          fit: BoxFit
                                                              .contain,
                                                        )
                                                            : Container()),
                                                    //a2
                                                    Container(
                                                        height:
                                                        heightSideElement,
                                                        width:
                                                        widthSideElement,
                                                        child: (accessories
                                                            .length >
                                                            1)
                                                            ? Image
                                                            .network(
                                                          accessories[1]
                                                              .picPath,
                                                          fit: BoxFit
                                                              .contain,
                                                        )
                                                            : Container()),
                                                  ],
                                                ),
                                                //coat
                                                Container(
                                                  //color: Colors.greenAccent,
                                                    height:
                                                    heightMainElement,
                                                    width:
                                                    widthMainElement,
                                                    child: (elementsInCombination.firstWhere(
                                                            (element) =>
                                                        element.idCategory ==
                                                            1,
                                                        orElse:
                                                            () {
                                                          return null;
                                                        }) !=
                                                        null)
                                                        ? Image
                                                        .network(
                                                      elementsInCombination
                                                          .firstWhere((element) =>
                                                      element.idCategory ==
                                                          1)
                                                          .picPath,
                                                      fit: BoxFit
                                                          .contain,
                                                    )
                                                        : Container()),
                                                Row(
                                                  children: [
                                                    //shoes
                                                    Container(
                                                        height:
                                                        heightSideElement,
                                                        width:
                                                        widthSideElement,
                                                        child: (elementsInCombination.firstWhere(
                                                                (element) => element.idCategory == 4,
                                                            orElse:
                                                                () {
                                                              return null;
                                                            }) !=
                                                            null)
                                                            ? Image
                                                            .network(
                                                          elementsInCombination
                                                              .firstWhere((element) => element.idCategory == 4)
                                                              .picPath,
                                                          fit: BoxFit
                                                              .contain,
                                                        )
                                                            : Container()),
                                                    //a3
                                                    Container(
                                                        height:
                                                        heightSideElement,
                                                        width:
                                                        widthSideElement,
                                                        child: (accessories
                                                            .length >
                                                            2)
                                                            ? Image
                                                            .network(
                                                          accessories[2]
                                                              .picPath,
                                                          fit: BoxFit
                                                              .contain,
                                                        )
                                                            : Container()),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                ),
                                FutureBuilder(
                                  future:
                                  GetRatingByUserAndCombination(
                                      context
                                          .read(userToken)
                                          .state,
                                      context
                                          .read(userLogged)
                                          .state
                                          .uid,
                                      combinationResult
                                          .idCombination),
                                  builder: (context4, snapshot4) {
                                    int initialRating = 4;

                                    if (snapshot4.connectionState ==
                                        ConnectionState.none ||
                                        snapshot4.connectionState ==
                                            ConnectionState.waiting ||
                                        snapshot4.hasData == false) {
                                      initialRating = 0;
                                    } else {
                                      print(snapshot4.data);
                                      initialRating = int.tryParse(
                                          snapshot4.data) ??
                                          0;
                                    }
                                    return RatingBar.builder(
                                      initialRating:
                                      initialRating.toDouble(),
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: false,
                                      itemCount: 5,
                                      itemPadding:
                                      EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      itemBuilder: (context, _) =>
                                          Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                      onRatingUpdate: (rating) async {
                                        print(rating);
                                        //create rating row
                                        var res = await createRating(
                                            context.read(userToken).state,
                                            combinationResult.idCombination,
                                            context.read(userLogged).state.uid,
                                            rating);

                                        //check result
                                        if (res == 'Updated') {
                                          print('$res');
                                        } else {
                                          print(' no updated $res');
                                        }
                                      },
                                    );
                                  },
                                ),
                              ]
                          );
                        }
                        }
                      }
                ),
                

              ],
            ),
          ),
        )
        ));
  }

}