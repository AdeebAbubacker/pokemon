part of 'filterpokemon_types_bloc.dart';

@freezed
class FilterpokemonTypesEvent with _$FilterpokemonTypesEvent {
  const factory FilterpokemonTypesEvent.started() = _Started;
  const factory FilterpokemonTypesEvent.filterPokemon({required String type}) =
      _FilterpokemonTypesEvent;
}
