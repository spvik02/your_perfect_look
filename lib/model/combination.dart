

import 'package:forypldbauth/model/element.dart';

import 'rating.dart';

class Combination {
  int idCombination;
  String nameCombination;
  String note;
  int idOccasion;
  String idUser;
  bool isPosted;
  List<MyElement> elementInCombinations;
  List<Rating> ratings;

  Combination.fromNothing(){
    this.elementInCombinations = new List<MyElement>();
  }

  Combination.fromAdd(
    this.nameCombination,
    this.note,
    this.idOccasion,
    this.idUser,
    this.isPosted,
    this.elementInCombinations
  );

  Combination(
      {this.idCombination,
        this.nameCombination,
        this.note,
        this.idOccasion,
        this.idUser,
        this.isPosted,

        this.elementInCombinations,
        this.ratings});

  Combination.fromJson(Map<String, dynamic> json) {
    idCombination = json['idCombination'] as int;
    nameCombination = json['nameCombination'];
    note = json['note'];
    idOccasion = json['idOccasion'] as int;
    idUser = json['idUser'];
    isPosted = json['isPosted'] as bool;
    if (json['elementInCombinations'] != null) {
      elementInCombinations = new List<MyElement>();
      json['elementInCombinations'].forEach((v) {
        elementInCombinations.add(new MyElement.fromJson(v));
      });
    }
//    if (json['ratings'] != null) {
//      ratings = new List<Null>();
//      json['ratings'].forEach((v) {
//        ratings.add(new Null.fromJson(v));
//      });
//    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idCombination'] = this.idCombination;
    data['nameCombination'] = this.nameCombination;
    data['note'] = this.note;
    data['idOccasion'] = this.idOccasion;
    data['idUser'] = this.idUser;
    data['isPosted'] = this.isPosted;
    if (this.elementInCombinations != null) {
      data['elementInCombinations'] =
          this.elementInCombinations.map((v) => v.toJson()).toList();
    }
//    if (this.ratings != null) {
//      data['ratings'] = this.ratings.map((v) => v.toJson()).toList();
//    }
    return data;
  }
}