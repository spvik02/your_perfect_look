import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forypldbauth/model/combination.dart';
import 'package:forypldbauth/model/element.dart';
import 'package:forypldbauth/network/api_request.dart';
import 'package:forypldbauth/state/state_management.dart';
import 'package:forypldbauth/values/strings.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CombinationDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CombinationDetailPageState();
}

class _CombinationDetailPageState extends State<CombinationDetailPage> {

  Combination combinationCurrent;
  List<MyElement> accessories;

  Future<List<MyElement>> _getElements(
      BuildContext context, int idCombination) async {
    var result = await fetchElementsByIdCombination(idCombination);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments as Map;
    if (args != null) {
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
      body: SafeArea(
        child: Container(
          color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.amberAccent,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  icon: Icon(Icons.delete_forever),
                                  onPressed: (){
                                    Alert(
                                        context: context,
                                        type: AlertType.warning,
                                        title: 'Do you wanna delete this look?',
                                        buttons: [
                                          DialogButton(
                                            child: Text('No'),
                                            onPressed: (){
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          DialogButton(
                                            child: Text('Yes'),
                                            onPressed: ()async{
                                              print('msgl: ${combinationCurrent.idCombination}');
                                              //delete
                                              var result = await deleteCombination(context.read(userToken).state,
                                                  combinationCurrent.idCombination);

                                              //check result
                                              if (result == 'Deleted'){
                                                print('$result');
                                              }
                                              else{
                                                print(' no Deleted $result');
                                              }
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pushReplacementNamed(routeCombinationList);
                                            },
                                          )
                                        ]
                                    ).show();
                                  }),
                              SizedBox(width: 30,),
                              Expanded(
                                child: Center(
                                  child: Text(combinationCurrent.nameCombination, style: TextStyle(fontSize: 16),),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      icon: Icon(Icons.public, color: (combinationCurrent.isPosted)? Colors.redAccent :Colors.white,),
                                      onPressed: (){
                                        Alert(
                                          context: context,
                                          type: AlertType.none,
                                          title: 'Do you wanna ${combinationCurrent.isPosted ? 'un' :''}post this look?',
                                          buttons: [
                                            DialogButton(
                                              child: Text('No'),
                                              onPressed: (){
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            DialogButton(
                                              child: Text('Yes'),
                                              onPressed: ()async{
                                                print('msgl: ${!combinationCurrent.isPosted}');
                                                //put
                                                var result = await putCombinationStatus(context.read(userToken).state,
                                                    combinationCurrent.idCombination, !combinationCurrent.isPosted);

                                                //check result
                                                if (result == 'Updated'){
                                                  print('$result');
                                                }
                                                else{
                                                  print(' no updated $result');
                                                }
                                                Navigator.of(context).pop();
                                                setState(() {
                                                  print('set');
                                                  combinationCurrent.isPosted = !combinationCurrent.isPosted;
                                                });
                                              },
                                            )
                                        ]
                                        ).show();
                                      }),
                                  IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: (){
                                        print('${combinationCurrent.idCombination}, ${combinationCurrent.nameCombination}, ${combinationCurrent.note}, '
                                            '${combinationCurrent.idOccasion}, ${combinationCurrent.idUser}, ${combinationCurrent.isPosted}');
                                        combinationCurrent.elementInCombinations.forEach((element) {print('${element.nameElement}');});
                                        Navigator.of(context).pushNamed(routeCombinationEdit, arguments: {'combination':combinationCurrent});
                                      }),

                                ],
                              )

                            ],
                        ),
                        )
                    ),

                    combinationCurrent.note.isEmpty ? Container(height: 0,) : Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('${combinationCurrent.note}'),
                    ),
                    //rating

                    //SizedBox(height: 20.0,),
                  ],
                ),
              ),

              Center(
                child: FutureBuilder(
                  //initialData: null,
                    future: _getElements(context, combinationCurrent.idCombination),
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.none ||
                          snapshot.connectionState == ConnectionState.waiting ||
                          snapshot.hasData == false) {
                        //print('project snapshot data is: ${projectSnap.data}');
                        return Center(
                            child: Placeholder(
                              color: Colors.amberAccent,
                              fallbackHeight: heightMainElement *2 ,
                              fallbackWidth: 200.0,
                            ));

                      } else {
                        List<MyElement> elementsInCombination = snapshot.data;
                        combinationCurrent.elementInCombinations = elementsInCombination;
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
                                    height: heightMainElement,
                                    width: widthMainElement,
                                    child: (elementsInCombination.firstWhere((element) => element.idCategory == 3,
                                        orElse: (){return null;}) != null)
                                        ? Image.network(
                                      elementsInCombination
                                          .firstWhere((element) => element.idCategory == 3)
                                          .picPath,
                                      fit: BoxFit.contain,
                                      alignment: Alignment.topCenter,
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
                                    //a3
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
                                ),
                              ],
                            )
                          ],
                        );
                      }
                    }),
              ),

              Center(
                child: FutureBuilder(
                  future: getRatingByCombination(context.read(userToken).state,
                      combinationCurrent.idCombination),
                  builder: (context4, snapshot4){
                    int initialRating = 0;

                    if (snapshot4.connectionState == ConnectionState.none ||
                        snapshot4.connectionState == ConnectionState.waiting ||
                        snapshot4.hasData == false) {
                      initialRating = 0;
                    }
                    else {
                      print(snapshot4.data);
                      initialRating = (double.tryParse(snapshot4.data) ?? 5.0).round();
                    }
                    return RatingBar.builder(
                      ignoreGestures: true,
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
                      onRatingUpdate: (rating) async{
                        print(rating);
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 50,),

              Center(  //new screen for adding the element
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.amberAccent,
                      shadowColor: Colors.red,
                      onPrimary: Colors.white,
                      elevation: 10.0,
                  ),
                  child: Text('Send an email to your friends asking to rate'),
                  onPressed: (){
                    Navigator.of(context).pushNamed(routeSendEmail, arguments: {'combination':combinationCurrent});
                  },
                ),
              ),
            ],
          ),
        ),
      ),)
    );
  }
}