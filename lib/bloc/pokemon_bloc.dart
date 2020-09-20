import 'package:pokedex_app/api/api_client.dart';
import 'package:pokedex_app/models/api_error.dart';
import 'package:pokedex_app/models/pokemon.dart';
import 'package:rxdart/rxdart.dart';

class PokemonState {
  bool loading = false;
  List<PokemonBase> pokemons = [];
  ApiError error;
}

class PokemonsBloc extends Object {
  final _apiClient = ApiClient();

  final _pokemonsState = BehaviorSubject<PokemonState>();
  Stream<PokemonState> get streamPokemonsSate => _pokemonsState.stream;
  Function(PokemonState) get sinkPokemonsSate => _pokemonsState.sink.add;

  PokemonState currentPokemonsState() {
    var currentState = _pokemonsState.stream.value;
    currentState ??= PokemonState();
    return currentState;
  }

  void getPokemons() {
    var currentState = currentPokemonsState()
      ..loading = true
      ..error = null;
    sinkPokemonsSate(currentState);

    _apiClient.getPokemons().then(
          (response) => _apiClient.responseHandler(response, (error, pokemons) {
            pokemons.sort((a, b) => a.name.compareTo(b.name));
            currentState
              ..pokemons = pokemons
              ..error = error
              ..loading = false;
            sinkPokemonsSate(currentState);
          }),
        );
  }

  final _currentPokemon = BehaviorSubject<PokemonBase>();
  Stream<PokemonBase> get streamCurrentPokemon => _currentPokemon.stream;
  Function(PokemonBase) get sinkCurrentPokemon => _currentPokemon.sink.add;

  void dispose() {
    _pokemonsState.close();
    _currentPokemon.close();
  }
}
