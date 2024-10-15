import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PokemonSearchDelegate extends SearchDelegate<String> {
  List<String> _allPokemons = [];

  PokemonSearchDelegate() {
    _fetchAllPokemons();
  }
//------------------------
//---------------
  Future<void> _fetchAllPokemons() async {
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=1000'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _allPokemons = List<String>.from(data['results'].map((pokemon) => pokemon['name']));
    } else {
      throw Exception('Failed to load Pokémon');
    }
  }

  @override
  String get searchFieldLabel => 'Search for a Pokémon';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear the query
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
       
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // You can handle what happens after a user selects a Pokémon here.
    return Container(); // You could show the selected Pokémon here.
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? []
        : _allPokemons.where((pokemon) => pokemon.startsWith(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () {
            close(context, suggestions[index]); // Return the selected Pokémon
          },
        );
      },
    );
  }
}