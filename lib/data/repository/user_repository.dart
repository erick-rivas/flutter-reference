import 'dart:convert';

import 'package:reference_v2/data/apis/graphql.dart';

import '../../settings.dart';
import '../model/user.dart';

class UserRepository {

  GraphQL graphQL = GraphQL(GRAPH_URL);

  Future<dynamic> listUser() async {

    String listGQL = """{
      userPagination {
        totalPages
        users {
          username
          firstName
          lastName
          email
          isActive
          createdAt
          teams { }
          profileImage { }
        }
      }
    }""";

    var res = await graphQL.pagination(listGQL, 1, 15);

    if (res.data != null)
      return List<User>.from(res.data["userPagination"]["users"].map((user) => User.fromJSON(user)).toList());

    return [];

  }

}