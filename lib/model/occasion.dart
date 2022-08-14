import 'combination.dart';

class Occasion {
  int idOccasion;
  String nameOccasion;
  String iconPath;
  List<Combination> combinations;

  Occasion({this.idOccasion, this.nameOccasion, this.combinations});
  Occasion.withIcon(this.idOccasion, this.nameOccasion, this.iconPath);

  Occasion.fromJson(Map<String, dynamic> json) {
    idOccasion = json['idOccasion'];
    nameOccasion = json['nameOccasion'];
    if (json['combinations'] != null) {
      combinations = new List<Combination>();
      json['combinations'].forEach((v) {
        combinations.add(new Combination.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idOccasion'] = this.idOccasion;
    data['nameOccasion'] = this.nameOccasion;
    if (this.combinations != null) {
      data['combinations'] = this.combinations.map((v) => v.toJson()).toList();
    }
    return data;
  }
}