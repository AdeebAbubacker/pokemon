import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokemon/core/model/poke_mon_list_model/poke_mon_list_model.dart';
import 'package:pokemon/core/service/api_service.dart';

part 'get_pokemon_list_event.dart';
part 'get_pokemon_list_state.dart';
part 'get_pokemon_list_bloc.freezed.dart';

class GetPokemonListBloc
    extends Bloc<GetPokemonListEvent, GetPokemonListState> {
  GetPokemonListBloc() : super(const _Initial()) {
    on<_GetPokemonList>((event, emit) async {
      emit(const GetPokemonListState.loading());
      final response = await ApiService.getPokemonList(offset: event.offset);

      response.fold((failure) {
        if (failure == "No Internet") {
          emit(const GetPokemonListState.noInternet());
        } else {
          emit(GetPokemonListState.failure(failure.toString()));
        }
      }, (success) {
        emit(GetPokemonListState.success(success));
      });
    });
  }
}
