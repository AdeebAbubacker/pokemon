import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  // Store the selected types for filtering
  final List<String> selectedTypes = [];

  // All Pokémon types available for filtering
  final List<String> pokemonTypes = [
    'normal', 'flying', 'poison', 'bug', 'fire', 'water', 'grass', 'ground', 'electric'
  ];

  // List to store the fetched Pokémon names
  List<String> filteredPokemon = [];

  // Function to fetch Pokémon by type using the PokéAPI
  Future<List<String>> fetchPokemonByType(String type) async {
    final url = 'https://pokeapi.co/api/v2/type/$type/';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<String> pokemonList = (data['pokemon'] as List)
          .map((poke) => poke['pokemon']['name'].toString())
          .toList();
      return pokemonList;
    } else {
      throw Exception('Failed to load Pokémon');
    }
  }

  // Fetch the Pokémon filtered by the selected types
  Future<void> fetchFilteredPokemon() async {
    List<String> allFilteredPokemon = [];
    for (String type in selectedTypes) {
      List<String> pokemonList = await fetchPokemonByType(type);
      allFilteredPokemon.addAll(pokemonList);
    }

    setState(() {
      filteredPokemon = allFilteredPokemon;
    });
  }

  // Function to show filter selection in a modal bottom sheet
  void _showFilterSelection() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Pokémon Types',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: pokemonTypes.map((type) {
                  final isSelected = selectedTypes.contains(type);
                  return FilterChip(
                    label: Text(type.toUpperCase()),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          selectedTypes.add(type);
                        } else {
                          selectedTypes.remove(type);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  fetchFilteredPokemon();
                  Navigator.pop(context); // Close the bottom sheet
                },
                child: const Text('Apply Filters'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Pokémon by Type'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Filter container to show selected types
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 2), // Shadow position
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selected Filters',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: selectedTypes.isNotEmpty
                        ? selectedTypes.map((type) {
                            return Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(type.toUpperCase(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500)),
                            );
                          }).toList()
                        : [const Text('No filters applied')],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _showFilterSelection,
                    child: const Text('Select Filters'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Display the filtered Pokémon names
            if (filteredPokemon.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: filteredPokemon.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(filteredPokemon[index]),
                    );
                  },
                ),
              )
            else
              const Text('No Pokémon selected'),
          ],
        ),
      ),
    );
  }
}
