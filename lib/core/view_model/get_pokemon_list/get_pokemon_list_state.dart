part of 'get_pokemon_list_bloc.dart';

@freezed
class GetPokemonListState with _$GetPokemonListState {
  const factory GetPokemonListState.initial() = _Initial;
  const factory GetPokemonListState.loading() = _Loading;
  const factory GetPokemonListState.success(PokeMonListModel pokemonListmodel) =
      _Success;
  const factory GetPokemonListState.noInternet() = _NoInternet;
  const factory GetPokemonListState.failure(String error) = _Failure;
}
