class ATM {
  String Adress;
  String Adresse;
  String Agen;
  String Quoi;
  String Wat;
  String What;
  List<dynamic> Coord;

  ATM({this.Adress, this.Adresse,this.Agen,this.Coord,this.Quoi,this.Wat,this.What});

  factory ATM.fromJson(Map<String, dynamic> json) {
    return ATM(
      Adress: json['Adress'],
      Adresse: json['Adresse'],
      Agen: json['Agen'],
      Quoi: json['Quoi'],
      Wat: json['Wat'],
      What: json['What'],
      Coord: json['Coord'],
    );
  }

}