import 'package:flutter/material.dart';
import 'package:pokedex_app/bloc/pokemon_bloc.dart';

class Provider extends InheritedWidget {
  Provider({Key key, Widget child}) : super(key: key, child: child);

  final pokemonBloc = PokemonsBloc();
  // final themeBloc = ThemeBloc();

  static PokemonsBloc pokemonsBlocOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().pokemonBloc;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
