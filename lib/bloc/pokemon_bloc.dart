import 'package:pokedex_app/api/api_client.dart';
import 'package:pokedex_app/models/api_error.dart';
import 'package:pokedex_app/models/pokemon.dart';
import 'package:rxdart/rxdart.dart';

class PokemonState {
  bool loading = false;
  List<PokemonBase> pokemons = [];
  int currentPage = 0;
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

  void getMorePokemons() {
    var currentOffset = currentPokemonsState().currentPage;
    print('currentOffset $currentOffset');
    currentOffset = (currentOffset) + ApiClient().limit;
    getPokemons(offset: currentOffset);
  }

  void getPokemons({int offset = 0}) {
    print('getPokemons $offset');
    var currentState = currentPokemonsState()
      ..currentPage = offset
      ..loading = true
      ..error = null;
    sinkPokemonsSate(currentState);

    _apiClient.getPokemons(currentState.currentPage.toString()).then(
          (response) => _apiClient.responseHandler(response, (error, pokemons) {
            // pokemons.sort((a, b) => a.name.compareTo(b.name));
            currentState
              ..pokemons.addAll(pokemons)
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
