import 'player.dart';

class Score {

  late int? id;
  late DateTime? createdAt;
  late int? min;
  late Player? player;
  late String? match;

  Score({
    required this.id,
    required this.createdAt,
    required this.min,
    required this.player,
    required this.match,
  });

  Score.fromJSON(dynamic json) {
    id = json["id"];
    createdAt = json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]);
    min = json["min"];
    player = Player.fromJSON(json["player"]);
    match = json["match"];
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "createdAt": createdAt?.toIso8601String(),
      "min": min,
      "player": player?.toJSON(),
      "match": match
    };
  }

}