import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forypldbauth/model/appuser.dart';
import 'package:forypldbauth/network/api_request.dart';
import 'package:forypldbauth/values/strings.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class AddFriendsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddFriendsPage();
}

class _AddFriendsPage extends State<AddFriendsPage> {
  String _name;
  final searchController = TextEditingController();

  Future<List<Appuser>> _getFriendByName(
      BuildContext context, String name) async {
    var result = await fetchFriendsByName(name);
    return result;
  }

  @override
  initState(){
    super.initState();
    _name='';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.amberAccent,
            leading: IconButton(
              icon: Icon(Icons.keyboard_arrow_left),
              onPressed: () => Navigator.pop(context),
            ),
            title: Padding(
              padding: EdgeInsets.only(top: 10),
              child: TextField(
                controller: searchController,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: " Search...",
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState((){
                        _name = searchController.text;
                      });
                    },
                  ),
                ),
              ),
            )
            ),
        body: SafeArea(
        child: SingleChildScrollView(
        child: FutureBuilder(

            future: _getFriendByName(context, _name),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.none ||
                  snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.hasData == null) {
                return Container(width: 0.0, height: 0.0);
              }
              else{
                if (snapshot.data == null) {return Container(width: 0.0, height: 0.0);}
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
                          Navigator.pushNamed(context, routeFriendProfile, arguments: {'Friend': elementResult}); //routeHome may be
                        },
                      );
                    },
                  );
                }
              }
            }),
    ),
    ),
        );
  }
}
