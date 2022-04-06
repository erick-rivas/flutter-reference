class Team {

  int? id;
  DateTime? createdAt;
  String? name;
  dynamic logo;
  String? description;
  double? marketValue;
  Team? rival;

  Team({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.logo,
    required this.description,
    required this.marketValue,
    required this.rival
  });

  Team.fromJSON(dynamic json) {

    if(json == null)
      return;

    id = json["id"];
    createdAt = json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]);
    name = json["name"];
    logo = json["logo"];
    description = json["description"];
    marketValue = json["marketValue"];
    rival = Team.fromJSON(json["rival"]);

  }

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "createdAt": createdAt?.toIso8601String(),
      "name": name,
      "logo": logo,
      "description": description,
      "marketValue": marketValue,
      "rival": rival == null || rival!.id == null ? null : rival!.id
    };
  }

}