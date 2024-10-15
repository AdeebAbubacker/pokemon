part of 'fetch_all_pokemons_bloc.dart';

@freezed
class FetchAllPokemonsState with _$FetchAllPokemonsState {
  const factory FetchAllPokemonsState.initial() = _Initial;
   const factory FetchAllPokemonsState.loading() = _Loading;
  const factory FetchAllPokemonsState.success(PokeMonListModel pokemonListmodel) =
      _Success;
  const factory FetchAllPokemonsState.noInternet() = _NoInternet;
  const factory FetchAllPokemonsState.failure(String error) = _Failure;
}
