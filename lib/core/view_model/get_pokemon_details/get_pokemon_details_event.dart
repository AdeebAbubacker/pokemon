part of 'get_pokemon_details_bloc.dart';

@freezed
class GetPokemonDetailsEvent with _$GetPokemonDetailsEvent {
  const factory GetPokemonDetailsEvent.started() = _Started;
  const factory GetPokemonDetailsEvent.getPokemonDetails(
      {required String pokemonId}) = _GetPokemonDetails;
}
