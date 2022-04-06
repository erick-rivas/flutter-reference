import 'package:reference_v2/ui/auth/login.dart';
import 'package:reference_v2/ui/team/detail.dart';
import 'package:reference_v2/ui/team/form.dart';
import 'package:reference_v2/ui/team/list.dart';

var router = {
  '/examples/login': (context) => const Login(),
  '/examples/teams': (context) => const ListTeams(),
  '/examples/teams/detail': (context) => const DetailTeam(),
  '/examples/teams/form': (context) => const FormTeams(),
};