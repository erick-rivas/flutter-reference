import 'package:reference_v2/data/model/team.dart';

class Match {

  late int id;
  late DateTime createdAt;
  late DateTime date;
  late MatchType type;
  late int local;
  late int visitor;

  Match({
    required this.id,
    required this.createdAt,
    required this.date,
    required this.type,
    required this.local,
    required this.visitor,
  });

  Match.fromJSON(dynamic json) {
    id = json["id"];
    createdAt = json["created_at"].toDate();
    date = json["date"];
    type = json["type"];
    local = json["local"];
    visitor = json["visitor"];
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "created_at": createdAt,
      "date": date,
      "type": type,
      "local": local,
      "visitor": visitor
    };
  }

}

enum MatchType { FRIENDSHIP, LEAGUE, CUP}