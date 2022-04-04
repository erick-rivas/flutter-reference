class PlayerPosition {

  late int id;
  late DateTime createdAt;
  late String name;
  late dynamic details;

  PlayerPosition({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.details
  });

  PlayerPosition.fromJSON(dynamic json) {
    id = json["id"];
    createdAt = json["created_at"].toDate();
    name = json["name"];
    details = json["details"];
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "created_at": createdAt,
      "name": name,
      "details": details
    };
  }

}