import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forypldbauth/network/api_request.dart';
import 'package:forypldbauth/state/state_management.dart';
import 'package:forypldbauth/values/app_icons.dart';
import 'package:forypldbauth/values/app_pictures.dart';
import 'package:forypldbauth/values/strings.dart';

class LookbookPage extends ConsumerWidget {

  //ignore: top_level_function_literal_block
  final _fetchOccasions = FutureProvider((ref) async {
    var result = await fetchOccasions();
    return result;
  });

  //is used for open drawer
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, watch) {
    var occasionsApiResults = watch(_fetchOccasions);
    var user = context.read(userLogged).state;

    return (user == null) ?  Scaffold(
        key: _scaffoldKey,
        body: Center(child: Text('Please Log in'))
    ) : Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: occasionsApiResults.when(
              data: (occasions) => ListView.builder(
                  itemCount: occasions.length,
                  itemBuilder: (context, index) {
                    if (index == null) index = 0;
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        //child: ExpansionTile(
                        child: GestureDetector(
                          child: ListTile(
                            title: Row(
                              children: [
                                Container(
                                    child: Image.asset(
                                      occasionIconsPaths[index],
                                      width: 50.0,
                                      height: 50.0,
                                    )),
                                SizedBox(
                                  width: 30,
                                ),
                                occasions[index].nameOccasion.length <= 10
                                    ? Text(occasions[index].nameOccasion)
                                    : Text(
                                  occasions[index].nameOccasion,
                                  style: TextStyle(fontSize: 12),
                                )
                              ],
                            ),
                            //children: _buildList(categories[index]),
                          ),
                          onTap: (){
                            Navigator.pop(context);
                            context.read(occasionSelected).state = occasions[index];
                            Navigator.of(context).pushNamed(routeCombinationList);
                          },
                        ),
                      ),
                    );
                  }),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('$error'),
              )),
        ),
        body: Stack(
          children: [
            Container(
              //color: Colors.greenAccent,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(picLookbook),
                    colorFilter:
                    ColorFilter.mode(Colors.grey[300], BlendMode.modulate),
                    fit: BoxFit.cover),
                color: Colors.amber[200],
              ),
              //child: Image.asset(picLookbook, fit: BoxFit.cover,),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.white.withOpacity(0),
                  ),
                ),
              ),
            ),
            Container(
              //color: Colors.amberAccent,
              child: Center(  //new screen for adding the element
                child: RaisedButton(
                  child: Text('Add new look', style: TextStyle(color:Colors.amber),),
                  elevation: 10,

                  color: Colors.white,
                  onPressed: (){
                    Navigator.of(context).pushNamed(routeAddCombination);
                  },
                ),
              ),
            )
          ],
        )
    );
  }
}
