import 'package:flutter/foundation.dart';

class Match {

  late int? id;
  late DateTime? createdAt;
  late DateTime? date;
  late MatchType? type;
  late int? local;
  late int? visitor;

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
    createdAt = json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]);
    date = json["date"];
    local = json["local"];
    visitor = json["visitor"];
    type = MatchType.values.firstWhere(
      (element) => describeEnum(element) == json["type"],
      orElse: () => MatchType.NONE
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "createdAt": createdAt?.toIso8601String(),
      "date": date,
      "type": describeEnum(type!),
      "local": local,
      "visitor": visitor
    };
  }

}

enum MatchType { FRIENDSHIP, LEAGUE, CUP, NONE}