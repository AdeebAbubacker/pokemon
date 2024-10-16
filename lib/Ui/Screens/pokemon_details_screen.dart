
import 'package:flutter/material.dart';

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
