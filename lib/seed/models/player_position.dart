class PlayerPosition {

  late int? id;
  late DateTime? createdAt;
  late String? name;
  late dynamic details;

  PlayerPosition({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.details
  });

  PlayerPosition.fromJSON(dynamic json) {
    id = json["id"];
    createdAt = json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]);
    name = json["name"];
    details = json["details"];
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "createdAt": createdAt?.toIso8601String(),
      "name": name,
      "details": details
    };
  }

}