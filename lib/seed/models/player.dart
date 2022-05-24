import 'team.dart';

class Player {

  late int? id;
  late DateTime? createdAt;
  late String? name;
  late int? photo;
  late bool? isActive;
  late Team? team;
  late int? position;

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
    createdAt = json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]);
    name = json["name"];
    photo = json["photo"];
    isActive = json["isActive"];
    team = Team.fromJSON(json["team"]);
    position = json["position"];
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "createdAt": createdAt?.toIso8601String(),
      "name": name,
      "photo": photo,
      "isActive": isActive,
      "team": team?.toJSON(),
      "position": position
    };
  }

}