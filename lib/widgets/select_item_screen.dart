import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forypldbauth/model/element.dart';
import 'package:forypldbauth/network/api_request.dart';
import 'package:forypldbauth/state/state_management.dart';

import 'select_item_card.dart';


class SelectElementListPage extends ConsumerWidget{

  final _fetchElementByCategoryAndUser = FutureProvider
      .family<List<MyElement>, BuildContext>
    ((ref, ctx) async {
    print('mslg: category ${ctx.read(categorySelected).state.idCategory}, user: ${ctx.read(userLogged).state.uid}');
    var result = await fetchElementsByCategoryAndUserId(
        ctx.read(categorySelected).state.idCategory, ctx.read(userLogged).state.uid);
    return result;
  });

  @override
  Widget build(BuildContext context, watch) {

    var elementsByCategoryAndUserApiResults = watch(_fetchElementByCategoryAndUser(
        context
    ));


    return Scaffold( body: SafeArea(
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
                  children: elements.map((e)=> SelectElementCard(element:e)).toList(),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text('$error'),
                )
            ),
          ),
        ],
      ),
    ));
  }

}