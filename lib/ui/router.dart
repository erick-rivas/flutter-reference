import 'package:reference/ui/auth/login.dart';
import 'package:reference/ui/team/detail.dart';
import 'package:reference/ui/team/form.dart';
import 'package:reference/ui/team/list.dart';

var router = {
  '/examples/login': (context) => const Login(),
  '/examples/teams': (context) => const ListTeams(),
  '/examples/teams/detail': (context) => const DetailTeam(),
  '/examples/teams/form': (context) => const FormTeams(),
};