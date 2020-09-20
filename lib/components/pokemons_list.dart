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
  ScrollController _scrollController;
  PokemonState pokemonState = PokemonState();
  int currentPage = 0;
  PokemonsBloc pokemonsBloc;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController..addListener(_scrollListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    pokemonsBloc = Provider.pokemonsBlocOf(context);
    pokemonsBloc.streamPokemonsSate.listen((PokemonState data) {
      if (!mounted) return;
      setState(() {
        pokemonState = data;
      });
      if (pokemonState.pokemons.isNotEmpty) {
        pokemonsBloc.sinkCurrentPokemon(
          pokemonState.pokemons[currentPage],
        );
      }
    });
  }

  void _evaluateMetrics(ScrollMetrics metrics) {
    currentPage = getCurrentPage(
      metrics.extentBefore,
      maxExtension: metrics.viewportDimension,
    );
    var endPage = metrics.viewportDimension * currentPage;
    Future.delayed(Duration.zero, () {
      _scrollController.animateTo(
        endPage,
        duration: const Duration(milliseconds: 100),
        curve: Curves.linear,
      );
    });
  }

  void _scrollListener() {
    currentPage = getCurrentPage(_scrollController.offset);
    if (currentPage < 0 || currentPage > (pokemonState.pokemons.length - 1))
      return;
    pokemonsBloc.sinkCurrentPokemon(
      pokemonState.pokemons[currentPage],
    );
  }

  int getCurrentPage(double offset, {double maxExtension}) {
    return (offset / (maxExtension ?? MediaQuery.of(context).size.width))
        .round();
  }

  @override
  Widget build(BuildContext context) {
    return (pokemonState.loading)
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
                          pokemonBase: pokemonState.pokemons[index],
                        );
                      },
                      itemCount: pokemonState.pokemons.length,
                    ),
                  ),
                ),
              ),
              const Text(
                Strings.info,
                textAlign: TextAlign.center,
              ),
            ],
          );
  }
}
