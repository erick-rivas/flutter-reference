import 'package:reference_v2/data/model/team.dart';

class Player {

  late int id;
  late DateTime createdAt;
  late String name;
  late int photo;
  late bool isActive;
  late Team team;
  late int position;

  Player({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.photo,
    required this.isActive,
    required this.team,
    required this.position
  });

  Player.fromJSON(dynamic json) {
    id = json["id"];
    createdAt = json["created_at"].toDate();
    name = json["name"];
    photo = json["photo"];
    isActive = json["is_Active"];
    team = json["team"];
    position = json["position"];
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "created_at": createdAt,
      "name": name,
      "photo": photo,
      "is_Active": isActive,
      "team": team,
      "position": position
    };
  }

}