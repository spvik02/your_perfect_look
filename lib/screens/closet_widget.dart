import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forypldbauth/model/element.dart';
import 'package:forypldbauth/network/api_request.dart';
import 'package:forypldbauth/state/state_management.dart';
import 'package:forypldbauth/values/app_icons.dart';
import 'package:forypldbauth/values/app_pictures.dart';
import 'package:forypldbauth/values/strings.dart';

class ClosetPage extends ConsumerWidget {

  final searchController = TextEditingController();

  //ignore: top_level_function_literal_block
  final _fetchCategories = FutureProvider((ref) async {
    var result = await fetchCategories();
    return result;
  });



  //is used for open drawer
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, watch) {

    var categoriesApiResults = watch(_fetchCategories);

    var user = context.read(userLogged).state;

    return (user == null) ?  Scaffold(
      key: _scaffoldKey,
      body: Center(child: Text('Please Log in'))
    ) :

      Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: categoriesApiResults.when(
            data: (categories) => ListView.builder(
                itemCount: categories.length,
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
                                    categoryIconsPaths[index],
                                    width: 50.0,
                                    height: 50.0,
                                  )),
                              SizedBox(
                                width: 30,
                              ),
                              categories[index].nameCategory.length <= 10
                                  ? Text(categories[index].nameCategory)
                                  : Text(
                                categories[index].nameCategory,
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                          //children: _buildList(categories[index]),
                        ),
                        onTap: (){
                          Navigator.pop(context);
                          context.read(categorySelected).state = categories[index];
                          Navigator.of(context).pushNamed(routeElementList);
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
      body:Stack(
        children: [
          Container(
            //color: Colors.greenAccent,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(picCloset),
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

          Padding(
            padding: EdgeInsets.only(top: 30, left: MediaQuery.of(context).size.width-50),
            child: IconButton(
              color: Colors.white,
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.of(context).pushNamed(routeSearchElement);
              },)
          ),

          Container(
            //color: Colors.amberAccent,
            child: Center(  //new screen for adding the element
              child: RaisedButton(
                elevation: 10,
                child: Text('Add new item', style: TextStyle(color:Colors.amber),),
                color: Colors.white,
                onPressed: (){
                  Navigator.of(context).pushNamed(routeAddItem);
                },
              ),
            ),
          )
        ],
      )
    );
  }
}
