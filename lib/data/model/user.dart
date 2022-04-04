import 'package:reference_v2/data/model/team.dart';

class User {

  late int? id;
  late DateTime? createdAt;
  late String? username;
  late String? firstName;
  late String? lastName;
  late String? email;
  late String? password;
  late bool? isActive;
  late List<Team?> teams;
  late dynamic profileImage;

  User({
    required this.id,
    required this.createdAt,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.isActive,
    required this.teams,
    required this.profileImage
  });

  User.fromJSON(dynamic json) {
    id = json["id"];
    createdAt = DateTime.parse(json["createdAt"]);
    username = json["username"];
    firstName = json["firstName"];
    lastName = json["lastName"];
    email = json["email"];
    password = json["password"];
    isActive = json["isActive"];
    teams = List<Team>.from(json["teams"].map((team) => Team.fromJSON(team)).toList());
    profileImage = json["profileImage"];
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "createdAt": createdAt,
      "username": username,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "password": password,
      "isActive": isActive,
      "teams": teams,
      "profileImage": profileImage
    };
  }

}