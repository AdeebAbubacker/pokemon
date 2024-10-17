part of 'get_pokemon_details_bloc.dart';

@freezed
class GetPokemonDetailsState with _$GetPokemonDetailsState {
  const factory GetPokemonDetailsState.initial() = _Initial;
  const factory GetPokemonDetailsState.loading() = _Loading;
  const factory GetPokemonDetailsState.success(
      PokemonFullDetailModel pokemondetails) = _Success;
  const factory GetPokemonDetailsState.noInternet() = _NoInternet;
  const factory GetPokemonDetailsState.failure(String error) = _Failure;
}
