import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/core/view_model/get_pokemon_details/get_pokemon_details_bloc.dart';

class ApiTesting extends StatelessWidget {
  const ApiTesting({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetPokemonDetailsBloc, GetPokemonDetailsState>(
      listener: (context, state) {
        state.maybeMap(
          orElse: () {
            print('else');
          },
          failure: (value) {
            print(value);
          },
          initial: (value) {
            print(value);
          },
          loading: (value) {
            print(value);
          },
          noInternet: (value) {
            print(value);
          },
          success: (value) {
            print(value);
          },
        );
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<GetPokemonDetailsBloc>(context).add(
                        GetPokemonDetailsEvent.getPokemonDetails(
                            pokemonId: '1'));
                  },
                  child: const Text("Call Api"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
