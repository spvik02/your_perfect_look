import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forypldbauth/model/combination.dart';
import 'package:forypldbauth/network/api_request.dart';
import 'package:forypldbauth/state/state_management.dart';
import 'package:forypldbauth/values/strings.dart';
import 'package:forypldbauth/widgets/combination_card.dart';
import 'package:forypldbauth/widgets/friend_combination_card.dart';

class FriendsPage extends ConsumerWidget {

  //ignore: top_level_function_literal_block
  final _fetchCombinationByOccasionAndUser = FutureProvider
      .family<List<Combination>, BuildContext>
    ((ref, ctx) async {
    var result = await fetchCombinationOfFriendsByUserId(ctx.read(userLogged).state.uid);
    return result;
  });

  @override
  Widget build(BuildContext context, watch) {

    var combinationsByCategoryAndUserApiResults = watch(_fetchCombinationByOccasionAndUser(
        context
    ));
    var user = context.read(userLogged).state;

    return (user == null) ?  Scaffold(
    body: Center(child: Text('Please Log in'))
    ) : Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            color: Colors.white,
              child: Column(
                children: [
                  Container(
                    color: Colors.amberAccent,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
                              child: IconButton(
                                icon: Icon(
                                    Icons.person_add,
                                    size: 35,
                                    color: Colors.white70),
                                onPressed: () {
                                  Navigator.of(context).pushNamed(routeAddFriends);
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                              child: IconButton(
                                icon: Icon(
                                    Icons.nature_people,
                                    size: 35,
                                    color: Colors.white70),
                                onPressed: () {
                                  Navigator.of(context).pushNamed(routeFriendsScreen);
                                },
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),

                  Expanded(
                          child: combinationsByCategoryAndUserApiResults.when(
                              data: (combinations)=> GridView.count(
                                padding: EdgeInsets.only(bottom: 15.0),
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                childAspectRatio: 0.6, //46
                                children: combinations.map((e)=> FriendCombinationCard(combination:e)).toList(),
                              ),
                              loading: () => const Center(child: CircularProgressIndicator()),
                              error: (error, stack) => Center(
                                child: Text('$error', style: TextStyle(color: Colors.indigo),),
                              )
                          ),
                        ),
                ],
              ),
            )
          )


    //)
    );
  }
}
