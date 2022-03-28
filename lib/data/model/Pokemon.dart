class Pokemon {

  late int id;
  late String name;
  late String imageURL;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageURL
  });

  Pokemon.fromJSON(dynamic json) {
    id = json["id"];
    name = json["name"];
    imageURL = json["sprites"]["front_default"];
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "name": name,
      "image_url": imageURL
    };
  }

}