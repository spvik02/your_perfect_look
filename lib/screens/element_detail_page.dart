import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forypldbauth/model/element.dart';
import 'package:forypldbauth/network/api_request.dart';
import 'package:forypldbauth/state/state_management.dart';
import 'package:forypldbauth/values/app_icons.dart';
import 'package:forypldbauth/values/strings.dart';
import 'package:forypldbauth/values/theme.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ElementDetailPage extends ConsumerWidget {
  //ignore: top_level_function_literal_block
  final _fetchElementById =
      FutureProvider.family<MyElement, int>((ref, id) async {
    var result = await fetchElementsDetail(id);
    return result;
  });

  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, watch) {
    var elementsApiResults =
        watch(_fetchElementById(context.read(elementSelected).state.idElement));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: elementsApiResults.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text('$error'),
                ),
                data:
                (element) => SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.amberAccent,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 30,),
                                Expanded(
                                  child: Center(
                                    child: Text(element.nameElement, style: TextStyle(fontSize: 16),),
                                  ),
                                ),
                                IconButton(
                                    icon: Icon(Icons.delete_forever),
                                    onPressed: (){
                                      Alert(
                                          context: context,
                                          type: AlertType.warning,
                                          title: 'Do you wanna delete this element?',
                                          desc: 'Element will be deleted from all combinations',
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
                                                print('msgl: ${element.idElement}');
                                                //delete
                                                var result = await deleteElement(context.read(userToken).state,
                                                    element.idElement);

                                                //check result
                                                if (result == 'Deleted'){
                                                  print('$result');
                                                }
                                                else{
                                                  print(' no Deleted $result');
                                                }
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pushReplacementNamed(routeElementList);
                                              },
                                            )
                                          ]
                                      ).show();
                                    }),
                              ],
                            ),
                          )
                      ),

                      SizedBox(
                        height: 12,
                      ),
                      //img
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(0),
                            height: MediaQuery.of(context).size.height/2,
                            //color: Colors.redAccent,
                            child: (element.picPath != null)
                                ? Image.network(
                              element.picPath,
                              fit: BoxFit.contain,
                            )
                                : Placeholder(
                              fallbackHeight: 200.0,
                              fallbackWidth: 200.0,
                            ),
                          ),
//                          CarouselSlider(
//                              items: element.elementInCombinations.map((e)=> Builder(
//                                builder: (context){
//                                  return Container(
//                                    child: Image(
//                                      image: NetworkImage(e.imgUrl),
//                                      fit: BoxFit.fill,
//                                    ),
//                                  );
//                                },
//                              )).toList(),
//                              options: CarouselOptions(
//                                height: MediaQuery.of(context).size.height/3*2.5,
//                                autoPlay: true,
//                                viewportFraction: 1,
//                                initialPage: 0
//                              ))
                        ],
                      ),

                      //note
                      element.note == null ? Container() : Text('${element.note}', style: TextStyle(fontSize: 16),),
                      SizedBox(height: 6.0,), //4
                      //price
                      element.price == null ? Container() :
                      Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text('price: ${element.price}')
                      ),

                      //buttons
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 8, right: 8, top: 20),
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: RaisedButton(
                                  color: Colors.amberAccent,
                                  child: Text('Edit', style: TextStyle(color: Colors.black87,  fontWeight: FontWeight.normal)),
                                  onPressed: (){
                                    Navigator.of(context).pushNamed(routeElementEdit, arguments: {'element':element});
                                  },
                                ),),
                                SizedBox (width: 20,),
                                Expanded(child: RaisedButton(
                                  color: Colors.amberAccent,
                                  onPressed: (){
                                    context.read(elementSelected).state = element;
                                    Navigator.of(context).pushNamed(routeCombinationWithElement, arguments: {'element':element});
                                  },
                                  child: Text('Show looks', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.normal)),
                                ),)
                              ],
                            )
                          )
                        ],
                      ),

                    ],
                  ),
                )
                //),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
