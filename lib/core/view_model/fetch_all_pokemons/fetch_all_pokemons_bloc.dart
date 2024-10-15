import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokemon/core/model/poke_mon_list_model/poke_mon_list_model.dart';
import 'package:pokemon/core/service/api_service.dart';

part 'fetch_all_pokemons_event.dart';
part 'fetch_all_pokemons_state.dart';
part 'fetch_all_pokemons_bloc.freezed.dart';

class FetchAllPokemonsBloc
    extends Bloc<FetchAllPokemonsEvent, FetchAllPokemonsState> {
  FetchAllPokemonsBloc() : super(_Initial()) {
    on<_FetchAllPokemonList>((event, emit) async {
      emit(const FetchAllPokemonsState.loading());
      final response = await ApiService.fetchAllPokemons();

      response.fold((failure) {
        if (failure == "No Internet") {
          emit(const FetchAllPokemonsState.noInternet());
        } else {
          emit(FetchAllPokemonsState.failure(failure.toString()));
        }
      }, (success) {
        emit(FetchAllPokemonsState.success(success));
      });
    });
  }
}
