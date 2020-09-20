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

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.pokemonsBlocOf(context).getPokemons();
    Provider.pokemonsBlocOf(context)
        .streamPokemonsSate
        .listen((PokemonState data) {
      if (!mounted) return;
      setState(() {
        this.pokemonState = data;
      });
    });
    Provider.pokemonsBlocOf(context)
        .streamCurrentPokemon
        .listen((PokemonBase data) {
      this.currentPokemon = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 62, 50, 1.0),
        title: Text((currentPokemon != null)
            ? Helpers().capitalize(currentPokemon.name)
            : ""),
        actions: [
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
            ),
            onPressed: () {
              SharedPreferences.getInstance().then((prefs) {
                var userId = prefs.getString("user_id");
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
                      scrollController: this.scrollController,
                    ),
                  ],
                ),
              ),
              (this.pokemonState.pokemons.isNotEmpty)
                  ? Row(
                      children: <Widget>[
                        IconButton(
                          iconSize: 30.0,
                          icon: Icon(Icons.arrow_back),
                          onPressed:
                              (_currentIndex() == 0) ? null : _previousBall,
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        IconButton(
                          iconSize: 30.0,
                          icon: Icon(Icons.arrow_forward),
                          onPressed: (_currentIndex() ==
                                  this.pokemonState.pokemons.length - 1)
                              ? null
                              : _nextBall,
                        )
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
    int newIndex = _getNewIndex(isNext: false);
    double offset = MediaQuery.of(context).size.width * newIndex;
    this
        .scrollController
        .animateTo(offset,
            duration: Duration(milliseconds: 200), curve: Curves.linear)
        .whenComplete(() => setState(() {}));
  }

  void _nextBall() {
    int newIndex = _getNewIndex(isNext: true);
    double offset = MediaQuery.of(context).size.width * newIndex;
    this
        .scrollController
        .animateTo(offset,
            duration: Duration(milliseconds: 200), curve: Curves.linear)
        .whenComplete(() => setState(() {}));
  }

  int _currentIndex() {
    int current = this
        .pokemonState
        .pokemons
        .indexWhere((element) => element.name == this.currentPokemon.name);
    // print("current $current");
    return current;
  }

  int _getNewIndex({@required bool isNext}) {
    int itemIndex = _currentIndex();
    if (isNext) {
      itemIndex += 1;
    } else {
      itemIndex -= 1;
    }
    return itemIndex;
  }
}
