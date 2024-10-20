import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/Ui/Screens/pokemon_details_screen.dart';
import 'package:pokemon/core/const/text_style.dart';
import 'package:pokemon/core/service/api_service.dart';
import 'package:pokemon/core/view_model/filter_pokemon/filterpokemon_types_bloc.dart';
import 'package:pokemon/core/service/api_service_2.dart';

class ApiTesting extends StatelessWidget {
  const ApiTesting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showModal(context); // Call the _showModal function here
                  },
                  child: const Text("Open Modal"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // await ApiService.getPokemonListByType(typeId: 2);
                    BlocProvider.of<FilterpokemonTypesBloc>(context).add(
                        const FilterpokemonTypesEvent.filterPokemon(type: 2));
                  },
                  child: const Text("Call Api"),
                ),
                BlocBuilder<FilterpokemonTypesBloc, FilterpokemonTypesState>(
                  builder: (context, state) {
                    return state.maybeMap(
                      orElse: () {
                        return const Text('data');
                      },
                      failure: (value) {
                        return Text(value.error);
                      },
                      initial: (value) {
                        return const Text('Initial state');
                      },
                      loading: (value) {
                        return const CircularProgressIndicator();
                      },
                      success: (value) {
                        // allPokemons.addAll(value
                        //     .pokemonListmodel.pokeMonListModel.results);
                        List<Widget> speciesTypeWidgets =
                            value.pokemonlist.speciesTypes.map((type) {
                          return Text(
                            type.first,
                            style: const TextStyle(fontSize: 5),
                          );
                        }).toList();
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: value
                                .pokemonlist.pokeMonListModel.results.length,
                            itemBuilder: (context, index) {
                              String type =
                                  value.pokemonlist.speciesTypes[index].first;
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return PokemonDetailScreen(
                                          pokemonName: 'e',
                                          pokemonIndex: int.parse(value
                                              .pokemonlist
                                              .pokeMonListModel
                                              .results[index]
                                              .pokemonId));
                                    }));
                                  },
                                  child: SizedBox(
                                      width: 200,
                                      height: 187,
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 15),
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '#${value.pokemonlist.pokeMonListModel.results[index].pokemonId.toString().padLeft(3, '0')}', // Ensures a minimum of 3 digits
                                                            style: TextStyles
                                                                .poppins12black,
                                                          ),
                                                          Text(
                                                              value
                                                                  .pokemonlist
                                                                  .pokeMonListModel
                                                                  .results[
                                                                      index]
                                                                  .name,
                                                              style: TextStyles
                                                                  .poppins19white),
                                                          Row(
                                                            children: [
                                                              IconButton(
                                                                icon: Icon(
                                                                    // Change icon based on favorite status
                                                                    Icons
                                                                        .favorite,
                                                                    color: Colors
                                                                        .red),
                                                                onPressed:
                                                                    () {},
                                                              ),
                                                              Wrap(
                                                                children: value
                                                                        .pokemonlist
                                                                        .speciesTypes
                                                                        .isNotEmpty
                                                                    ? value
                                                                        .pokemonlist
                                                                        .speciesTypes[
                                                                            index] // Access the sublist at the specific index
                                                                        .map((type) =>
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(2.0),
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                    color: Colors.redAccent,
                                                                                    borderRadius: BorderRadius.circular(
                                                                                      12,
                                                                                    )),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.symmetric(
                                                                                    horizontal: 9,
                                                                                    vertical: 3,
                                                                                  ),
                                                                                  child: Text(
                                                                                    type, // Display each type individually
                                                                                    style: TextStyles.poppins12white, // Adjust font size as needed
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ))
                                                                        .toList()
                                                                    : [
                                                                        const Text(
                                                                            'fff',
                                                                            style:
                                                                                TextStyle(fontSize: 12))
                                                                      ], // Default text when the list is empty
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15),
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: Image.network(
                                                value
                                                    .pokemonlist
                                                    .pokeMonListModel
                                                    .results[index]
                                                    .image,
                                                width: 130,
                                                height: 130,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )));
                            },
                          ),
                        );
                      },
                      noInternet: (value) {
                        return const Text("No Internet");
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showModal(BuildContext context) {
    String? selectedType;
    showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return DraggableScrollableSheet(
              maxChildSize: 0.8,
              initialChildSize: 0.7,
              minChildSize: 0.5,
              expand: false,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Column(
                  children: [
                    const SizedBox(height: 21),
                    // Title Row with close button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Filter by Title",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.close, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Wrap widget displaying Pokémon types
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Wrap(
                            spacing: 10.0,
                            runSpacing: 10.0,
                            children: pokemonTypes.map((type) {
                              return FilterChip(
                                label: Text(type.name),
                                onSelected: (bool value) {
                                  setState(() {
                                    selectedType = value
                                        ? type.id.toString() : ''; // Set selected type
                                  });
                                  BlocProvider.of<FilterpokemonTypesBloc>(
                                          context)
                                      .add(
                                          FilterpokemonTypesEvent.filterPokemon(
                                    type: type.id,
                                  ));
                                  Navigator.of(context)
                                      .pop(); // Close the modal after selection
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    // Bottom buttons with 10 spacing and padding at bottom
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 10, left: 20, right: 20, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Handle Clear action
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.red, // Customize clear button color
                            ),
                            child: const Text('Clear'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<FilterpokemonTypesBloc>(context)
                                  .add(FilterpokemonTypesEvent.filterPokemon(
                                type: int.parse(selectedType!) ,
                              ));
                            },
                            child: const Text('Apply Filter'),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }


}

// Model for Pokémon Type
class PokemonType {
  final int id;
  final String name;

  PokemonType({required this.id, required this.name});
}

// List of Pokémon Types
final List<PokemonType> pokemonTypes = [
  PokemonType(id: 1, name: "normal"),
  PokemonType(id: 2, name: "fighting"),
  PokemonType(id: 3, name: "flying"),
  PokemonType(id: 4, name: "poison"),
  PokemonType(id: 5, name: "ground"),
  PokemonType(id: 6, name: "rock"),
  PokemonType(id: 7, name: "bug"),
  PokemonType(id: 8, name: "ghost"),
  PokemonType(id: 9, name: "steel"),
  PokemonType(id: 10, name: "fire"),
  PokemonType(id: 11, name: "water"),
  PokemonType(id: 12, name: "grass"),
  PokemonType(id: 13, name: "electric"),
  PokemonType(id: 14, name: "psychic"),
  PokemonType(id: 15, name: "ice"),
  PokemonType(id: 16, name: "dragon"),
  PokemonType(id: 17, name: "dark"),
  PokemonType(id: 18, name: "fairy"),
];
