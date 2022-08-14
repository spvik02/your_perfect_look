import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forypldbauth/model/category.dart';
import 'package:forypldbauth/model/occasion.dart';

import 'app_icons.dart';

void showOnlySnackBar(BuildContext context, String s){
  Scaffold.of(context).showSnackBar(SnackBar(content: Text('$s'),
  ));
}

final List<ElementCategory> categoriesAll  = <ElementCategory>[
  ElementCategory.withIcon(0, 'Dresses', categoryIconsPaths[0]),
  ElementCategory.withIcon(1, 'Coats', categoryIconsPaths[1]),
  ElementCategory.withIcon(2, 'Tops', categoryIconsPaths[2]),
  ElementCategory.withIcon(3, 'Bottoms', categoryIconsPaths[3]),
  ElementCategory.withIcon(4, 'Shoes', categoryIconsPaths[4]),
  ElementCategory.withIcon(5, 'Accessory', categoryIconsPaths[5]),
];

final List<Occasion> occasionsAll  = <Occasion>[
  Occasion.withIcon(0, 'Work', categoryIconsPaths[5]),
  Occasion.withIcon(1, 'Casual', categoryIconsPaths[5]),
  Occasion.withIcon(2, 'Party', categoryIconsPaths[5]),
  Occasion.withIcon(3, 'Formal', categoryIconsPaths[5]),
  Occasion.withIcon(4, 'Vacation', categoryIconsPaths[5]),
  Occasion.withIcon(5, 'Sport', categoryIconsPaths[5]),
  Occasion.withIcon(6, 'Home', categoryIconsPaths[5]),
];

