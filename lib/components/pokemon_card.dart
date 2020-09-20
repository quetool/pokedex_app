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
    this._pokemonData = widget.pokemonBase.pokemon;
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
          BoxShadow(
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
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/pokeball.png'),
                  ),
                ),
                child: (this._pokemonData == null)
                    ? (this._opening)
                        ? Transform.rotate(
                            angle: this._timer.tick.toDouble(),
                            child: Image.asset('assets/pokeball2.png'),
                          )
                        : Image.asset('assets/pokeball2.png')
                    : Hero(
                        tag: this._pokemonData.name,
                        child: Image(
                          image: CachedNetworkImageProvider(
                            this
                                ._pokemonData
                                .sprites
                                .other
                                .officialArtwork
                                .frontDefault,
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

  _openPokeBall() {
    if (this._pokemonData == null) {
      _getPokemonData();
    } else {
      Navigator.of(context).push(
        MaterialPageRoute<PokemonDetailsScreen>(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return PokemonDetailsScreen(
                pokemonData: this._pokemonData,
              );
            }),
      );
    }
  }

  _getPokemonData() {
    this._timer = Timer.periodic(Duration(milliseconds: 70), (timer) {
      setState(() {
        this._opening = true;
      });
    });
    widget.pokemonBase.getPokemonData((pokemon) {
      if (mounted) {
        this._timer.cancel();
        setState(() {
          this._pokemonData = pokemon;
          this._opening = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (this._timer != null && this._timer.isActive) {
      this._timer.cancel();
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
          BoxShadow(
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
