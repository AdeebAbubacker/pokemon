part of 'get_pokemon_list_bloc.dart';

@freezed
class GetPokemonListEvent with _$GetPokemonListEvent {
  const factory GetPokemonListEvent.started() = _Started;
  const factory GetPokemonListEvent.getPokemonList({required int offset}) =
      _GetPokemonList;
}
