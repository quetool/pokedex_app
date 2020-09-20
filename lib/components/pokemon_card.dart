import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_app/models/pokemon.dart';
import 'package:pokedex_app/screens/details.dart';
import 'package:shimmer/shimmer.dart';

class PokemonCard extends StatefulWidget {
  PokemonCard({@required this.pokemonBase});
  final PokemonBase pokemonBase;
  @override
  _PokemonCardState createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard> {
  Pokemon _pokemonData;
  bool _opening = false;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _pokemonData = widget.pokemonBase.pokemon;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(MediaQuery.of(context).size.width / 2),
        ),
        boxShadow: [
          const BoxShadow(
            color: Colors.black,
            blurRadius: 10.0,
            offset: Offset(0.0, 0.0),
          ),
        ],
      ),
      margin: const EdgeInsets.all(16.0),
      child: GestureDetector(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/pokeball.png'),
                  ),
                ),
                child: (_pokemonData == null)
                    ? (_opening)
                        ? Transform.rotate(
                            angle: _timer.tick.toDouble(),
                            child: Image.asset('assets/pokeball2.png'),
                          )
                        : Image.asset('assets/pokeball2.png')
                    : Hero(
                        tag: _pokemonData.name,
                        child: Image(
                          image: CachedNetworkImageProvider(
                            _pokemonData
                                .sprites.other.officialArtwork.frontDefault,
                            scale: 2.5,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
        onTap: _openPokeBall,
      ),
    );
  }

  void _openPokeBall() {
    if (_pokemonData == null) {
      _getPokemonData();
    } else {
      Navigator.of(context).push(
        MaterialPageRoute<PokemonDetailsScreen>(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return PokemonDetailsScreen(
                pokemonData: _pokemonData,
              );
            }),
      );
    }
  }

  void _getPokemonData() {
    _timer = Timer.periodic(const Duration(milliseconds: 70), (timer) {
      setState(() {
        _opening = true;
      });
    });
    widget.pokemonBase.getPokemonData((pokemon) {
      if (mounted) {
        _timer.cancel();
        setState(() {
          _pokemonData = pokemon;
          _opening = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }
  }
}

class PokemonCardLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(MediaQuery.of(context).size.width / 2),
        ),
        boxShadow: [
          const BoxShadow(
            color: Colors.black,
            blurRadius: 10.0,
            offset: Offset(0.0, 0.0),
          ),
        ],
      ),
      margin: const EdgeInsets.all(16.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Image.asset('assets/pokeball2.png'),
        ),
      ),
    );
  }
}
