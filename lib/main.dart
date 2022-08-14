import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:firebase_auth_ui/providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:forypldbauth/screens/profile_page.dart';
import 'package:page_transition/page_transition.dart';
import 'screens/add_combination_info_screen.dart';
import 'screens/add_combination_screen.dart';
import 'screens/add_friends.dart';
import 'screens/add_item_screen.dart';
import 'screens/closet_widget.dart';
import 'screens/combination_detail_page.dart';
import 'screens/combination_edit_screen.dart';
import 'screens/combination_with_element_screen.dart';
import 'screens/element_detail_page.dart';
import 'screens/element_edit_screen.dart';
import 'screens/element_list_screen.dart';
import 'screens/element_search.dart';
import 'screens/friend_profile_screen.dart';
import 'screens/friends_screen.dart';
import 'screens/home_widget.dart';
import 'screens/lookbook_page.dart';
import 'screens/looks_list_screen.dart';
import 'screens/profile_edit_screen.dart';
import 'screens/register_user_screen.dart';
import 'screens/send_email_screen.dart';
import 'state/bloc.dart';
import 'state/state_management.dart';
import 'values/strings.dart';
import 'values/theme.dart';
import 'values/utils.dart';
import 'package:provider/provider.dart' as Provider;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child:MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    DeepLinkBloc _bloc = DeepLinkBloc(); //deeplinks

    return MaterialApp(
      title: 'ypl 3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: appTheme.primaryColor,
      ),
      onGenerateRoute: (settings){
        switch (settings.name){

        //profile
          case routeRegisterUser:
            return PageTransition(
              type: PageTransitionType.fade,
              child: RegisterPage(),
              settings: settings,
            );
            break;
          case routeProfile:
            return PageTransition(
              type: PageTransitionType.fade,
              child: ProfilePage(),
              settings: settings,
            );
            break;
          case routeEditProfile:
            return PageTransition(
              type: PageTransitionType.fade,
              child: ProfileEditScreen(),
              settings: settings,
            );
            break;


          //closet
          case routeCloset:
            return PageTransition(
              type: PageTransitionType.fade,
              child: ClosetPage(),
              settings: settings,
            );
            break;
          case routeElementList:
            return PageTransition(
              type: PageTransitionType.fade,
              child: ElementListPage(),
              settings: settings,
            );
            break;
          case routeElementDetail:
            return PageTransition(
              type: PageTransitionType.fade,
              child: ElementDetailPage(),
              settings: settings,
            );
            break;
          case routeAddItem:
            return PageTransition(
              type: PageTransitionType.fade,
              child: AddItemScreen(),
              settings: settings,
            );
            break;
          case routeElementEdit:
            return PageTransition(
              type: PageTransitionType.fade,
              child: ElementEditScreen(),
              settings: settings,
            );
            break;
          case routeCombinationWithElement:
            return PageTransition(
              type: PageTransitionType.fade,
              child: CombinationWithElement(),
              settings: settings,
            );
            break;
          case routeSearchElement:
            return PageTransition(
              type: PageTransitionType.fade,
              child: SearchElement(),
              settings: settings,
            );
            break;


          //lookbook
          case routeLookbook:
            return PageTransition(
              type: PageTransitionType.fade,
              child: LookbookPage(),
              settings: settings,
            );
            break;
          case routeCombinationList:
            return PageTransition(
              type: PageTransitionType.fade,
              child: CombinationListPage(),
              settings: settings,
            );
            break;
          case routeAddCombination:
            return PageTransition(
              type: PageTransitionType.fade,
              child: AddCombinationScreen(),
              settings: settings,
            );
            break;
          case routeAddCombinationInfo:
            return PageTransition(
              type: PageTransitionType.fade,
              child: AddCombinationInfo(),
              settings: settings,
            );
            break;
          case routeCombinationDetail:
            return PageTransition(
              type: PageTransitionType.fade,
              child: CombinationDetailPage(),
              settings: settings,
            );
            break;
          case routeCombinationEdit:
            return PageTransition(
              type: PageTransitionType.fade,
              child: CombinationEditScreen(),
              settings: settings,
            );
            break;

            //firends
          case routeAddFriends:
            return PageTransition(
              type: PageTransitionType.rightToLeftWithFade,
              child: AddFriendsPage(),
              settings: settings,
            );
            break;
          case routeFriendProfile:
            return PageTransition(
              type: PageTransitionType.rightToLeftWithFade,
              child: FriendProfileScreen(),
              settings: settings,
            );
            break;
          case routeFriendsScreen:
            return PageTransition(
              type: PageTransitionType.rightToLeftWithFade,
              child: FriendsScreen(),
              settings: settings,
            );
            break;

          case routeSendEmail:
            return PageTransition(
              type: PageTransitionType.rightToLeftWithFade,
              child: SendEmailScreen(),
              settings: settings,
            );
            break;

          default: return null;
        }
      },

      home:
      //deeplinks
      Scaffold(
          body: Provider.Provider<DeepLinkBloc>(
              create: (context) => _bloc,
              dispose: (context, bloc) => bloc.dispose(),
              child: Home()))
    );
  }
}

