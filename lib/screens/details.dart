import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_app/helpers/helpers.dart';
import 'package:pokedex_app/helpers/strings.dart';
import 'package:pokedex_app/models/pokemon.dart';

class PokemonDetailsScreen extends StatefulWidget {
  const PokemonDetailsScreen({
    this.pokemonData,
  });

  final Pokemon pokemonData;

  @override
  _PokemonDetailsScreenState createState() => _PokemonDetailsScreenState();
}

class _PokemonDetailsScreenState extends State<PokemonDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 62, 50, 1.0),
        title: Text(Helpers().capitalize(widget.pokemonData.name)),
        actions: [
          AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              margin: const EdgeInsets.only(right: 8.0),
              child: Center(
                child: CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Text(
                    widget.pokemonData.order.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Container(
          padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.0,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      child: Hero(
                        tag: widget.pokemonData.name,
                        child: CachedNetworkImage(
                          imageUrl: widget.pokemonData.sprites.other
                              .officialArtwork.frontDefault,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Chip(
                            elevation: 4.0,
                            avatar: CircleAvatar(
                              backgroundColor: Colors.green,
                              child: Text(
                                widget.pokemonData.height.toString(),
                                style: TextStyle(
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                            label: Text(Strings.height),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Chip(
                            elevation: 4.0,
                            avatar: CircleAvatar(
                              backgroundColor: Colors.green,
                              child: Text(
                                widget.pokemonData.weight.toString(),
                                style: TextStyle(
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                            label: Text(Strings.weight),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: kToolbarHeight,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        Strings.stats,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Chip(
                              elevation: 4.0,
                              avatar: CircleAvatar(
                                child: Text(
                                  widget.pokemonData.stats[index].baseStat
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                              label: Text(
                                  widget.pokemonData.stats[index].stat.name),
                            ),
                          );
                        },
                        itemCount: widget.pokemonData.stats.length,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: kToolbarHeight,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        Strings.moves,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Chip(
                              elevation: 4.0,
                              label: Text(
                                  widget.pokemonData.moves[index].move.name),
                            ),
                          );
                        },
                        itemCount: widget.pokemonData.moves.length,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
