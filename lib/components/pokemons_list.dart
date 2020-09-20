import 'package:flutter/material.dart';
import 'package:pokedex_app/bloc/pokemon_bloc.dart';
import 'package:pokedex_app/bloc/provider.dart';
import 'package:pokedex_app/components/pokemon_card.dart';
import 'package:pokedex_app/helpers/strings.dart';

class PokemonsList extends StatefulWidget {
  const PokemonsList({
    Key key,
    @required this.scrollController,
  }) : super(key: key);

  final ScrollController scrollController;

  @override
  _PokemonsListState createState() => _PokemonsListState();
}

class _PokemonsListState extends State<PokemonsList> {
  var _scrollController;
  PokemonState pokemonState = PokemonState();
  int currentPage = 0;
  PokemonsBloc pokemonsBloc;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController;
    _scrollController.addListener(_scrollListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.pokemonsBloc = Provider.pokemonsBlocOf(context);
    this.pokemonsBloc.streamPokemonsSate.listen((PokemonState data) {
      if (!mounted) return;
      setState(() {
        this.pokemonState = data;
      });
      if (this.pokemonState.pokemons.isNotEmpty) {
        this.pokemonsBloc.sinkCurrentPokemon(
              this.pokemonState.pokemons[this.currentPage],
            );
      }
    });
  }

  void _evaluateMetrics(ScrollMetrics metrics) {
    this.currentPage = getCurrentPage(
      metrics.extentBefore,
      maxExtension: metrics.viewportDimension,
    );
    var endPage = metrics.viewportDimension * this.currentPage;
    Future.delayed(Duration.zero, () {
      _scrollController.animateTo(
        endPage,
        duration: Duration(milliseconds: 100),
        curve: Curves.linear,
      );
    });
  }

  void _scrollListener() {
    this.currentPage = getCurrentPage(_scrollController.offset);
    if (this.currentPage < 0 ||
        this.currentPage > (this.pokemonState.pokemons.length - 1)) return;
    this.pokemonsBloc.sinkCurrentPokemon(
          this.pokemonState.pokemons[this.currentPage],
        );
  }

  int getCurrentPage(double offset, {double maxExtension}) {
    return (offset / (maxExtension ?? MediaQuery.of(context).size.width))
        .round();
  }

  @override
  Widget build(BuildContext context) {
    return (this.pokemonState.loading)
        ? PokemonCardLoading()
        : Column(
            children: [
              Container(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollEndNotification) {
                        _evaluateMetrics(scrollNotification.metrics);
                      }
                      return true;
                    },
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      itemBuilder: (BuildContext context, int index) {
                        return PokemonCard(
                          pokemonBase: this.pokemonState.pokemons[index],
                        );
                      },
                      itemCount: this.pokemonState.pokemons.length,
                    ),
                  ),
                ),
              ),
              Text(
                Strings.info,
                textAlign: TextAlign.center,
              ),
            ],
          );
  }
}
