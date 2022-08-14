import 'package:flutter/material.dart';
import 'package:forypldbauth/screens/profile_page.dart';
import 'package:forypldbauth/state/bloc.dart';
import 'package:forypldbauth/values/theme.dart';
import 'package:forypldbauth/widgets/deep_link_widget.dart';
import 'package:provider/provider.dart' as Provider;

import 'closet_widget.dart';
import 'friends_page.dart';
import 'lookbook_page.dart';
import 'profile_page.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {

  int _currentIndex = 0; //to track the index of our currently selected tab
  final List<Widget> _children = [
    ProfilePage(),
    ClosetPage(),
    LookbookPage(),
    FriendsPage(),
  ];


  @override
  Widget build(BuildContext context) {
    //deeplinks
    DeepLinkBloc _bloc = Provider.Provider.of<DeepLinkBloc>(context);

    return
      //deeplinks
      StreamBuilder<String>( //flutter_bloc
        stream: _bloc.state,
        builder: (ctx, snapshot) {
          if (!snapshot.hasData) {
            return
              Scaffold(
                body: _children[_currentIndex],
                bottomNavigationBar: BottomNavigationBar(
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  elevation: 0,
                  currentIndex: _currentIndex,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.amberAccent,
                  unselectedItemColor: Colors.white70,
                  iconSize: 30,
                  items: [
                    BottomNavigationBarItem(
                      icon: new Icon(Icons.accessibility),
                      label: 'Profile',
                    ),
                    BottomNavigationBarItem(
                      icon: new Icon(Icons.library_add),
                      label: 'Closet',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.table_chart),
                      label: 'Lookbook',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.group),
                      label: 'Friends',
                      backgroundColor: Colors.purpleAccent,
                    )
                  ],
                  selectedItemColor: appTheme.accentColor,
                ),
              );
          } else {
            return DeepLinkWidget(val: snapshot.data);
          }
        },
      );
  }
}
