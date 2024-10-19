class PokeMonListFullModel {
  final PokeMonListModel pokeMonListModel;
    final List<List<String>> speciesTypes; // Changed to a list of lists

  PokeMonListFullModel({
    required this.pokeMonListModel,
    required this.speciesTypes,
  });
}

class PokeMonListModel {
  final int count;
  final String? next;
  final String? previous;
  final List<PokemonModel> results;

  PokeMonListModel({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PokeMonListModel.fromJson(Map<String, dynamic> json) {
    var resultsList = json['results'] as List;
    List<PokemonModel> pokemonList =
        resultsList.map((pokemon) => PokemonModel.fromJson(pokemon)).toList();

    return PokeMonListModel(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: pokemonList,
    );
  }
}

class PokemonModel {
  final String name;
  final String url;
  final String image;
  final String pokemonId;

  PokemonModel({
    required this.name,
    required this.url,
    required this.image,
    required this.pokemonId,
  });

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    final String url = json['url'];
    // Extract the Pokémon ID from the URL to build the image URL
    final String pokemonId =
        url.split("/").where((element) => element.isNotEmpty).last;
    // final String imageUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$pokemonId.png';
    final String imageUrl =
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$pokemonId.png';

    return PokemonModel(
        name: json['name'] ?? '',
        url: json['url'] ?? '',
        image: imageUrl.isNotEmpty
            ? imageUrl
            : 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png', // default image
        pokemonId: pokemonId);
  }

  static List<PokemonModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((pokemon) => PokemonModel.fromJson(pokemon)).toList();
  }
}
