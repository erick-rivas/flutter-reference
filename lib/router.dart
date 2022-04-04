import 'package:reference_v2/ui/auth/login.dart';
import 'package:reference_v2/ui/team/form.dart';
import 'package:reference_v2/ui/team/list.dart';
import 'package:reference_v2/ui/user/list.dart';

var router = {
  '/examples/login': (context) => const Login(),
  '/examples/users': (context) => const ListUser(),
  '/examples/teams': (context) => const ListTeams(),
  '/examples/teams/create': (context) => const FormTeams(),
};