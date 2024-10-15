import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List<Pokemon> _pokemons = [];
  List<Pokemon> _filteredPokemons = [];
  bool _isLoading = true;
  List<String> _types = [];
  Set<String> _selectedTypes = {};

  @override
  void initState() {
    super.initState();
    fetchPokemons();
    fetchTypes();
  }

  Future<void> fetchPokemons() async {
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=20'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Pokemon> pokemons = [];

      for (var item in data['results']) {
        final pokemonDetailResponse = await http.get(Uri.parse(item['url']));
        if (pokemonDetailResponse.statusCode == 200) {
          final pokemonDetail = jsonDecode(pokemonDetailResponse.body);
          pokemons.add(Pokemon.fromJson(pokemonDetail));
        }
      }

      setState(() {
        _pokemons = pokemons;
        _filteredPokemons = pokemons; // Initialize with all pokemons
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load Pokémon data');
    }
  }

  Future<void> fetchTypes() async {
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/type'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _types = List<String>.from(data['results'].map((type) => type['name']));
      });
    } else {
      throw Exception('Failed to load Pokémon types');
    }
  }

  void _openFilterPopup() {
    showDialog(
      context: context,
      builder: (context) => FilterPopup(
        types: _types,
        selectedTypes: _selectedTypes,
        onApply: (selected) {
          setState(() {
            _selectedTypes = selected;
            _applyFilters();
          });
        },
      ),
    );
  }

  void _applyFilters() {
    if (_selectedTypes.isEmpty) {
      _filteredPokemons = _pokemons;
    } else {
      _filteredPokemons = _pokemons.where((pokemon) {
        // Check if any of the Pokémon's types match the selected types
        return pokemon.types.any((type) => _selectedTypes.contains(type));
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _openFilterPopup,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _filteredPokemons.length,
              itemBuilder: (context, index) {
                final pokemon = _filteredPokemons[index];
                return ListTile(
                  leading: Image.network(pokemon.imageUrl),
                  title: Text(pokemon.name),
                );
              },
            ),
    );
  }
}

class Pokemon {
  final String name;
  final String imageUrl;
  final List<String> types; // Change to List to support multiple types

  Pokemon({required this.name, required this.imageUrl, required this.types});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    // Extract all types for the Pokémon
    List<String> types = (json['types'] as List)
        .map((typeInfo) => typeInfo['type']['name'] as String)
        .toList();

    return Pokemon(
      name: json['name'],
      imageUrl: json['sprites']['front_default'], // URL for Pokémon image
      types: types, // Store all types
    );
  }
}

class FilterPopup extends StatelessWidget {
  final List<String> types;
  final Set<String> selectedTypes;
  final ValueChanged<Set<String>> onApply;

  FilterPopup({required this.types, required this.selectedTypes, required this.onApply});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Filter Pokémon"),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            const Text("Select Type:"),
            Wrap(
              spacing: 10,
              children: types.map((type) {
                return FilterChip(
                  label: Text(type),
                  selected: selectedTypes.contains(type),
                  onSelected: (selected) {
                    selected
                        ? selectedTypes.add(type)
                        : selectedTypes.remove(type);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text("Apply"),
          onPressed: () {
            onApply(selectedTypes);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}


