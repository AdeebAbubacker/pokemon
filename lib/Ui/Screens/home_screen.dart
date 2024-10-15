import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/Ui/Screens/favourites_screen.dart';
import 'package:pokemon/Ui/Widgets/search_delegate.dart';
import 'package:pokemon/core/const/text_style.dart';
import 'package:pokemon/core/model/poke_mon_list_model/poke_mon_list_model.dart';
import 'package:pokemon/core/view_model/get_pokemon_list/get_pokemon_list_bloc.dart';

import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/core/const/text_style.dart';
import 'package:pokemon/core/model/poke_mon_list_model/poke_mon_list_model.dart';
import 'package:pokemon/core/view_model/get_pokemon_list/get_pokemon_list_bloc.dart';

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

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Home'),
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
                      padding: const EdgeInsets.symmetric(horizontal: 10),
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
                          InkWell(
                            onTap: () {
                              showSearch(
                                context: context,
                                delegate: PokemonSearchDelegate(),
                              );
                            },
                            child: Container(
                              child: Text("Search"),
                            ),
                          ),
                          Text("Filter")
                        ],
                      ),
                    ),
                  ],
                ),
                BlocBuilder<GetPokemonListBloc, GetPokemonListState>(
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
                            return const Center(child: Text("No Internet"));
                          },
                          success: (value) {
                            allPokemons.addAll(value.pokemonListmodel.results!);

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: allPokemons.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1 / 1.5,
                                  mainAxisSpacing: 15,
                                  crossAxisSpacing: 15,
                                ),
                                itemBuilder: (context, index) {
                                  final pokemon = allPokemons[index];

                                  return GestureDetector(
                                    onTap: () {
                                      // Handle tap for Pokémon detail screen if needed
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 191, 253, 255),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AspectRatio(
                                            aspectRatio: 1 / 0.9,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Image.network(
                                                pokemon.image,
                                                width: double.infinity,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            pokemon.name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              // Change icon based on favorite status
                                              Icons.favorite,
                                              color: isFavorite(pokemon)
                                                  ? Colors.red
                                                  : Colors.grey,
                                            ),
                                            onPressed: () {
                                              _toggleFavorite(pokemon);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
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

  bool isFavorite(PokemonModel pokemon) {
    // Implement your logic to check if the Pokémon is in favorites
    // This can involve checking Firestore or local state
    // For now, return false as a placeholder
    return false;
  }

  Widget _buildLoadingGrid() {
    return const Center(child: CircularProgressIndicator());
  }
}
