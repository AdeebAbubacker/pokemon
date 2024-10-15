import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/core/view_model/fetch_all_pokemons/fetch_all_pokemons_bloc.dart';

class PokemonSearchDelegate extends SearchDelegate<String> {
  final FetchAllPokemonsBloc bloc;

  PokemonSearchDelegate({required this.bloc}) {
    bloc.add(const FetchAllPokemonsEvent
        .fetchAllPokemonList()); // Fetch the first batch of Pokémon
  }

  @override
  String get searchFieldLabel => 'Search for a Pokémon';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear the query
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, ''); // Close search
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(); // You can display the selected Pokémon here.
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return BlocBuilder<FetchAllPokemonsBloc, FetchAllPokemonsState>(
      bloc: bloc,
      builder: (context, state) {
        return state.maybeMap(
          loading: (_) => const Center(child: CircularProgressIndicator()),
          success: (successState) {
            final pokemons = successState.pokemonListmodel.results
                .map((pokemon) => pokemon.name)
                .where((pokemon) => pokemon.startsWith(query.toLowerCase()))
                .toList();

            return ListView.builder(
              itemCount: pokemons.length,
              itemBuilder: (context, index) {
                final pokemon = pokemons[index];
                final imageUrl =
                    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${index + 1}.png'; // Construct the image URL based on index

                return ListTile(
                  leading: Image.network(
                    imageUrl,
                    width: 50, // Set a fixed size for the image
                    height: 50,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons
                          .error); // Show error icon if image fails to load
                    },
                  ),
                  title: Text(pokemons[index]),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PokemonDetailScreen(
                            pokemonName: pokemon, pokemonIndex: index + 1),
                      ),
                    );
                  },
                );
              },
            );
          },
          failure: (failureState) =>
              Center(child: Text('Error: ${failureState.error}')),
          noInternet: (_) =>
              const Center(child: Text('No Internet connection.')),
          orElse: () => const Center(child: Text('No Pokémon found.')),
        );
      },
    );
  }
}

class PokemonDetailScreen extends StatelessWidget {
  final String pokemonName;
  final int pokemonIndex;

  const PokemonDetailScreen({
    Key? key,
    required this.pokemonName,
    required this.pokemonIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$pokemonIndex.png';

    return Scaffold(
      appBar: AppBar(
        title: Text(pokemonName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(imageUrl, width: 200, height: 200),
            const SizedBox(height: 20),
            Text(
              'You selected $pokemonName!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('Pokémon Index: $pokemonIndex'),
          ],
        ),
      ),
    );
  }
}
