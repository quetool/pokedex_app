import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokedex_app/models/api_error.dart';
import 'package:pokedex_app/models/pokemon.dart';

class ApiClient {
  factory ApiClient() {
    return _singleton;
  }
  ApiClient._internal();

  String _baseUrl;
  String _pokemon;
  int limit = 20;

  static final ApiClient _singleton = ApiClient._internal().._init();

  void _init() {
    _baseUrl = 'https://pokeapi.co/api/v2/';
    _pokemon = '/pokemon';
  }

  Future<http.Response> getPokemons(String offset) {
    return http.get('$_baseUrl$_pokemon?limit=$limit&offset=$offset');
  }

  Future<http.Response> getPokemonDetails(String name) {
    return http.get('$_baseUrl$_pokemon/$name');
  }

  void responseHandler(http.Response response,
      Function(ApiError error, List<PokemonBase> pokemons) completion) {
    if (response.statusCode == 200) {
      try {
        var jsonArray = json.decode(response.body)['results'] as List;
        var pokemonList = jsonArray
            .map((dynamic e) => PokemonBase.fromJson(e as Map<String, dynamic>))
            .toList();
        completion(null, pokemonList);
      } catch (e) {
        print(e);
        var error = ApiError()
          ..statusCode = response.statusCode
          ..error = e.toString();
        completion(error, null);
      }
    } else {
      completion(
          ApiError.fromJson(json.decode(response.body) as Map<String, dynamic>),
          null);
    }
  }

  void responseHandlerPokemon(http.Response response,
      Function(ApiError error, Pokemon pokemon) completion) {
    if (response.statusCode == 200) {
      try {
        var jsonObject = json.decode(response.body) as Map<String, dynamic>;
        completion(null, Pokemon.fromJson(jsonObject));
      } catch (e) {
        print(e);
        var error = ApiError()
          ..statusCode = response.statusCode
          ..error = e.toString();
        completion(error, null);
      }
    } else {
      completion(
          ApiError.fromJson(json.decode(response.body) as Map<String, dynamic>),
          null);
    }
  }
}
