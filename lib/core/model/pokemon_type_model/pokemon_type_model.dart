class PokemonTypeModel {
  final DamageRelations damageRelations;
  final List<GameIndex> gameIndices;
  final Generation generation;
  final int id;
  final MoveDamageClass moveDamageClass;
  final List<Move> moves;
  final String name;
  final List<PokemonEntry> pokemon;
  final List<Name> names;

  PokemonTypeModel({
    required this.damageRelations,
    required this.gameIndices,
    required this.generation,
    required this.id,
    required this.moveDamageClass,
    required this.moves,
    required this.name,
    required this.pokemon,
    required this.names,
  });

  // Factory method to create a PokemonTypeModel from JSON with null handling
  factory PokemonTypeModel.fromJson(Map<String, dynamic> json) {
    return PokemonTypeModel(
      damageRelations: json['damage_relations'] != null
          ? DamageRelations.fromJson(json['damage_relations'])
          : DamageRelations(),
      gameIndices: (json['game_indices'] as List<dynamic>?)
              ?.map((e) => GameIndex.fromJson(e))
              .toList() ??
          [],
      generation: json['generation'] != null
          ? Generation.fromJson(json['generation'])
          : Generation(name: '', url: ''),
      id: json['id'] ?? 0,
      moveDamageClass: json['move_damage_class'] != null
          ? MoveDamageClass.fromJson(json['move_damage_class'])
          : MoveDamageClass(name: '', url: ''),
      moves: (json['moves'] as List<dynamic>?)
              ?.map((e) => Move.fromJson(e))
              .toList() ??
          [],
      name: json['name'] ?? '',
      pokemon: (json['pokemon'] as List<dynamic>?)
              ?.map((e) => PokemonEntry.fromJson(e))
              .toList() ??
          [],
      names: (json['names'] as List<dynamic>?)
              ?.map((e) => Name.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class DamageRelations {
  DamageRelations();

  factory DamageRelations.fromJson(Map<String, dynamic> json) {
    return DamageRelations();
  }
}

class GameIndex {
  final int gameIndex;
  final Generation generation;

  GameIndex({
    required this.gameIndex,
    required this.generation,
  });

  factory GameIndex.fromJson(Map<String, dynamic> json) {
    return GameIndex(
      gameIndex: json['game_index'] ?? 0,
      generation: json['generation'] != null
          ? Generation.fromJson(json['generation'])
          : Generation(name: '', url: ''),
    );
  }
}

class Generation {
  final String name;
  final String url;

  Generation({required this.name, required this.url});

  factory Generation.fromJson(Map<String, dynamic> json) {
    return Generation(
      name: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class MoveDamageClass {
  final String name;
  final String url;

  MoveDamageClass({
    required this.name,
    required this.url,
  });

  factory MoveDamageClass.fromJson(Map<String, dynamic> json) {
    return MoveDamageClass(
      name: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class Move {
  final String name;
  final String url;

  Move({
    required this.name,
    required this.url,
  });

  factory Move.fromJson(Map<String, dynamic> json) {
    return Move(
      name: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class PokemonEntry {
  final Pokemon pokemon;
  final int slot;

  PokemonEntry({
    required this.pokemon,
    required this.slot,
  });

  factory PokemonEntry.fromJson(Map<String, dynamic> json) {
    return PokemonEntry(
      pokemon: json['pokemon'] != null
          ? Pokemon.fromJson(json['pokemon'])
          : Pokemon(
              name: '',
              url: '',
              image: '',
              pokemonId: '1',
            ),
      slot: json['slot'] ?? 0,
    );
  }
}

class Pokemon {
  final String name;
  final String url;
  final String image;
  final String pokemonId;

  Pokemon({
    required this.name,
    required this.url,
    required this.image,
    required this.pokemonId,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final String url = json['url'];
    final String pokemonId =
        url.split("/").where((element) => element.isNotEmpty).last;
    // final String imageUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$pokemonId.png';
    final String imageUrl =
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$pokemonId.png';

    return Pokemon(
        name: json['name'] ?? '',
        url: json['url'] ?? '',
        image: imageUrl.isNotEmpty
            ? imageUrl
            : 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png', // default image
        pokemonId: pokemonId);
  }
}

class Name {
  final String name;
  final Language language;

  Name({
    required this.name,
    required this.language,
  });

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      name: json['name'] ?? '',
      language: json['language'] != null
          ? Language.fromJson(json['language'])
          : Language(name: '', url: ''),
    );
  }
}

class Language {
  final String name;
  final String url;

  Language({
    required this.name,
    required this.url,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      name: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
