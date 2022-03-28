import 'package:flutter/cupertino.dart';
import 'package:reference_v2/data/apis/api_response.dart';
import 'package:reference_v2/data/repository/pokemon_repository.dart';

import '../data/model/Pokemon.dart';

class PokemonViewModel with ChangeNotifier {

  ApiResponse _apiResponse = ApiResponse.initial('Empty data');

  ApiResponse get response {
    return _apiResponse;
  }

  Future<void> fetchPokemon(int id) async {

    _apiResponse = ApiResponse.loading('Fetching pokemon');
    notifyListeners();

    try {

      Pokemon pokemon = await PokemonRepository().getPokemonById(id);
      _apiResponse = ApiResponse.completed(pokemon);

    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }

    notifyListeners();

  }

}