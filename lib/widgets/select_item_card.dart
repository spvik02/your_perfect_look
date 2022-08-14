import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:forypldbauth/model/element.dart';

class SelectElementCard extends StatelessWidget {
  final MyElement element;

  SelectElementCard({Key key, this.element}) : super(key: key);

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
                  //SizedBox(height: 4.0,)
                ],
              ),
            )
          ],
        ),
      ),

      onTap: () {
        //return value
        Navigator.of(context).pop({'selection':element});
      },
    );
  }
}
