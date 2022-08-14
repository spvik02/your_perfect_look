import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forypldbauth/model/appuser.dart';
import 'package:forypldbauth/network/api_request.dart';
import 'package:forypldbauth/state/state_management.dart';
import 'package:forypldbauth/values/app_pictures.dart';

class ProfileEditScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  Appuser userModel;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _sleeveController = TextEditingController();
  TextEditingController _chestController = TextEditingController();
  TextEditingController _waistController = TextEditingController();
  TextEditingController _hipsController = TextEditingController();
  TextEditingController _inseamController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments as Map;
    if (args != null) {
      userModel = args['user'];
    }

    _nameController.text = userModel.name;
    _nameController.selection = TextSelection.fromPosition(TextPosition(offset: _nameController.text.length));
    _heightController.text = (userModel.height == null) ? '' :userModel.height.toString();
    _heightController.selection = TextSelection.fromPosition(TextPosition(offset: _heightController.text.length));
    _sleeveController.text = (userModel.sleeve == null) ? '' :userModel.sleeve.toString();
    _sleeveController.selection = TextSelection.fromPosition(TextPosition(offset: _sleeveController.text.length));
    _chestController.text = (userModel.chest == null) ? '' :userModel.chest.toString();
    _chestController.selection = TextSelection.fromPosition(TextPosition(offset: _chestController.text.length));
    _waistController.text = (userModel.waist == null) ? '' :userModel.waist.toString();
    _waistController.selection = TextSelection.fromPosition(TextPosition(offset: _waistController.text.length));
    _hipsController.text = (userModel.collar == null) ? '' :userModel.collar.toString();
    _hipsController.selection = TextSelection.fromPosition(TextPosition(offset: _hipsController.text.length));
    _inseamController.text = (userModel.insideLeg == null) ? '' :userModel.insideLeg.toString();
    _inseamController.selection = TextSelection.fromPosition(TextPosition(offset: _inseamController.text.length));

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              color: Colors.amberAccent,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      userModel == null ? '' : userModel.name,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 12,
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
                      userModel.name = val;
                    },
                    onChanged: (String val) {
                      debugPrint('string - $val, string.length - ${val.length}');
                      userModel.name = val;
                    },
                  ),
                ),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: 10),
                          height: MediaQuery.of(context).size.height / 2 - 40,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('Height'),
                              Text('Sleeve'),
                              Text('Сhest'),
                              Text('Waist'),
                              Text('Hips'),
                              Text('Inseam'),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          child: Expanded(
                              child: Column(
                                children: [
                                  TextField(
                                    keyboardType: TextInputType.number,
                                    controller: _heightController,
                                    style: TextStyle(color: Colors.black87),
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.amber))),
                                    onSubmitted: (val) {
                                      userModel.height = double.tryParse(val);
                                    },
                                  ),
                                  TextField(
                                    keyboardType: TextInputType.number,
                                    controller: _sleeveController,
                                    style: TextStyle(color: Colors.black87),
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderSide:
                                            BorderSide(color: Colors.amber))),
                                    onSubmitted: (val) {
                                      userModel.sleeve = double.tryParse(val);
                                    },
                                  ),
                                  TextField(
                                    keyboardType: TextInputType.number,
                                    controller: _chestController,
                                    style: TextStyle(color: Colors.black87),
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderSide:
                                            BorderSide(color: Colors.amber))),
                                    onSubmitted: (val) {
                                      userModel.chest = double.tryParse(val);
                                    },
                                  ),
                                  TextField(
                                    keyboardType: TextInputType.number,
                                    controller: _waistController,
                                    style: TextStyle(color: Colors.black87),
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderSide:
                                            BorderSide(color: Colors.amber))),
                                    onSubmitted: (val) {
                                      userModel.waist = double.tryParse(val);
                                    },
                                  ),
                                  TextField(
                                    keyboardType: TextInputType.number,
                                    controller: _hipsController,
                                    style: TextStyle(color: Colors.black87),
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderSide:
                                            BorderSide(color: Colors.amber))),
                                    onSubmitted: (val) {
                                      userModel.collar = double.tryParse(val);
                                    },
                                  ),
                                  TextField(
                                    keyboardType: TextInputType.number,
                                    controller: _inseamController,
                                    style: TextStyle(color: Colors.black87),
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderSide:
                                            BorderSide(color: Colors.amber))),
                                    onSubmitted: (val) {
                                      userModel.insideLeg = double.tryParse(val);
                                    },
                                  ),
                                ],
                              )),
                        ),
                        Container(
                          child: Image.asset(picMeasurement),
                          height: MediaQuery.of(context).size.height/2,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(padding: EdgeInsets.only(right: 40, top: 40),
                      child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.amberAccent)),
                        child: Text('Save'),
                        onPressed: ()async{

                          print('msgl ${userModel.idUser}, ${userModel.name}, ${userModel.height}, ${userModel.sleeve}, '
                              '${userModel.chest}, ${userModel.collar}, ${userModel.insideLeg}, ${userModel.email}');

                          //put
                          var result = await putAppuserInfo(context.read(userToken).state,
                              userModel);

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
