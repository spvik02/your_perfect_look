import 'package:flutter/material.dart';
import 'package:forypldbauth/model/combination.dart';
import 'package:forypldbauth/model/element.dart';
import 'package:forypldbauth/state/state_management.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forypldbauth/values/strings.dart';
import 'package:forypldbauth/values/utils.dart';
import 'package:forypldbauth/widgets/select_item_screen.dart';

import 'element_list_screen.dart';

class AddCombinationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddCombinationScreen();
}

class _AddCombinationScreen extends State<AddCombinationScreen> {
  MyElement _selectionTop,
      _selectionBottom,
      _selectionDress,
      _selectionCoat,
      _selectionShoes,
      _selectionAccessory1,
      _selectionAccessory2,
      _selectionAccessory3;

  bool _isDressMode;

  Widget _elementChild(MyElement selection, index) {
    return (selection != null)
        ? Image.network(
            selection.picPath,
            fit: BoxFit.contain,
      alignment: index == 3 ? Alignment.topCenter : Alignment.center,
          )
        : ColorFiltered(
            colorFilter: ColorFilter.matrix(<double>[
              0.2126,0.7152,0.0722,0,0,
              0.2126,0.7152,0.0722,0,0,
              0.2126,0.7152,0.0722,0,0,
              0,0,0,1,0,
            ]),
            child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  categoriesAll[index].iconPath,
                )),
          );
  }

  @override
  void initState() {
    super.initState();
    _isDressMode = false;
  }

  @override
  Widget build(BuildContext context) {
    print('msgl: add_combination_screen build()');
    var heightMainElement = MediaQuery.of(context).size.height / 3;
    var heightSideElement = MediaQuery.of(context).size.height / 6;
    var widthMainElement = MediaQuery.of(context).size.width / 2;
    var widthSideElement = MediaQuery.of(context).size.width / 4;

//    Future<MyElement> _getSelection(MyElement selection, index) async {
//      context.read(categorySelected).state = categoriesAll[index];
//      var results =
//          await Navigator.of(context).push(new MaterialPageRoute<dynamic>(
//        builder: (BuildContext context) {
//          return new SelectElementListPage();
//        },
//      ));
//      if (results != null && results.containsKey('selection')) {
//        selection = results['selection'];
//        print('msgl: gs ${selection.nameElement}');
//        return results['selection'];
////        setState(() {
////          selection = results['selection'];
////        });
//      }
//      return null;
//    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Add combination'),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
        children: [
          Row(
            children: [
              (_isDressMode)
                  ? GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        //color: Colors.green,
                        height: heightMainElement*2,
                        width: widthMainElement,
                        child: _elementChild(_selectionDress, 0),
                      ),
                      onTap: () async {
                        context.read(categorySelected).state = categoriesAll[0];

                        var results = await Navigator.of(context)
                            .push(new MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) {
                            return new SelectElementListPage();
                          },
                        ));
                        if (results != null && results.containsKey('selection')) {
                          setState(() {
                            _selectionDress = results['selection'];
                          });
                        }
                      },
                    )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //top
                        GestureDetector(
                          child: Container(
                            //color: Colors.red,
                            height: heightMainElement,
                            width: widthMainElement,
                            child: _elementChild(_selectionTop, 2),
                          ),
                          onTap:
//                              ()async{
//
//                            _selectionTop = await _getSelection(_selectionTop, 2);
//                            print('msgl: build ${_selectionTop.nameElement}');
//                            setState(() {
//
//                            });
//                         },
                          // => _getSelection(_selectionTop, 2),
                        () async {
                      context.read(categorySelected).state = categoriesAll[2];

                      var results = await Navigator.of(context)
                          .push(new MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) {
                          return new SelectElementListPage();
                        },
                      ));
                      if (results != null && results.containsKey('selection')) {
                        _selectionTop = results['selection'];
                        setState(() {
                          _selectionTop = results['selection'];
                          print('msgl: setState ${_selectionTop != null?_selectionTop.nameElement : 'no'}');
                        });
                        print('msgl: after setState ${_selectionTop != null?_selectionTop.nameElement : 'no'}');
                      }
                    },
                        ),

                        //bot
                        GestureDetector(
                          child: Container(
                            //color: Colors.lightBlueAccent,
                            height: heightMainElement,
                            width: widthMainElement,
                            child: _elementChild(_selectionBottom, 3),
                          ),
                          onTap: () async {
                            context.read(categorySelected).state = categoriesAll[3];
                            var results = await Navigator.of(context)
                                .push(new MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) {
                                return new SelectElementListPage();
                              },
                            ));
                            if (results != null && results.containsKey('selection')) {
                              setState(() {
                                _selectionBottom = results['selection'];
                              });
                            }
                          },
                        ),
                      ],
                    ),
              Column(
                children: [
                  Row(children: [
                    //accs1
                    GestureDetector(
                      child: Container(
                        //color: Colors.orangeAccent,
                        height: heightSideElement,
                        width: widthSideElement,
                        child: _elementChild(_selectionAccessory1, 5),
                      ),
                      onTap: () async {
                        context.read(categorySelected).state = categoriesAll[5];

                        var results = await Navigator.of(context)
                            .push(new MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) {
                            return new SelectElementListPage();
                          },
                        ));
                        if (results != null && results.containsKey('selection')) {
                          setState(() {
                            _selectionAccessory1 = results['selection'];
                          });
                        }
                      },
                    ),
                    //accs
                    GestureDetector(
                      child: Container(
                        //color: Colors.yellow,
                        height: heightSideElement,
                        width: widthSideElement,
                        child: _elementChild(_selectionAccessory2, 5),
                      ),
                      onTap: () async {
                        context.read(categorySelected).state = categoriesAll[5];

                        var results = await Navigator.of(context)
                            .push(new MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) {
                            return new SelectElementListPage();
                          },
                        ));
                        if (results != null && results.containsKey('selection')) {
                          setState(() {
                            _selectionAccessory2 = results['selection'];
                          });
                        }
                      },
                    ),
                  ]),
                  //coat
                  GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      //color: Colors.green,
                      height: heightMainElement,
                      width: widthMainElement,
                      child: _elementChild(_selectionCoat, 1),
                    ),
                    onTap: () async {
                      context.read(categorySelected).state = categoriesAll[1];

                      var results = await Navigator.of(context)
                          .push(new MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) {
                          return new SelectElementListPage();
                        },
                      ));
                      if (results != null && results.containsKey('selection')) {
                        setState(() {
                          _selectionCoat = results['selection'];
                        });
                      }
                    },
                  ),
                  Row(children: [
                    //shoes
                    GestureDetector(
                      child: Container(
                        //color: Colors.indigo,
                        height: heightSideElement,
                        width: widthSideElement,
                        child: _elementChild(_selectionShoes, 4),
                      ),
                      onTap: () async {
                        context.read(categorySelected).state = categoriesAll[4];

                        var results = await Navigator.of(context)
                            .push(new MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) {
                            return new SelectElementListPage();
                          },
                        ));
                        if (results != null && results.containsKey('selection')) {
                          setState(() {
                            _selectionShoes = results['selection'];
                          });
                        }
                      },
                    ),
                    //accs
                    GestureDetector(
                      child: Container(
                        //color: Colors.deepPurple,
                        height: heightSideElement,
                        width: widthSideElement,
                        child: _elementChild(_selectionAccessory3, 5),
                      ),
                      onTap: () async {
                        context.read(categorySelected).state = categoriesAll[5];

                        var results = await Navigator.of(context)
                            .push(new MaterialPageRoute<dynamic> (builder: (BuildContext context) {
                            return new SelectElementListPage();
                          },
                        ));
                        if (results != null && results.containsKey('selection')) {
                          setState(() {
                            _selectionAccessory3 = results['selection'];
                          });
                        }
                      },
                    ),
                  ]),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  //new screen for adding the element
                  child: RaisedButton(
                    child: Text( (_isDressMode)
                        ? 'Top/Bottom style'
                        : 'Dress style',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.amberAccent,
                    onPressed: () {
                      print('msgl: is Dress style? $_isDressMode');
                      if (_isDressMode) {
                        _selectionTop = null;
                        _selectionBottom = null;
                        setState(() {
                          _isDressMode = false;
                        });
                      } else {
                        _selectionDress = null;
                        setState(() {
                          _isDressMode = true;
                        });
                      }
                    },
                  ),
                ),
                Center(
                  //new screen for adding the element
                  child: RaisedButton(
                    child: Text(
                      'Continue',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.amberAccent,
                    onPressed: () {
                      //print('msgl: add ${_selectionTop != null?_selectionTop.nameElement : 'no'}');
                      Combination combination = new Combination.fromNothing();
                      if(_selectionDress != null) combination.elementInCombinations.add(_selectionDress);
                      if(_selectionCoat != null) combination.elementInCombinations.add(_selectionCoat);
                      if(_selectionTop != null) combination.elementInCombinations.add(_selectionTop);
                      if(_selectionBottom != null) combination.elementInCombinations.add(_selectionBottom);
                      if(_selectionShoes != null) combination.elementInCombinations.add(_selectionShoes);
                      if(_selectionAccessory1 != null) combination.elementInCombinations.add(_selectionAccessory1);
                      if(_selectionAccessory2 != null) combination.elementInCombinations.add(_selectionAccessory2);
                      if(_selectionAccessory3 != null) combination.elementInCombinations.add(_selectionAccessory3);


//                      combination.elementInCombinations.forEach((element) {
//                        print('msgl: add ${element.nameElement}');
//                      });

                      //Navigator.of(context).pop({'selection':element});
                      Navigator.of(context).pushNamed(routeAddCombinationInfo, arguments: {'combination':combination});
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      )),)
    );
  }
}
