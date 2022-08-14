
class MyElement {
  int idElement;
  String nameElement;
  int idCategory;
  double price;
  String note;
  String picPath;
  String pic;
  String idUser;
  List<Null> elementInCombinations;

  MyElement(
      {this.idElement,
        this.nameElement,
        this.idCategory,
        this.price,
        this.note,
        this.picPath,
        this.pic,
        this.idUser,
        this.elementInCombinations});

  MyElement.fromAdd(this.picPath, this.nameElement, this.idCategory, this.price, this.note, this.idUser);

  MyElement.fromJson(Map<String, dynamic> json) {
    idElement = json['idElement'] as int;
    nameElement = json['nameElement'];
    idCategory = json['idCategory'] as int;
    price = json['price'] as double;
    note = json['note'];
    picPath = json['picPath'];
    pic = json['pic'];
    idUser = json['idUser'];
    //later
//    if (json['elementInCombinations'] != null) {
//      elementInCombinations = new List<Null>();
//      json['elementInCombinations'].forEach((v) {
//        elementInCombinations.add(new Null.fromJson(v));
//      });
//    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idElement'] = this.idElement;
    data['nameElement'] = this.nameElement;
    data['idCategory'] = this.idCategory;
    data['price'] = this.price;
    data['note'] = this.note;
    data['picPath'] = this.picPath;
    data['pic'] = this.pic;
    data['idUser'] = this.idUser;
    //later
//    if (this.elementInCombinations != null) {
//      data['elementInCombinations'] =
//          this.elementInCombinations.map((v) => v.toJson()).toList();
//    }
    return data;
  }
}