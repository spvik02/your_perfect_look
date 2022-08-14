class Rating {
  int idRating;
  int idCombination;
  int idUser;
  int rating1;

  Rating(
      {this.idRating,
        this.idCombination,
        this.idUser,
        this.rating1,
      });

  Rating.fromJson(Map<String, dynamic> json) {
    idRating = json['idRating'] as int;
    idCombination = json['idCombination'] as int;
    idUser = json['idUser'] as int;
    rating1 = json['rating1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idRating'] = this.idRating;
    data['idCombination'] = this.idCombination;
    data['idUser'] = this.idUser;
    data['rating1'] = this.rating1;
    return data;
  }
}