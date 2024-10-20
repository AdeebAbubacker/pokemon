part of 'filterpokemon_types_bloc.dart';

@freezed
class FilterpokemonTypesState with _$FilterpokemonTypesState {
  const factory FilterpokemonTypesState.initial() = _Initial;
  const factory FilterpokemonTypesState.loading() = _Loading;
  const factory FilterpokemonTypesState.success(
      PokeMonListFullModel pokemonlist) = _Success;
  const factory FilterpokemonTypesState.noInternet() = _NoInternet;
  const factory FilterpokemonTypesState.failure(String error) = _Failure;
}
