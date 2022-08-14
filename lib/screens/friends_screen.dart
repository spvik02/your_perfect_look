

import 'package:flutter/material.dart';
import 'package:forypldbauth/model/appuser.dart';
import 'package:forypldbauth/network/api_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forypldbauth/state/state_management.dart';
import 'package:forypldbauth/values/strings.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class FriendsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen>{


  Future<List<Appuser>> _getFriendRequests(String idUser) async {
    var result = await fetchFriendsRequest(idUser);
    return result;
  }
  Future<List<Appuser>> _getFriendAcceptedRequests(String idUser) async {
    var result = await fetchFriendsAcceptedRequest(idUser);
    return result;
  }




  Widget _friendRequestsWidget(contextSc, idUser){
    return FutureBuilder(
        future: _getFriendRequests(idUser),
        builder: (ctx, snapshot){
          if (snapshot.connectionState == ConnectionState.none ||
              snapshot.connectionState == ConnectionState.waiting ||
              snapshot.hasData == null) {
            return Container(child: Center(child: Text('searching for friend requests'),),);
          }else{
            List<Appuser> list = snapshot.data;
            if (snapshot.data == null ||list.length == 0) {return Center(child: Text('no friend requests'),);}
            else{
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {

                  Appuser elementResult = snapshot.data[index];
                  return GestureDetector(
                    child: new Card(
                        child: Padding(
                          padding: new EdgeInsets.all(20.0),
                          child: Text('${elementResult.name}', style: TextStyle(color: Colors.indigo, fontSize: 16),),
                        )
                    ),
                    onTap: (){
                      Alert(
                          context: contextSc,
                          type: AlertType.warning,
                          title: 'Do you wanna become friends?',
                          buttons: [
                            DialogButton(
                              child: Text('No'),
                              onPressed: ()async{
                                print('userId: ${context.read(userLogged).state.uid}, friendId: ${elementResult.idUser}');

                                //put
                                var result = await putFriendStatus(context.read(userToken).state,
                                  context.read(userLogged).state.uid, elementResult.idUser, false);

                                //check result
                                if (result == 'Updated'){
                                  print('$result');
                                }
                                else{
                                  print(' no updated $result');
                                }
                                Navigator.of(contextSc).pop();
                                setState(() {
                                  print('set');
                                });
                              },
                            ),
                            DialogButton(
                              child: Text('Yes'),
                              onPressed: ()async{

                                //put
                                var result = await putFriendStatus(context.read(userToken).state,
                                    context.read(userLogged).state.uid, elementResult.idUser, true);

                                //check result
                                if (result == 'Updated'){
                                  print('$result');
                                }
                                else{
                                  print(' no updated $result');
                                }
                                Navigator.of(contextSc).pop();
                                setState(() {
                                  print('set');
                                });
                              },
                            )
                          ]
                      ).show();
                    },
                  );
                },
              );
            }
          }
        }
    );
  }

  Widget _friendAcceptedRequestsWidget(contextSc, idUser){
    return FutureBuilder(
        future: _getFriendAcceptedRequests(idUser),
        builder: (ctx, snapshot){
          if (snapshot.connectionState == ConnectionState.none ||
              snapshot.connectionState == ConnectionState.waiting ||
              snapshot.hasData == null) {
            return Container(child: Center(child: Text('searching for accepted requests'),),);
          }else{
            List<Appuser> list = snapshot.data;
            if (snapshot.data == null ||list.length == 0) {return Center(child: Text('no accepted requests'),);}
            else{
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {

                  Appuser elementResult = snapshot.data[index];
                  return GestureDetector(
                    child: new Card(
                        child: Padding(
                          padding: new EdgeInsets.all(20.0),
                          child: Text('${elementResult.name}', style: TextStyle(color: Colors.indigo, fontSize: 16),),
                        )
                    ),
                    onTap: (){
                      Alert(
                          context: contextSc,
                          type: AlertType.warning,
                          title: 'Do you wanna reject friend request?',
                          buttons: [
                            DialogButton(
                              child: Text('No'),
                              onPressed: ()async{
                                Navigator.of(contextSc).pop();
                              },
                            ),
                            DialogButton(
                              child: Text('Yes'),
                              onPressed: ()async{
                                print('userId: ${context.read(userLogged).state.uid}, friendId: ${elementResult.idUser}');

                                //put
                                var result = await putFriendStatus(context.read(userToken).state,
                                    context.read(userLogged).state.uid, elementResult.idUser, null);

                                //check result
                                if (result == 'Updated'){
                                  print('$result');
                                }
                                else{
                                  print(' no updated $result');
                                }
                                Navigator.of(contextSc).pop();
                                setState(() {
                                  print('set');
                                });
                              },
                            ),
                          ]
                      ).show();
                    },
                  );
                },
              );
            }
          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {

    Widget _friendsWidget(){
      return FutureBuilder(
        future: fetchUserFriends(context.read(userLogged).state.uid),
        builder: (context1, snapshot1){
          if (snapshot1.connectionState == ConnectionState.none ||
              snapshot1.connectionState == ConnectionState.waiting ||
              snapshot1.hasData == null) {
            return Container(width: 0.0, height: 0.0);
          }
          else{
            if (snapshot1.data == null) {return Container(width: 0.0, height: 0.0);}
            else{
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot1.data.length,
                itemBuilder: (context2, index2) {
                  Appuser elementResult = snapshot1.data[index2];
                  return GestureDetector(
                    child: new Card(
                        child: Padding(
                          padding: new EdgeInsets.all(20.0),
                          child: Text('${elementResult.name}', style: TextStyle(color: Colors.indigo, fontSize: 16),),
                        )
                    ),
                    onTap: (){
                      //print('${elementResult.idUser}');
                      Navigator.pushNamed(context, routeFriendProfile, arguments: {'Friend': elementResult});
                    },
                  );
                },
              );
            }
          }
        }
      );
    }


    return MaterialApp(
      home: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.amberAccent,
            flexibleSpace:Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TabBar(
                  indicatorColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.tab ,
                  indicatorWeight: 5,
                  tabs: [
                    Tab(child: Text('Friends', style: TextStyle(color: Colors.white, fontSize: 18),),),
                    Tab(child: Text('Requests', style: TextStyle(color: Colors.white, fontSize: 18),),),
                    Tab(child: Text('Accepted', style: TextStyle(color: Colors.white, fontSize: 18),),),
                  ],
                ),
              ],
            )

            ),
            body: TabBarView(
              children: [
                _friendsWidget(),
                _friendRequestsWidget(context, context.read(userLogged).state.uid),
                _friendAcceptedRequestsWidget(context, context.read(userLogged).state.uid),
              ],
            ),
          )
    ));
  }

}


