import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forypldbauth/model/combination.dart';
import 'package:forypldbauth/model/occasion.dart';
import 'package:forypldbauth/network/api_request.dart';
import 'package:forypldbauth/state/state_management.dart';
import 'package:forypldbauth/values/app_icons.dart';
import 'package:forypldbauth/values/strings.dart';
import 'package:forypldbauth/widgets/combination_card.dart';

class CombinationListPage extends ConsumerWidget{

  //ignore: top_level_function_literal_block
  final _fetchOccasions = FutureProvider((ref) async {
    var result = await fetchOccasions();
    return result;
  });

  //ignore: top_level_function_literal_block
  final _fetchCombinationByOccasionAndUser = FutureProvider
      .family<List<Combination>, BuildContext>
    ((ref, ctx) async {
    var result = await fetchCombinationByOccasionAndUserId(
        ctx.read(occasionSelected).state.idOccasion, ctx.read(userLogged).state.uid);
    return result;
  });

  //is used for open drawer
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, watch) {

    var occasionsApiResults = watch(_fetchOccasions);
    var combinationsByCategoryAndUserApiResults = watch(_fetchCombinationByOccasionAndUser(
        context
    ));

    return Scaffold(
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
                        ),
                        onTap: (){
                          context.read(occasionSelected).state = occasions[index];
                          Navigator.of(context).pushReplacementNamed(routeCombinationList);
                        },
                      ),
                    ),
                  );
                }),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text('$error', style: TextStyle(color: Colors.pink),),
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
                              child: Text('${context.read(occasionSelected).state.nameOccasion}'),
                            ),
                          )
                      )
                    ],)
                  ],
                )
              ],
            ),

            Expanded(
              child: combinationsByCategoryAndUserApiResults.when(
                  data: (combinations)=> GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    childAspectRatio: 0.6,
                    children: combinations.map((e)=> CombinationCard(combination:e)).toList(),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Text('$error', style: TextStyle(color: Colors.indigo),),
                  )
              ),
            ),
          ],
        ),
      ) ,
    );
  }
}