import '../apis/http_handler.dart';
import '../model/Pokemon.dart';

class PokemonRepository {

  String URL = "https://pokeapi.co/api/v2/";
  HttpHandler httpHandler = HttpHandler();

  Future<dynamic> getPokemonById(int id) async {
    final response = await httpHandler.GET("${URL}pokemon/$id");
    if(response != null) return Pokemon.fromJSON(response);
    return null;
  }

}