import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokemon/core/model/pokemon_detailed_model/pokemon_detailed_model.dart';
import 'package:pokemon/core/service/api_service.dart';

part 'get_pokemon_details_event.dart';
part 'get_pokemon_details_state.dart';
part 'get_pokemon_details_bloc.freezed.dart';

class GetPokemonDetailsBloc
    extends Bloc<GetPokemonDetailsEvent, GetPokemonDetailsState> {
  GetPokemonDetailsBloc() : super(_Initial()) {
    on<_GetPokemonDetails>((event, emit) async {
      emit(const GetPokemonDetailsState.loading());
      final response =
          await ApiService.getPokemonDeatils(pokemonId: event.pokemonId);

      response.fold((failure) {
        if (failure == "No Internet") {
          emit(const GetPokemonDetailsState.noInternet());
        } else {
          emit(GetPokemonDetailsState.failure(failure.toString()));
        }
      }, (success) {
        emit(GetPokemonDetailsState.success(success));
      });
    });
  }
}
