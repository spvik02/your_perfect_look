import 'element.dart';
import 'rating.dart';

import 'combination.dart';

class Appuser {
  String idUser;
  String name;
  String email;
  String login;
  String psw;
  bool isAdmin;
  List<Combination> combinations;
  List<MyElement> elements;
  List<Rating> ratings;
  double height;
  double collar;
  double chest;
  double sleeve;
  double waist;
  double insideLeg;

  Appuser(
      {this.idUser,
        this.name,
        this.email,
        this.login,
        this.psw,
        this.isAdmin,
        this.height,
        this.collar,
        this.chest,
        this.sleeve,
        this.waist,
        this.insideLeg,
        this.combinations,
        this.elements,
        this.ratings});

  Appuser.fromId(this.idUser);

  Appuser.fromJson(Map<String, dynamic> json) {
    idUser = json['idUser'];
    name = json['name'];
    email = json['email'];
    login = json['login'];
    psw = json['psw'];
    isAdmin = json['isAdmin'];
    height = json['height']as double;
    collar = json['collar']as double;
    chest = json['chest']as double;
    sleeve = json['sleeve']as double;
    waist = json['waist']as double;
    insideLeg = json['insideLeg']as double;
    if (json['combinations'] != null) {
      combinations = new List<Combination>();
      json['combinations'].forEach((v) {
        combinations.add(new Combination.fromJson(v));
      });
    }
    if (json['elements'] != null) {
      elements = new List<MyElement>();
      json['elements'].forEach((v) {
        elements.add(new MyElement.fromJson(v));
      });
    }
    if (json['ratings'] != null) {
      ratings = new List<Rating>();
      json['ratings'].forEach((v) {
        ratings.add(new Rating.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idUser'] = this.idUser;
    data['name'] = this.name;
    data['email'] = this.email;
    data['login'] = this.login;
    data['psw'] = this.psw;
    data['isAdmin'] = this.isAdmin;
    data['height'] = this.height;
    data['collar'] = this.collar;
    data['chest'] = this.chest;
    data['sleeve'] = this.sleeve;
    data['waist'] = this.waist;
    data['insideLeg'] = this.insideLeg;
    if (this.combinations != null) {
      data['combinations'] = this.combinations.map((v) => v.toJson()).toList();
    }
    if (this.elements != null) {
      data['elements'] = this.elements.map((v) => v.toJson()).toList();
    }
    if (this.ratings != null) {
      data['ratings'] = this.ratings.map((v) => v.toJson()).toList();
    }
    return data;
  }
}