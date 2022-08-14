import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forypldbauth/model/element.dart';
import 'package:forypldbauth/network/api_request.dart';
import 'package:forypldbauth/state/state_management.dart';
import 'package:forypldbauth/values/app_icons.dart';
import 'package:forypldbauth/values/strings.dart';
import 'package:forypldbauth/widgets/element_card.dart';
//import 'package:forypldbauth/widgets/element_card.dart';

class ElementListPage extends ConsumerWidget{

  //ignore: top_level_function_literal_block
  final _fetchCategories = FutureProvider((ref) async {
    var result = await fetchCategories();
    return result;
  });

  //ignore: top_level_function_literal_block
  final _fetchElementByCategoryAndUser = FutureProvider
      .family<List<MyElement>, BuildContext>
    ((ref, ctx) async {
      //print('mslg: category ${ctx.read(categorySelected).state.idCategory}, user: ${ctx.read(userLogged).state.uid}');
    var result = await fetchElementsByCategoryAndUserId(
        ctx.read(categorySelected).state.idCategory, ctx.read(userLogged).state.uid);
    return result;
  });

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, watch) {

    var categoriesApiResults = watch(_fetchCategories);
    var elementsByCategoryAndUserApiResults = watch(_fetchElementByCategoryAndUser(
        context
    ));

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: categoriesApiResults.when(
            data: (categories) => ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
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
                          context.read(categorySelected).state = categories[index];
                          Navigator.of(context).pushReplacementNamed(routeElementList);
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
      body: SafeArea(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //category name
                Row(
                  children: [
                    Column(children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.amberAccent,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Center(
                              child: Text('${context.read(categorySelected).state.nameCategory}'),
                            ),
                          )
                      )
                    ],)
                  ],
                )
              ],
            ),

            Expanded(
              child: elementsByCategoryAndUserApiResults.when(
                  data: (elements)=> GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    childAspectRatio: 0.6, //46
                    children: elements.map((e)=> ElementCard(element:e)).toList() ,
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Text('$error'),
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }

}