import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokemon/core/model/poke_mon_list_model/poke_mon_list_model.dart';
import 'package:pokemon/core/model/pokemon_type_model/pokemon_type_model.dart';
import 'package:pokemon/core/service/api_service.dart';

part 'filterpokemon_types_event.dart';
part 'filterpokemon_types_state.dart';
part 'filterpokemon_types_bloc.freezed.dart';

class FilterpokemonTypesBloc
    extends Bloc<FilterpokemonTypesEvent, FilterpokemonTypesState> {
  FilterpokemonTypesBloc() : super(_Initial()) {
    on<_FilterpokemonTypesEvent>((event, emit) async {
      emit(const FilterpokemonTypesState.loading());
      final response = await ApiService.getPokemonListByType(typeId: event.type);

      response.fold((failure) {
        if (failure == "No Internet") {
          print("No Internet");
          emit(const FilterpokemonTypesState.noInternet());
        } else {
          print(failure.toString());
          emit(FilterpokemonTypesState.failure(failure.toString()));
        }
      }, (success) {
        print(success);
        emit(FilterpokemonTypesState.success(success));
      });
    });
  }
}
