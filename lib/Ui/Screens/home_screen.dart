import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/Ui/Screens/favourites_screen.dart';
import 'package:pokemon/Ui/Screens/pokemon_details_screen.dart';
import 'package:pokemon/Ui/Widgets/search_delegate.dart';
import 'package:pokemon/core/const/text_style.dart';
import 'package:pokemon/core/model/poke_mon_list_model/poke_mon_list_model.dart';
import 'package:pokemon/core/view_model/fetch_all_pokemons/fetch_all_pokemons_bloc.dart';
import 'package:pokemon/core/view_model/filter_pokemon/filterpokemon_types_bloc.dart';
import 'package:pokemon/core/view_model/get_pokemon_list/get_pokemon_list_bloc.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pokemon/test/api_testing.dart'; // Import Firestore

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Global key for the Scaffold

  final ScrollController _scrollController = ScrollController();
  int offset = 0; // Initial offset
  List<PokemonModel> allPokemons = []; // Local list to cache loaded Pokémon
  bool isFetchingMore = false; // To track if we're currently fetching more data
  bool _isItemSelected = false; // Track if an item is selected
  final StreamController<bool> _itemSelectedController =
      StreamController<bool>();

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    // Initial API call
    _fetchPokemonList();

    // Listen to scroll events
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        // If scrolled to the bottom, load more data
        _fetchMoreData();
      } else if (_scrollController.position.pixels < 0) {
        // If scrolled to the top, load previous data
        _fetchPreviousData();
      }
    });
  }

  void _fetchPokemonList() {
    BlocProvider.of<GetPokemonListBloc>(context)
        .add(const GetPokemonListEvent.getPokemonList(offset: 0));
    offset += 20; // Update the offset for the next request
  }

  @override
  void dispose() {
    _itemSelectedController.close();
    super.dispose();
  }

  void _updateItemSelected(bool value) {
    _isItemSelected = value;
    _itemSelectedController.sink.add(_isItemSelected);
  }

  void _fetchMoreData() {
    if (!isFetchingMore) {
      isFetchingMore = true;
      _fetchPokemonList();
    }
  }

  void _fetchPreviousData() {
    if (offset > 0) {
      offset -= 20; // Decrease offset for previous data
      BlocProvider.of<GetPokemonListBloc>(context)
          .add(GetPokemonListEvent.getPokemonList(offset: offset));
    }
  }

  Future<void> _onRefresh() async {
    // Reset offset and clear cached data
    offset = 0;
    allPokemons.clear();
    // Fetch new data
    _fetchPokemonList();
  }

  // Logout method
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Sign out from Firebase
      Navigator.pushReplacementNamed(context, '/'); // Navigate to LoginScreen
    } catch (e) {
      print('Logout failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout failed. Please try again.')),
      );
    }
  }

  Future<void> _toggleFavorite(PokemonModel pokemon) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final favoritesRef =
          _firestore.collection('users').doc(user.uid).collection('favorites');

      // Check if the Pokémon is already favorited
      final favoriteDoc =
          await favoritesRef.doc(pokemon.pokemonId.toString()).get();

      if (favoriteDoc.exists) {
        // Remove from favorites
        await favoritesRef.doc(pokemon.pokemonId.toString()).delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${pokemon.name} removed from favorites')),
        );
      } else {
        // Add to favorites
        await favoritesRef.doc(pokemon.pokemonId.toString()).set({
          'name': pokemon.name,
          'image': pokemon.image,
          'pokemonId': pokemon.pokemonId,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${pokemon.name} added to favorites')),
        );
      }
    }
  }

  Color _getOuterContainerColor(String type) {
    switch (type.toLowerCase()) {
      case 'grass':
        return const Color.fromARGB(255, 107, 218, 110);
      case 'poison':
        return const Color.fromARGB(255, 207, 96,
            227); // Violet color (or Colors.deepPurple if you prefer)
      case 'fire':
        return const Color.fromARGB(255, 245, 179, 93); // Yellow-orange color
      case 'flying':
        return const Color.fromARGB(255, 50, 118, 219); // Dark blue
      case 'water':
        return const Color.fromARGB(255, 97, 200, 248); // Light blue
      case 'bug':
        return const Color.fromARGB(255, 71, 205, 80); // Dark green
      case 'normal':
        return const Color.fromARGB(255, 202, 202, 202);
      case 'electric':
        return const Color.fromARGB(255, 244, 230, 101);
      case 'ground':
        return const Color.fromARGB(255, 216, 214, 214)
            .withOpacity(0.5); // Transparent ash
      case 'fairy':
        return const Color.fromARGB(255, 240, 158, 255); // Light purple
      case 'fighting':
        return const Color.fromARGB(255, 225, 106, 246)
            .withOpacity(0.5); // Transparent purple
      case 'psychic':
        return const Color.fromARGB(255, 255, 111, 100)
            .withOpacity(0.5); // Transparent red
      case 'rock':
        return const Color.fromARGB(255, 40, 39, 39)
            .withOpacity(0.5); // Transparent black
      case 'steel':
        return Colors.grey.shade800; // Dark grey
      case 'ice':
        return const Color.fromARGB(255, 116, 246, 230); // Dark green-blue
      case 'dark':
        return const Color.fromARGB(255, 35, 34, 34);
      case 'ghost':
        return const Color.fromARGB(255, 211, 208, 208);
      case 'dragon':
        return const Color.fromARGB(255, 78, 78, 78)
            .withOpacity(0.7); // Black 700
      default:
        return const Color.fromARGB(
            255, 147, 183, 201); // Greyish blue as the default color
    }
  }

  Color _getContainerColor(String type) {
    switch (type.toLowerCase()) {
      case 'grass':
        return Colors.green;
      case 'poison':
        return Colors
            .purple; // Violet color (or Colors.deepPurple if you prefer)
      case 'fire':
        return Colors.orangeAccent; // Yellow-orange color
      case 'flying':
        return Colors.blue.shade900; // Dark blue
      case 'water':
        return Colors.lightBlueAccent; // Light blue
      case 'bug':
        return Colors.green.shade900; // Dark green
      case 'normal':
        return Colors.grey;
      case 'electric':
        return Colors.yellow;
      case 'ground':
        return Colors.grey.withOpacity(0.5); // Transparent ash
      case 'fairy':
        return Colors.purpleAccent.shade100; // Light purple
      case 'fighting':
        return Colors.purple.withOpacity(0.5); // Transparent purple
      case 'psychic':
        return Colors.red.withOpacity(0.5); // Transparent red
      case 'rock':
        return Colors.black.withOpacity(0.5); // Transparent black
      case 'steel':
        return Colors.grey.shade800; // Dark grey
      case 'ice':
        return Colors.teal.shade700; // Dark green-blue
      case 'dark':
        return Colors.black;
      case 'ghost':
        return Colors.grey.shade500;
      case 'dragon':
        return Colors.black.withOpacity(0.7); // Black 700
      default:
        return Colors.blueGrey; // Greyish blue as the default color
    }
  }

  @override
  Widget build(BuildContext context) {
    Timer.periodic(Duration(seconds: 5), (_) {
      print('_is Itemslected ${_isItemSelected}');
    });
    User? currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Pokemon'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const FavouritesScreen();
                }));
              }, // Future functionality for favorites
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                image: DecorationImage(
                  image: NetworkImage(
                    currentUser?.photoURL ?? 'assets/default_profile.png',
                  ),
                ),
              ),
            ),
            Text(
              currentUser?.displayName ?? 'Guest',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              currentUser?.email ?? '',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red)),
                onPressed: () {
                  _logout(context);
                },
                child: const Text('Logout')),
          ],
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            "Pokedex",
                            style: TextStyles.poppins16greyDA6,
                          ),
                          Text(
                            "Search for a Pokemon by name or using its National Pokedex number.",
                            style: TextStyles.poppins14lightgreyDA6,
                          ),
                          const SizedBox(height: 40),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.01),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    showSearch(
                                      context: context,
                                      delegate: PokemonSearchDelegate(
                                        bloc: context
                                            .read<FetchAllPokemonsBloc>(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 231, 231, 231),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Row(
                                      children: [
                                        SizedBox(width: 10),
                                        Icon(Icons.search),
                                        SizedBox(width: 10),
                                        Text("Name or Number")
                                      ],
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    _showModal(context);
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.13,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 101, 100, 100),
                                        borderRadius:
                                            BorderRadius.circular(14)),
                                    child: Center(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 6,
                                                height: 6,
                                                decoration: BoxDecoration(
                                                  color: Colors
                                                      .transparent, // Set background to transparent
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: Colors
                                                        .white, // Border color
                                                    width:
                                                        1, // Border width (adjust as needed)
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 3),
                                              Container(
                                                width: 20,
                                                height: 4,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 20,
                                                height: 4,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              const SizedBox(width: 3),
                                              Container(
                                                width: 6,
                                                height: 6,
                                                decoration: BoxDecoration(
                                                  color: Colors
                                                      .transparent, // Set background to transparent
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: Colors
                                                        .white, // Border color
                                                    width:
                                                        1, // Border width (adjust as needed)
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                StreamBuilder<bool>(
                  stream: _itemSelectedController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data == true) {
                      return BlocBuilder<FilterpokemonTypesBloc,
                          FilterpokemonTypesState>(
                        builder: (context, state) {
                          return Column(
                            children: [
                              state.maybeMap(
                                orElse: () => const SizedBox.shrink(),
                                failure: (value) {
                                  return Center(child: Text(value.error));
                                },
                                initial: (value) {
                                  return _buildLoadingGrid(); // Show loading grid
                                },
                                loading: (value) {
                                  return _buildLoadingGrid(); // Show loading grid
                                },
                                noInternet: (value) {
                                  return const Center(
                                      child: Text("No Internet"));
                                },
                                success: (value) {
                                  // allPokemons.addAll(value
                                  //     .pokemonListmodel.pokeMonListModel.results);
                                  List<Widget> speciesTypeWidgets = value
                                      .pokemonlist.speciesTypes
                                      .map((type) {
                                    return Text(
                                      type.first,
                                      style: const TextStyle(fontSize: 5),
                                    );
                                  }).toList();
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: value.pokemonlist
                                          .pokeMonListModel.results.length,
                                      itemBuilder: (context, index) {
                                        String type = value.pokemonlist
                                            .speciesTypes[index].first;
                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return PokemonDetailScreen(
                                                    pokemonName: 'e',
                                                    pokemonIndex: index + 1);
                                              }));
                                            },
                                            child: SizedBox(
                                                width: 200,
                                                height: 187,
                                                child: Stack(
                                                  children: [
                                                    Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 15),
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                _getOuterContainerColor(
                                                                    type),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
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
                                                                          icon:
                                                                              Icon(
                                                                            // Change icon based on favorite status
                                                                            Icons.favorite,
                                                                            color: isFavorite(value.pokemonlist.pokeMonListModel.results[index])
                                                                                ? Colors.red
                                                                                : Colors.grey,
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            _toggleFavorite(value.pokemonlist.pokeMonListModel.results[index]);
                                                                          },
                                                                        ),
                                                                        Wrap(
                                                                          children: value
                                                                                  .pokemonlist.speciesTypes.isNotEmpty
                                                                              ? value
                                                                                  .pokemonlist
                                                                                  .speciesTypes[
                                                                                      index] // Access the sublist at the specific index
                                                                                  .map((type) =>
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(2.0),
                                                                                        child: Container(
                                                                                          decoration: BoxDecoration(
                                                                                              color: _getContainerColor(type),
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
                                                                                  const Text('fff', style: TextStyle(fontSize: 12))
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
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 15),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.topRight,
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
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      return BlocBuilder<GetPokemonListBloc,
                          GetPokemonListState>(
                        builder: (context, state) {
                          return Column(
                            children: [
                              state.maybeMap(
                                orElse: () => const SizedBox.shrink(),
                                failure: (value) {
                                  return Center(child: Text(value.error));
                                },
                                initial: (value) {
                                  return _buildLoadingGrid(); // Show loading grid
                                },
                                loading: (value) {
                                  return _buildLoadingGrid(); // Show loading grid
                                },
                                noInternet: (value) {
                                  return const Center(
                                      child: Text("No Internet"));
                                },
                                success: (value) {
                                  // allPokemons.addAll(value
                                  //     .pokemonListmodel.pokeMonListModel.results);
                                  List<Widget> speciesTypeWidgets = value
                                      .pokemonListmodel.speciesTypes
                                      .map((type) {
                                    return Text(
                                      type.first,
                                      style: const TextStyle(fontSize: 5),
                                    );
                                  }).toList();
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: value.pokemonListmodel
                                          .pokeMonListModel.results.length,
                                      itemBuilder: (context, index) {
                                        String type = value.pokemonListmodel
                                            .speciesTypes[index].first;
                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return PokemonDetailScreen(
                                                    pokemonName: 'e',
                                                    pokemonIndex: index + 1);
                                              }));
                                            },
                                            child: SizedBox(
                                                width: 200,
                                                height: 187,
                                                child: Stack(
                                                  children: [
                                                    Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 15),
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                _getOuterContainerColor(
                                                                    type),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      '#${value.pokemonListmodel.pokeMonListModel.results[index].pokemonId.toString().padLeft(3, '0')}', // Ensures a minimum of 3 digits
                                                                      style: TextStyles
                                                                          .poppins12black,
                                                                    ),
                                                                    Text(
                                                                        value
                                                                            .pokemonListmodel
                                                                            .pokeMonListModel
                                                                            .results[
                                                                                index]
                                                                            .name,
                                                                        style: TextStyles
                                                                            .poppins19white),
                                                                    Row(
                                                                      children: [
                                                                        IconButton(
                                                                          icon:
                                                                              Icon(
                                                                            // Change icon based on favorite status
                                                                            Icons.favorite,
                                                                            color: isFavorite(value.pokemonListmodel.pokeMonListModel.results[index])
                                                                                ? Colors.red
                                                                                : Colors.grey,
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            _toggleFavorite(value.pokemonListmodel.pokeMonListModel.results[index]);
                                                                          },
                                                                        ),
                                                                        Wrap(
                                                                          children: value
                                                                                  .pokemonListmodel.speciesTypes.isNotEmpty
                                                                              ? value
                                                                                  .pokemonListmodel
                                                                                  .speciesTypes[
                                                                                      index] // Access the sublist at the specific index
                                                                                  .map((type) =>
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(2.0),
                                                                                        child: Container(
                                                                                          decoration: BoxDecoration(
                                                                                              color: _getContainerColor(type),
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
                                                                                  const Text('fff', style: TextStyle(fontSize: 12))
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
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 15),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: Image.network(
                                                          value
                                                              .pokemonListmodel
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
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isFavorite(PokemonModel pokemon) {
    // Implement your logic to check if the Pokémon is in favorites
    // This can involve checking Firestore or local state
    // For now, return false as a placeholder
    return false;
  }

  Widget _buildLoadingGrid() {
    return const Center(child: CircularProgressIndicator());
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
                                        ? type.id.toString()
                                        : ''; // Set selected type
                                  });
                                  BlocProvider.of<FilterpokemonTypesBloc>(
                                          context)
                                      .add(
                                          FilterpokemonTypesEvent.filterPokemon(
                                    type: type.id,
                                  ));
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
                              setState(() {
                                _isItemSelected = false; // Clear selection
                              });
                              _updateItemSelected(false);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.red, // Customize clear button color
                            ),
                            child: const Text('Clear'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isItemSelected =
                                    true; // Update state based on selection
                              });
                              _updateItemSelected(true);
                              BlocProvider.of<FilterpokemonTypesBloc>(context)
                                  .add(FilterpokemonTypesEvent.filterPokemon(
                                type: int.parse(selectedType!),
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
