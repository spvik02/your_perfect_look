import 'dart:convert';
import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:firebase_auth_ui/providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:forypldbauth/model/appuser.dart';
import 'package:forypldbauth/network/api_request.dart';
import 'package:forypldbauth/state/state_management.dart';
import 'package:forypldbauth/state/state_management.dart';
import 'package:forypldbauth/values/app_pictures.dart';
import 'package:forypldbauth/values/strings.dart';
import 'package:forypldbauth/values/utils.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Appuser userModel;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                    future: _checkLoginState(context),
                    builder: (ctx, snapshot) {

//                      if (snapshot.connectionState == ConnectionState.none ||
//                          snapshot.connectionState == ConnectionState.waiting ||
//                          snapshot.hasData == false) {
//                        return Container(child: Center(child: Text('please wait'),),);
//                      }else{

                      var user = snapshot.data as FirebaseAuth.User;

                      if (user == null) return Column(
                        children: [
                          Container(
                            child: Image.asset(picLogin, fit: BoxFit.fitWidth,),
                            height: MediaQuery.of(context).size.height/2,
                          ),
                          SizedBox(height: 30,),
                          Padding(padding: EdgeInsets.only(left: 160),
                            child: OutlinedButton(onPressed: (){
                              setState(() {
                                userModel = null;
                                context.read(userLogged).state =
                                    FirebaseAuth.FirebaseAuth.instance.currentUser;
                              });
                              processLogin(ctx);},
                            child: Text('LOG IN', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),),
                            style: OutlinedButton.styleFrom(
                              primary: Colors.amber,
                              side: BorderSide(color: Colors.amber),
                              //elevation: 20.0,
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(30),
                            ),),),
                          SizedBox(height: 30,),
                      Padding(padding: EdgeInsets.only(right: 50), child:
                          OutlinedButton(
                            onPressed: () {
                              setState(() {
                                userModel = null;
                                context.read(userLogged).state =
                                    FirebaseAuth.FirebaseAuth.instance.currentUser;
                              });
                              processLogin(ctx);},
                            child: Text('SIGN UP', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
                            style: OutlinedButton.styleFrom(
                              primary: Colors.amber,
                              side: BorderSide(color: Colors.amber),
                              //primary: Colors.white,
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(30),
                              //elevation: 10.0,
                            ),
                          ))
                        ],
                      );

                      else
                      return Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            color: Colors.amberAccent,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Icon(
                                      user == null
                                          ? Icons.person
                                          : Icons.exit_to_app,
                                      size: 35,
                                      color: Colors.white),
                                  onPressed: () {
                                    processLogin(ctx);
                                    setState(() {});
                                  },
                                ),
                                (user == null)? Container():
                                IconButton(
                                  icon: Icon(
                                      Icons.edit,
                                      size: 35,
                                      color: Colors.white),
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(routeEditProfile, arguments: {'user':userModel});
                                  },
                                ),
                              ],
                            ),
                          ),
                          (user == null) ? Center(child: Text('Please Log in'),)
                              : (userModel == null) ? Center(child: Text('please wait') )
                              : Column(
                            children: [
                              SizedBox(height: 12,),
                              //name
                              Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                        Text(userModel.name, style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 36,
                                              )),
                                ])
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start ,
                                  children: [
                                    Container(
                                      //color: Colors.greenAccent,
                                      padding: EdgeInsets.only(left: 20, top: 40, bottom: 30, ) ,
                                      height: MediaQuery.of(context).size.height/8*3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Height'),
                                          Text('Sleeve'),
                                          Text('Сhest'),
                                          Text('Waist'),
                                          Text('Hips'),
                                          Text('Inseam'),
                                        ],
                                    ),),
                                    Container(
                                      //color: Colors.greenAccent,
                                      padding: EdgeInsets.only(left: 10, top: 40, bottom: 30, right: 10) ,
                                      height: MediaQuery.of(context).size.height/8*3,
                                      width: MediaQuery.of(context).size.width/3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('${userModel.height ?? ''}'),
                                          Text('${userModel.sleeve ?? ''}'),
                                          Text('${userModel.chest ?? ''}'),
                                          Text('${userModel.waist ?? ''}'),
                                          Text('${userModel.collar ?? ''}'),  //вообще это шея но пока бедра
                                          Text('${userModel.insideLeg ?? ''}'),
                                        ],
                                      ),),
                                    Container(
                                      child: Image.asset(picMeasurement),
                                      height: MediaQuery.of(context).size.height/2,
                                    ),
                                  ],
                                )
                              )
                            ],
                          ),
                        ],
                      );
                //    }
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<FirebaseAuth.User> _checkLoginState(BuildContext context) async {
    if (FirebaseAuth.FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.FirebaseAuth.instance.currentUser
          .getIdToken()
          .then((token) async {
        var result = await findUser( FirebaseAuth.FirebaseAuth.instance.currentUser.uid, token.toString());
        context.read(userToken).state = token;
        if (result == 'User Not found') {
          registerUser(context);
          userModel = Appuser(idUser: FirebaseAuth.FirebaseAuth.instance.currentUser.uid,
              name:FirebaseAuth.FirebaseAuth.instance.currentUser.email.substring(0, FirebaseAuth.FirebaseAuth.instance.currentUser.email.indexOf('@')),
              email: FirebaseAuth.FirebaseAuth.instance.currentUser.email
          );
        } else {
          userModel = Appuser.fromJson(json.decode(result));
          setState(() {});
        }
      });
    }
    return FirebaseAuth.FirebaseAuth.instance.currentUser;
  }

  processLogin(BuildContext context) async {
    var user = FirebaseAuth.FirebaseAuth.instance.currentUser;
    if (user == null) //login
    {
      FirebaseAuthUi.instance().launchAuth([AuthProvider.email()])
          .then((firebaseUser) {
        context.read(userLogged).state = FirebaseAuth.FirebaseAuth.instance.currentUser;
        setState(() {});                                                                                              //_checkLoginState(context);
      }).catchError((e) {
        if (e is PlatformException) {
          if (e.code == FirebaseAuthUi.kUserCancelledError) {
            showOnlySnackBar(context, 'User cancelled login');
          } else {
            showOnlySnackBar(context, '${e.message ?? 'unknow error'}');
          }
        }
      });
      setState(() {});
    } else {
      //Logout
      var result = await FirebaseAuthUi.instance().logout();
      if (result) {
        setState(() {
          userModel = null;
          context.read(userLogged).state =
              FirebaseAuth.FirebaseAuth.instance.currentUser;
        });

        showOnlySnackBar(context, 'Logout success fully');
        //refresh

        print('log out ${userModel == null ? 'yes' : 'no'}');

      } else {
        showOnlySnackBar(context, 'Logout error');
      }
      setState(() {});
      setState(() {
        userModel = null;
        context.read(userLogged).state =
            FirebaseAuth.FirebaseAuth.instance.currentUser;
      });
    }
  }

  registerUser(BuildContext context) async {
    userModel = null;
    FirebaseAuth.FirebaseAuth.instance.currentUser
        .getIdToken()
        .then((token) async {
      String email = FirebaseAuth.FirebaseAuth.instance.currentUser.email;
      var result = await createUserApi(
          token,
          FirebaseAuth.FirebaseAuth.instance.currentUser.uid,
          email.substring(0, email.indexOf('@')),
          email,
          'sorry');
      if (result == 'Created') {
        context.read(userLogged).state = FirebaseAuth.FirebaseAuth.instance.currentUser;
        Alert(
            context: context,
            type: AlertType.success,
            title: 'Register Success',
            desc: 'Thank you for register account',
            buttons: [
              DialogButton(
                child: Text('Go back'),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {});
                },
              )
            ]).show();
      }
    });
  }
}
