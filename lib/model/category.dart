import 'element.dart';

class ElementCategory {
  int idCategory;
  String nameCategory;
  String iconPath;
  List<MyElement> elements;

  ElementCategory({this.idCategory, this.nameCategory, this.elements});
  ElementCategory.withIcon(this.idCategory, this.nameCategory, this.iconPath);

  ElementCategory.fromJson(Map<String, dynamic> json) {
    idCategory = json['idCategory'];
    nameCategory = json['nameCategory'];
    if (json['elements'] != null) {
      elements =  List<MyElement>();
      json['elements'].forEach((v) {
        elements.add(new MyElement.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idCategory'] = this.idCategory;
    data['nameCategory'] = this.nameCategory;
    if (this.elements != null) {
      data['elements'] = this.elements.map((v) => v.toJson()).toList();
    }
    return data;
  }
}