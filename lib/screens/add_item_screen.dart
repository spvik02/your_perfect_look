import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forypldbauth/model/category.dart';
import 'package:forypldbauth/model/element.dart';
import 'package:forypldbauth/network/api_request.dart';
import 'package:forypldbauth/state/state_management.dart';
import 'package:forypldbauth/values/app_icons.dart';
import 'package:forypldbauth/values/strings.dart';
import 'package:forypldbauth/values/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:rflutter_alert/rflutter_alert.dart';

class AddItemScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _AddItemScreen();
}

class _AddItemScreen extends  State<AddItemScreen>{

  String imgUrl = 'https://i.pinimg.com/originals/61/cb/3f/61cb3f8b904c44605c00a81d54cf2e33.jpg';
  File _image;


  int selectedCategory = 0;
  List<DropdownMenuItem<ElementCategory>> _dropdownMenuItems;
  ElementCategory _selectedItem;
  List<ElementCategory> _dropdownItems  = <ElementCategory>[
    ElementCategory.withIcon(0, 'Dresses', categoryIconsPaths[0]),
    ElementCategory.withIcon(1, 'Coats', categoryIconsPaths[1]),
    ElementCategory.withIcon(2, 'Tops', categoryIconsPaths[2]),
    ElementCategory.withIcon(3, 'Bottoms', categoryIconsPaths[3]),
    ElementCategory.withIcon(4, 'Shoes', categoryIconsPaths[4]),
    ElementCategory.withIcon(5, 'Accessory', categoryIconsPaths[5]),
  ];

  List<DropdownMenuItem<ElementCategory>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ElementCategory>> items = List();
    for (ElementCategory listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.nameCategory),
          value: listItem,
        ),
      );
    }
    return items;
  }

  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _selectedItem = _dropdownMenuItems[0].value;
  }

  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _noteController = TextEditingController();



  @override
  Widget build(BuildContext ctx) {

    Future getImage() async{
      final _picker = ImagePicker();
      PickedFile image;
      await Permission.photos.request();
      var permissionStatus = await Permission.photos.status;
      if (permissionStatus.isGranted){
        image = await _picker.getImage(source: ImageSource.gallery);
        _image = File(image.path);
        if(image != null){
          setState(() {
            _image = File(image.path);
            print('Image Path $_image');
          });
        }
        else{print('No path received');}
      }
      else{print('Grant Permission and Try again');}
    }

    Future uploadPic(BuildContext context) async{
      final storage = FirebaseStorage.instance;
      String filename = basename(_image.path);
      //send img to FirebaseStorage
      Reference snapshot = storage.ref()
          .child('${context.read(userLogged).state.uid}/$filename');
      UploadTask uploadTask = snapshot.putFile(_image);
      TaskSnapshot taskSnapshot = await uploadTask
          .whenComplete(() => showOnlySnackBar(context, 'uploaded'));
      var downloadUrl = await taskSnapshot.ref.getDownloadURL();
      //create result Element
      var resultElement = new MyElement.fromAdd(downloadUrl, _nameController.text,
          _selectedItem.idCategory, double.tryParse(_priceController.text), _noteController.text,
          FirebaseAuth.FirebaseAuth.instance.currentUser.uid);
      //upload to db
      var result = await createElementApi(ctx.read(userToken).state, resultElement);
      //check result
      if (result == 'Created'){
        Alert(
            context: context,
            type: AlertType.success,
            title: 'Success',
            desc: 'The element is successfully uploaded',
            buttons: [
              DialogButton(
                child: Text('Go back'),
                onPressed: (){
                  Navigator.pop(context); //close dialog
                  Navigator.pop(context);
                  //Navigator.pushNamed(context, routeHome); //routeHome may be
                  // cause now it opens screen /out bottom navigation
                },
              )
            ]
        ).show();
      } else{
        Alert(
            context: context,
            type: AlertType.error,
            title: 'Uploading failed',
            desc: result,
            buttons: [
              DialogButton(
                child: Text('ok('),
                onPressed: (){
                  Navigator.pop(context); //close dialog
                },
              )
            ]
        ).show();
      }

    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: ()=>Navigator.pop(ctx),
        ),
        title: Text('Add wardrobe element'),
        backgroundColor: Colors.amberAccent,
      ),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20.0,),
                //img
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                          width: 200,
                          height: 200,
                          child: (_image != null)
                              ? Image.file(_image, fit: BoxFit.contain,)
                              : Placeholder(fallbackHeight: 200.0, fallbackWidth: 200.0, color: Colors.amber,)
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: IconButton(
                        icon: Icon(Icons.add_photo_alternate, size: 30.0,),
                        onPressed: (){
                          getImage();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0,),

                //info
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        style: TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                            hintText: 'Name',
                            hintStyle: TextStyle(color: Colors.black87),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.amber))),
                      ),
                      SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.only(right: 10.0, left: 10.0),
                      width: MediaQuery.of(context).size.width,
                      child: DropdownButtonHideUnderline(
                      child: DropdownButton<ElementCategory>(
                          value: _selectedItem,
                          items: _dropdownMenuItems,
                          onChanged: (value) {
                            setState(() {
                              _selectedItem = value;
                            });
                          }),),
                    ),
                      SizedBox(height: 10,),
                      TextField(
                        controller: _priceController,
                        style: TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                            hintText: 'Price',
                            hintStyle: TextStyle(color: Colors.black87),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.amber))),
                      ),
                      SizedBox(height: 10,),
                      TextField(
                        controller: _noteController,
                        style: TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                            hintText: 'Note',
                            hintStyle: TextStyle(color: Colors.black87),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.amber))),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/2),

                          ),
                          RaisedButton(
                              child: Text('Save', style: TextStyle(color:Colors.amber),),
                              color: Colors.white,
                              onPressed: (){
                                uploadPic(context);
                              }
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}