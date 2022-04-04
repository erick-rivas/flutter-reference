import 'package:reference_v2/data/model/player.dart';

class Score {

  late int id;
  late DateTime createdAt;
  late int min;
  late Player player;
  late String match;

  Score({
    required this.id,
    required this.createdAt,
    required this.min,
    required this.player,
    required this.match,
  });

  Score.fromJSON(dynamic json) {
    id = json["id"];
    createdAt = json["created_at"].toDate();
    min = json["min"];
    player = json["player"];
    match = json["match"];
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "created_at": createdAt,
      "min": min,
      "player": player,
      "match": match
    };
  }

}