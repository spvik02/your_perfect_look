import 'dart:convert';
import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:firebase_auth_ui/providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:forypldbauth/model/element.dart';
import 'package:forypldbauth/network/api_request.dart';
import 'package:forypldbauth/state/state_management.dart';

class ElementEditScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ElementEditScreenState();
}

class _ElementEditScreenState extends State<ElementEditScreen> {

  MyElement elementModel;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _noteController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments as Map;
    if (args != null) {
      elementModel = args['element'];
    }

    _nameController.text = elementModel.nameElement;
    _nameController.selection = TextSelection.fromPosition(TextPosition(offset: _nameController.text.length));
    _priceController.text = (elementModel.price == null) ? '' :elementModel.price.toString();
    _priceController.selection = TextSelection.fromPosition(TextPosition(offset: _priceController.text.length));
    _noteController.text = (elementModel.note == null) ? '' :elementModel.note;
    _noteController.selection = TextSelection.fromPosition(TextPosition(offset: _noteController.text.length));


    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      padding: EdgeInsets.all(0),
                      height: MediaQuery.of(context).size.height/2,
                      //color: Colors.redAccent,
                      child: (elementModel.picPath != null)
                          ? Image.network(
                        elementModel.picPath,
                        fit: BoxFit.contain,
                      )
                          : Placeholder(
                        color: Colors.amberAccent,
                        fallbackHeight: 200.0,
                        fallbackWidth: 200.0,
                      ),
                    ),
                    //name
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: TextField(
                        controller: this._nameController,
                        style: TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.amber))),
                        onSubmitted: (val) {
                          elementModel.nameElement = val;
                        },
                        onChanged: (String val) {
                          debugPrint('string - $val, string.length - ${val.length}');
                          elementModel.nameElement = val;
                        },
                      ),
                    ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                     child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _priceController,
                        style: TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.amber))),
                        onSubmitted: (val) {
                          elementModel.price = double.tryParse(val);
                        },),
                  ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: TextField(
                        controller: this._noteController,
                        style: TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.amber))),
                        onSubmitted: (val) {
                          elementModel.note = val;
                        },
                        onChanged: (String val) {
                          debugPrint('string - $val, string.length - ${val.length}');
                          elementModel.note = val;
                        },
                      ),
                    ),




                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(padding: EdgeInsets.only(right: 40, top: 10),
                          child: ElevatedButton(
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.amberAccent)),
                            child: Text('Save'),
                            onPressed: ()async{

                              print('msgl ${elementModel.idElement}, ${elementModel.nameElement}, ${elementModel.price}, ${elementModel.idCategory}, '
                                  '${elementModel.idUser}, ${elementModel.note}, ${elementModel.picPath}');

                              //put
                              var result = await putElementInfo(context.read(userToken).state,
                                  elementModel);

                              //check result
                              if (result == 'Updated'){
                                print('$result');
                              }
                              else{
                                print(' no updated $result');
                              }
                              Navigator.of(context).pop();
                            },),)
                      ],
                    )

                  ],
                ),
              ],
            )),
      ),
    );
  }
}
