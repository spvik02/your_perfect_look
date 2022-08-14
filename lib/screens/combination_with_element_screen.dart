import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forypldbauth/model/combination.dart';
import 'package:forypldbauth/model/occasion.dart';
import 'package:forypldbauth/network/api_request.dart';
import 'package:forypldbauth/state/state_management.dart';
import 'package:forypldbauth/values/app_icons.dart';
import 'package:forypldbauth/values/strings.dart';
import 'package:forypldbauth/widgets/combination_card.dart';

class CombinationWithElement extends ConsumerWidget{

  //ignore: top_level_function_literal_block
  final _fetchCombinationByOccasionAndUser = FutureProvider
      .family<List<Combination>, BuildContext>
    ((ref, ctx) async {
    var result = await fetchCombinationWithElement(ctx.read(elementSelected).state.idElement);
    return result;
  });

  //is used for open drawer
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, watch) {

    var combinationsByCategoryAndUserApiResults = watch(_fetchCombinationByOccasionAndUser(
        context
    ));

    return Scaffold(
      key: _scaffoldKey,
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
                              child: Text('Combinations with selected element'),
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
                    childAspectRatio: 0.6, //46
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