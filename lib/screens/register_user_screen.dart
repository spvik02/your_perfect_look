import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:forypldbauth/network/api_request.dart';
import 'package:forypldbauth/state/state_management.dart';
import 'package:forypldbauth/values/strings.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RegisterPage extends ConsumerWidget{

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pswController = TextEditingController();

  @override
  Widget build(BuildContext context, watch) {

    _nameController.text = context.read(userLogged).state.displayName;
    _emailController.text = context.read(userLogged).state.email;

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Center(
            child: Column(
              children: [
                Center(
                  child: Text('Create an account',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),),),
                SizedBox(height: 10,),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Name'
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      hintText: 'E-mail'
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: _pswController,
                  decoration: InputDecoration(
                      hintText: 'Password'
                  ),
                ),
                SizedBox(height: 10,),
                Center(child: RaisedButton(
                  color: Colors.black,
                  onPressed: () => registerUser(context),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                    child: Text('Register', style: TextStyle(color: Colors.white),),
                  ),
                ),)
              ],
            ),
          ),
        ),
      ),
    );
  }

  registerUser(BuildContext context) async{
    FirebaseAuth.FirebaseAuth.instance.currentUser.getIdToken()
        .then((token) async{

          var result = await createUserApi(token,
              FirebaseAuth.FirebaseAuth.instance.currentUser.uid,
              _nameController.text, _emailController.text, _pswController.text);
          if (result == 'Created'){
            Alert(
              context: context,
              type: AlertType.success,
              title: 'Register Success',
              desc: 'Thank you for register account',
              buttons: [
                DialogButton(
                  child: Text('Go back'),
                  onPressed: (){
                    Navigator.pop(context); //close dialog
                    Navigator.pushNamed(context, routeProfile); //routeHome may be
                    // cause now it opens screen /out bottom navigation
                  },
                )
              ]
            ).show();
          }
          else{
            Alert(
                context: context,
                type: AlertType.error,
                title: 'Register failed',
                desc: result,
                buttons: [
                  DialogButton(
                    child: Text('OK'),
                    onPressed: (){
                      Navigator.pop(context); //close dialog
                    },
                  )
                ]
            ).show();
          }
    });
  }

}