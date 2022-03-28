import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reference_v2/data/repository/pokemon_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/model/Pokemon.dart';

class ViewModelPokemonDetail {

  var pokemonDetailSubject = PublishSubject<Pokemon>();
  Stream<Pokemon> get pokemon => pokemonDetailSubject.stream;
  PokemonRepository pokemonRepository = PokemonRepository();

  void getPokemon() async {
    try{
      pokemonDetailSubject = PublishSubject<Pokemon>();
      pokemonDetailSubject.sink.add(await pokemonRepository.getPokemonById(1));
    } catch(e) {
      await Future.delayed(Duration(milliseconds: 500));
      pokemonDetailSubject.sink.addError(e);
      print(e);
    }
  }

  void closeStream() {
    pokemonDetailSubject.close();
  }

}

class PokemonDetail extends StatefulWidget {
  @override
  PokemonDetailState createState() => PokemonDetailState();
}

class PokemonDetailState extends State<PokemonDetail> with WidgetsBindingObserver {

  final ViewModelPokemonDetail viewModelPokemonDetail = ViewModelPokemonDetail();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Pokemon>(
      stream: viewModelPokemonDetail.pokemon,
      builder: (context, snapshot) => Scaffold(
        body: () {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return buildCircularProgressIndicatorWidget();
          }
          if (snapshot.hasError) {
            return buildListViewNoDataWidget();
          }
          if (snapshot.connectionState == ConnectionState.active) {
            var pokemon = snapshot.data;
            if (null != pokemon)
              return Scaffold(
                body: Text(pokemon.name),
              );
            else
              return buildListViewNoDataWidget();
          }
          return Container();
        } (),
      ),
    );
  }

  Widget buildListViewNoDataWidget() {
    return Expanded(
      child: Center(
        child: Text("No Data Available"),
      )
    );
  }

  Widget buildCircularProgressIndicatorWidget() {
    return Expanded(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    viewModelPokemonDetail.closeStream();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) refresh();
  }

  @override
  void initState() {
    super.initState();
    refresh();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        refresh();
      }
    });
    WidgetsBinding.instance?.addObserver(this);
  }

  void refresh() {
    viewModelPokemonDetail.getPokemon();
    setState(() {});
  }

}