part of 'fetch_all_pokemons_bloc.dart';

@freezed
class FetchAllPokemonsEvent with _$FetchAllPokemonsEvent {
  const factory FetchAllPokemonsEvent.started() = _Started;
  const factory FetchAllPokemonsEvent.fetchAllPokemonList() =
      _FetchAllPokemonList;
}
