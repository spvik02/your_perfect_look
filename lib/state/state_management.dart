import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:forypldbauth/model/appuser.dart';
import 'package:forypldbauth/model/category.dart';
import 'package:forypldbauth/model/combination.dart';
import 'package:forypldbauth/model/element.dart';
import 'package:forypldbauth/model/occasion.dart';

final categorySelected = StateProvider((ref) => ElementCategory());
final occasionSelected = StateProvider((ref) => Occasion());
final elementSelected = StateProvider((ref) => MyElement());
final combinationSelected = StateProvider((ref) => Combination());
final friendSelected = StateProvider((ref) => Appuser());
final userLogged = StateProvider((ref) => FirebaseAuth.FirebaseAuth.instance.currentUser);
final userToken = StateProvider((ref)=>'none');