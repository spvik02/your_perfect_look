import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forypldbauth/model/appuser.dart';
import 'package:forypldbauth/model/combination.dart';
import 'package:forypldbauth/model/element.dart';
import 'package:forypldbauth/network/api_request.dart';
import 'package:forypldbauth/state/state_management.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class FriendProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FriendProfileScreenState();
}

class _FriendProfileScreenState extends State<FriendProfileScreen> {
  Appuser friend;

  @override
  Widget build(BuildContext context) {
    //get args
    final Map args = ModalRoute.of(context).settings.arguments as Map;
    if (args != null) {
      friend = args['Friend'];
    }

    var heightMainElement = MediaQuery.of(context).size.height / 3 - 8;
    var heightSideElement = MediaQuery.of(context).size.height / 6;
    var widthMainElement = MediaQuery.of(context).size.width / 2 - 4;
    var widthSideElement = MediaQuery.of(context).size.width / 4 - 2;

    return Scaffold(
        body: SafeArea(
      child: Container(
          //color: Colors.amber[50],
          child: FutureBuilder(
        future: getFriendshipState(
            context.read(userLogged).state.uid, friend.idUser),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.none ||
              snapshot.connectionState == ConnectionState.waiting ||
              snapshot.hasData == false) {
            return Center(
                child: Text('Wait we are checking your friendship state'));
          } else {
            String friendshipState = snapshot.data;
            if (friendshipState == 'NotFound') {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                    child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                    ),
                    Center(
                      child: Text('you are not friends yet, wanna become?'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('No')),
                        ElevatedButton(
                            onPressed: () async {
                              //make friend request
                              var res = await createFriendApi(
                                  context.read(userToken).state,
                                  context.read(userLogged).state.uid,
                                  friend.idUser);
                              print('msgl: $res');
                              if (res == 'Created') {
                                Alert(
                                    context: context,
                                    type: AlertType.success,
                                    title: 'Friend request Success',
                                    desc:
                                        'Request is sent, wait for user response',
                                    buttons: [
                                      DialogButton(
                                        child: Text('Go back'),
                                        onPressed: () {
                                          Navigator.pop(context); //close dialog
                                          setState(() {});
                                        },
                                      )
                                    ]).show();
                              } else {
                                Alert(
                                    context: context,
                                    type: AlertType.error,
                                    title: 'Friendship request failed',
                                    desc: res.toString(),
                                    buttons: [
                                      DialogButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.pop(context); //close dialog
                                          setState(() {});
                                        },
                                      )
                                    ]).show();
                              }
                            },
                            child: Text('Yes')),
                      ],
                    )
                  ],
                )),
              );
            }
            else if (friendshipState == 'NoAction') {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                    child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                    ),
                    Center(
                      child: Text('Request is sent, wait for user response'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Back')),
                      ],
                    )
                  ],
                )),
              );
            }
            else if (friendshipState == 'Accepted') {
              //profile posted combination
              return //Expanded(child:
                  SingleChildScrollView(
                      child: Column(
                children: [
                  //friend name
                  Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.amberAccent,
//                      child: Padding(
//                          padding: const EdgeInsets.all(20),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Center(
                              child: Text(
                                friend.name,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 10,
                            top: 5,
                            child: IconButton(
                                icon: Icon(Icons.delete_forever),
                                onPressed: () {
                                  Alert(
                                      context: context,
                                      type: AlertType.warning,
                                      title: 'Do you wanna unfriend this user?',
                                      buttons: [
                                        DialogButton(
                                          child: Text('No'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        DialogButton(
                                          child: Text('Yes'),
                                          onPressed: () async {
                                            print('userId: ${context.read(userLogged).state.uid}, friendId: ${friend.idUser}');

                                            //put
                                            var result = await putFriendStatus(
                                                context.read(userToken).state,
                                                friend.idUser,
                                                context
                                                    .read(userLogged)
                                                    .state
                                                    .uid,
                                                null);

                                            //check result
                                            if (result == 'Updated') {
                                              print('$result');
                                            } else {
                                              print(' no updated $result');
                                            }
                                            Navigator.of(context).pop();
                                            setState(() {
                                              print('set');
                                            });
                                          },
                                        ),
                                      ]).show();
                                }),
                          )
                        ],
                      )),
                  SizedBox(
                    height: 20,
                  ),

                  FutureBuilder(
                      future: getFriendPostedCombinations(friend.idUser),
                      builder: (context1, snapshot1) {
                        if (snapshot1.connectionState == ConnectionState.none ||
                            snapshot1.connectionState ==
                                ConnectionState.waiting ||
                            snapshot1.hasData == false) {
                          return Container(
                            child: Text('wait'),
                          );
                        } else {
                          if (snapshot1.data == null) {
                            return Container(
                              child: Text('it seems nothing here'),
                            );
                          } else {
                            return Column(
                              children: [
                                ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot1.data.length,
                                    itemBuilder: (context2, index2) {
                                      Combination combinationResult =
                                          snapshot1.data[index2];
                                      //combi post
                                      return Card(
                                          child: Column(
                                        children: [
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
                                          (combinationResult.note.isEmpty)
                                              ? Container(
                                                  height: 0,
                                                )
                                              : Text(combinationResult.note),
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
                                                                    //color: Colors.greenAccent,
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
                                            future: GetRatingByUserAndCombination(
                                                    context.read(userToken).state,
                                                    context.read(userLogged).state.uid,
                                                    combinationResult.idCombination),
                                            builder: (context4, snapshot4) {
                                              int initialRating = 4;
                                              if (snapshot4.connectionState == ConnectionState.none ||
                                                  snapshot4.connectionState == ConnectionState.waiting ||
                                                  snapshot4.hasData == false) {
                                                initialRating = 3;
                                              } else {
                                                print(snapshot4.data);
                                                initialRating = int.tryParse(snapshot4.data) ?? 3;
                                              }
                                              return RatingBar.builder(
                                                initialRating: initialRating.toDouble(),
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: false,
                                                itemCount: 5,
                                                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                itemBuilder: (context, _) => Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                onRatingUpdate: (rating) async {
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
                                          //rating

                                          SizedBox(
                                            height: 20,
                                          )
                                        ],
                                      ));
                                    })
                              ],
                            );
                          }
                        }
                      }),
                ],
              ));
            } else if (friendshipState == 'Denied') {
              return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 2,
                        ),
                        Text(
                            'Sorry, ${friend.name} does not want to be friends with you'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Back')),
                          ],
                        )
                      ],
                    ),
                  ));
            } else
              return Center(child: Text('$friendshipState'));
          }
        },
      )),
    ));
  }
}
