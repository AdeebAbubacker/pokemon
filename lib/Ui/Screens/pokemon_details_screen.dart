import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokemon/core/const/text_style.dart';
import 'package:pokemon/core/model/pokemon_detailed_model/pokemon_detailed_model.dart';
import 'package:pokemon/core/view_model/get_pokemon_details/get_pokemon_details_bloc.dart';

class PokemonDetailScreen extends StatefulWidget {
  final String pokemonName;
  final int pokemonIndex;
  const PokemonDetailScreen({
    super.key,
    required this.pokemonName,
    required this.pokemonIndex,
  });

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Initial API call
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<GetPokemonDetailsBloc>(context)
          .add(GetPokemonDetailsEvent.getPokemonDetails(
        pokemonId: widget.pokemonIndex.toString(),
      ));
    });
    return Scaffold(
      body: BlocBuilder<GetPokemonDetailsBloc, GetPokemonDetailsState>(
        builder: (context, state) {
          return state.maybeMap(
            orElse: () {
              return const Center(child: Text("No Data Available"));
            },
            loading: (value) {
              return const Center(child: CircularProgressIndicator());
            },
            failure: (value) {
              return Center(child: Text("Error: ${value.error}"));
            },
            success: (value) {
              final pokemonData = value.pokemondetails.pokemonDetails;
              final fullpokemonData = value.pokemondetails;
              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(Icons.arrow_back_ios_new)),
                              const Spacer(),
                              Text(
                                pokemonData.name!.toUpperCase(),
                                style: TextStyles.poppins16lightgreyDA6,
                              ),
                              const Spacer(),
                              Image.network(
                                  'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/${pokemonData.id}.gif'),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),
                        buildPokemonImage(
                          pokemonData: pokemonData,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          pokemonData.name!.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'ID: ${pokemonData.id.toString().padLeft(3, '0')}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),

                        // Tabs for Detail, Types, and Stats
                        DefaultTabController(
                          length: 4,
                          child: Column(
                            children: [
                              const TabBar(
                                labelColor: Colors.black,
                                indicatorColor: Colors.blue,
                                tabs: [
                                  Tab(text: "Forms"),
                                  Tab(text: "Detail"),
                                  Tab(text: "Types"),
                                  Tab(text: "Stats"),
                                ],
                              ),
                              SizedBox(
                                height: 400,
                                width: double.infinity,
                                child: TabBarView(
                                  children: [
                                    BuildFormsTab(
                                      pokemonData: fullpokemonData,
                                    ),
                                    BuildDetailedTab(
                                      pokemonData: pokemonData,
                                    ),
                                    BuildTypesTab(
                                      pokemonData: pokemonData,
                                    ),
                                    BuildStatsTab(
                                      pokemonData: pokemonData,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class BuildDetailedTab extends StatelessWidget {
  final PokemonDetailedModel pokemonData;
  const BuildDetailedTab({
    super.key,
    required this.pokemonData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text('Height: ${pokemonData.height}'),
        Text('Weight: ${pokemonData.weight}'),
      ],
    );
  }
}

class BuildFormsTab extends StatelessWidget {
  final PokemonFullDetailModel pokemonData;
  const BuildFormsTab({
    super.key,
    required this.pokemonData,
  });

  @override
  Widget build(BuildContext context) {
    String frontImage = pokemonData.pokemonDetails.sprites?.frontDefault ?? '';
    String backImage = pokemonData.pokemonDetails.sprites?.backDefault ?? '';
    String shinyImage = pokemonData.pokemonDetails.sprites?.frontShiny ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Forms',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),

        // Display images in a row
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly, // Align evenly in the row
          children: [
            // Front Image
            if (frontImage.isNotEmpty)
              Column(
                children: [
                  SizedBox(
                    width: 70, // Fixed width
                    height: 70, // Fixed height
                    child: Image.network(frontImage, fit: BoxFit.cover),
                  ),
                ],
              ),

            // Back Image
            if (backImage.isNotEmpty)
              Column(
                children: [
                  SizedBox(
                    width: 70, // Fixed width
                    height: 70, // Fixed height
                    child: Image.network(backImage, fit: BoxFit.cover),
                  ),
                ],
              ),

            // Shiny Image
            if (shinyImage.isNotEmpty)
              Column(
                children: [
                  SizedBox(
                    width: 70, // Fixed width
                    height: 70, // Fixed height
                    child: Image.network(shinyImage, fit: BoxFit.cover),
                  ),
                ],
              ),
          ],
        ),

        // Flavor text
        const SizedBox(height: 10),
        Text('${pokemonData.flavorText}'),
      ],
    );
  }
}

class BuildTypesTab extends StatelessWidget {
  final PokemonDetailedModel pokemonData;
  const BuildTypesTab({
    super.key,
    required this.pokemonData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Types',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          children: List.generate(
            pokemonData.types?.length ?? 0,
            (index) => Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Chip(
                  label: Text(pokemonData.types![index].type!.name.toString())),
            ),
          ),
        ),
      ],
    );
  }
}

class BuildStatsTab extends StatelessWidget {
  final PokemonDetailedModel pokemonData;
  const BuildStatsTab({
    super.key,
    required this.pokemonData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Stats',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...pokemonData.stats!.map<Widget>((stat) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text(stat.stat!.name.toString())),
                Expanded(
                  flex: 3,
                  child: LinearProgressIndicator(
                    value: stat.baseStat! / 100,
                    backgroundColor: Colors.grey[700],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildPokemonImage(Map<String, dynamic> pokemonData) {
    // Placeholder animated sprite URL (this is just an example, use real data from your API)
    String? animatedSpriteUrl = pokemonData['sprites']['versions']
            ['generation-v']['black-white']['animated']['front_default'] ??
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/1.gif';

    // Placeholder static official artwork URL (again, just an example)
    String? staticImageUrl = pokemonData['sprites']['other']['official-artwork']
            ['front_default'] ??
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png';

    // Use the animated sprite if available, otherwise use the static image
    return Image.network(
      animatedSpriteUrl ??
          staticImageUrl ??
          '', // Ensure there's a fallback even if both are null
      height: 200, // Set the height or any other styling you need
      fit: BoxFit
          .contain, // Optional: to control how the image fits within the container
      errorBuilder: (context, error, stackTrace) {
        // In case there's an issue with loading, show a placeholder or error widget
        return const Icon(Icons.error, size: 100, color: Colors.red);
      },
    );
  }
}

class buildPokemonImage extends StatelessWidget {
  final PokemonDetailedModel pokemonData;
  const buildPokemonImage({
    super.key,
    required this.pokemonData,
  });

  @override
  Widget build(BuildContext context) {
    String? spriteUrl = pokemonData.sprites?.frontDefault;
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 196, 231, 231),
          borderRadius: BorderRadius.circular(10)),
      child: Image.network(
        spriteUrl ?? '',
        height: MediaQuery.of(context).size.width * 0.8,
        width: MediaQuery.of(context).size.width * 0.8,
      ),
    );
  }
}
