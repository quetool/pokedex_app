import 'package:flutter/material.dart';
import 'package:pokedex_app/bloc/pokemon_bloc.dart';
import 'package:pokedex_app/bloc/provider.dart';
import 'package:pokedex_app/components/pokemons_list.dart';
import 'package:pokedex_app/helpers/helpers.dart';
import 'package:pokedex_app/models/pokemon.dart';
import 'package:pokedex_app/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var scrollController = ScrollController();
  PokemonBase currentPokemon;
  PokemonState pokemonState = PokemonState();
  PokemonsBloc pokemonBloc;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (!mounted) return;
      setState(() {});
      var currentIndex = _currentIndex();
      if (currentIndex == pokemonState.pokemons.length - 1 &&
          !pokemonState.loading) {
        pokemonBloc.getMorePokemons();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    pokemonBloc = Provider.pokemonsBlocOf(context)..getPokemons();
    pokemonBloc.streamPokemonsSate.listen((PokemonState data) {
      if (!mounted) return;
      setState(() {
        pokemonState = data;
      });
    });
    pokemonBloc.streamCurrentPokemon.listen((PokemonBase data) {
      currentPokemon = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 62, 50, 1.0),
        title: Text((currentPokemon != null)
            ? Helpers().capitalize(currentPokemon.name)
            : ''),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
            ),
            onPressed: () {
              SharedPreferences.getInstance().then((prefs) {
                var userId = prefs.getString('user_id');
                Helpers().logOut(userId, (success, error) {
                  if (success) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<LoginScreen>(
                        fullscreenDialog: true,
                        builder: (BuildContext context) {
                          return LoginScreen();
                        },
                      ),
                    );
                  }
                });
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    PokemonsList(
                      scrollController: scrollController,
                    ),
                  ],
                ),
              ),
              (pokemonState.pokemons.isNotEmpty)
                  ? Row(
                      children: <Widget>[
                        Expanded(
                          child: IconButton(
                            iconSize: 30.0,
                            icon: const Icon(Icons.arrow_back),
                            onPressed:
                                (_currentIndex() == 0) ? null : _previousBall,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: (pokemonState.loading &&
                                    pokemonState.currentPage > 0)
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 30.0,
                                        height: 30.0,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 4.0,
                                        ),
                                      )
                                    ],
                                  )
                                : CircleAvatar(
                                    child: Text(
                                      (_currentIndex() + 1).toString(),
                                    ),
                                  ),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            iconSize: 30.0,
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: (_currentIndex() ==
                                    pokemonState.pokemons.length - 1)
                                ? null
                                : _nextBall,
                          ),
                        ),
                      ],
                    )
                  : Container(
                      width: 0.0,
                      height: 60.0,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _previousBall() {
    var newIndex = _getNewIndex(isNext: false);
    var offset = MediaQuery.of(context).size.width * newIndex;
    scrollController
        .animateTo(offset,
            duration: const Duration(milliseconds: 200), curve: Curves.linear)
        .whenComplete(() => setState(() {}));
  }

  void _nextBall() {
    var newIndex = _getNewIndex(isNext: true);
    var offset = MediaQuery.of(context).size.width * newIndex;
    scrollController
        .animateTo(offset,
            duration: const Duration(milliseconds: 200), curve: Curves.linear)
        .whenComplete(() => setState(() {}));
  }

  int _currentIndex() {
    var current = pokemonState.pokemons
        .indexWhere((element) => element.name == currentPokemon.name);
    return current;
  }

  int _getNewIndex({@required bool isNext}) {
    var itemIndex = _currentIndex();
    if (isNext) {
      itemIndex += 1;
    } else {
      itemIndex -= 1;
    }
    return itemIndex;
  }
}
