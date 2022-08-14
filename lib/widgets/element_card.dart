import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:forypldbauth/model/element.dart';
import 'package:forypldbauth/state/state_management.dart';
import 'package:forypldbauth/values/strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; //for context.read

class ElementCard extends StatelessWidget {
  final MyElement element;

  ElementCard({Key key, this.element}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        elevation: 6, //6
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  padding: EdgeInsets.all(0),
                  width: 200,
                  height: 200,
                  child: (element.picPath != null)
                      ? Image.network(
                    element.picPath,
                    fit: BoxFit.contain,
                  )
                      : Placeholder(
                    fallbackHeight: 200.0,
                    fallbackWidth: 200.0,
                  ),
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                    '${element.nameElement}',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 4.0,
                  ), //4
                  element.note == null ? Container() : Text('${element.note}'),
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () {
        context.read(elementSelected).state = element;
        Navigator.of(context).pushNamed(routeElementDetail);
      },
    );
  }
}
