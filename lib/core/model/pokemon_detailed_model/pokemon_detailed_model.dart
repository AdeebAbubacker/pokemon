class PokemonDetailedModel {
  List<Ability>? abilities;
  int? baseExperience;
  Cries? cries;
  List<Form>? forms;
  List<GameIndex>? gameIndices;
  int? height;
  List<HeldItem>? heldItems;
  int? id;
  bool? isDefault;
  String? locationAreaEncounters;
  List<Move>? moves;
  String? name;
  int? order;
  List<dynamic>? pastAbilities;
  List<dynamic>? pastTypes;
  Species? species;
  Sprites? sprites;
  List<Stat>? stats;
  List<Type>? types;
  int? weight;

  PokemonDetailedModel({
    this.abilities,
    this.baseExperience,
    this.cries,
    this.forms,
    this.gameIndices,
    this.height,
    this.heldItems,
    this.id,
    this.isDefault,
    this.locationAreaEncounters,
    this.moves,
    this.name,
    this.order,
    this.pastAbilities,
    this.pastTypes,
    this.species,
    this.sprites,
    this.stats,
    this.types,
    this.weight,
  });

  factory PokemonDetailedModel.fromJson(Map<String, dynamic> json) {
    return PokemonDetailedModel(
      abilities: (json['abilities'] as List?)
          ?.map((e) => Ability.fromJson(e as Map<String, dynamic>))
          .toList(),
      baseExperience: json['base_experience'] as int?,
      cries: json['cries'] != null ? Cries.fromJson(json['cries']) : null,
      forms: (json['forms'] as List?)
          ?.map((e) => Form.fromJson(e as Map<String, dynamic>))
          .toList(),
      gameIndices: (json['game_indices'] as List?)
          ?.map((e) => GameIndex.fromJson(e as Map<String, dynamic>))
          .toList(),
      height: json['height'] as int?,
      heldItems: (json['held_items'] as List?)
          ?.map((e) => HeldItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'] as int?,
      isDefault: json['is_default'] as bool?,
      locationAreaEncounters: json['location_area_encounters'] as String?,
      moves: (json['moves'] as List?)
          ?.map((e) => Move.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String?,
      order: json['order'] as int?,
      pastAbilities: json['past_abilities'] as List<dynamic>?,
      pastTypes: json['past_types'] as List<dynamic>?,
      species: json['species'] != null
          ? Species.fromJson(json['species'] as Map<String, dynamic>)
          : null,
      sprites: json['sprites'] != null
          ? Sprites.fromJson(json['sprites'] as Map<String, dynamic>)
          : null,
      stats: (json['stats'] as List?)
          ?.map((e) => Stat.fromJson(e as Map<String, dynamic>))
          .toList(),
      types: (json['types'] as List?)
          ?.map((e) => Type.fromJson(e as Map<String, dynamic>))
          .toList(),
      weight: json['weight'] as int?,
    );
  }
}

// Subclasses for each field

class Ability {
  AbilityDetail? ability;
  bool? isHidden;
  int? slot;

  Ability({this.ability, this.isHidden, this.slot});

  factory Ability.fromJson(Map<String, dynamic> json) {
    return Ability(
      ability: json['ability'] != null
          ? AbilityDetail.fromJson(json['ability'] as Map<String, dynamic>)
          : null,
      isHidden: json['is_hidden'] as bool?,
      slot: json['slot'] as int?,
    );
  }
}

class AbilityDetail {
  String? name;
  String? url;

  AbilityDetail({this.name, this.url});

  factory AbilityDetail.fromJson(Map<String, dynamic> json) {
    return AbilityDetail(
      name: json['name'] as String?,
      url: json['url'] as String?,
    );
  }
}

class Cries {
  String? crySound;
  String? cryLink;

  Cries({this.crySound, this.cryLink});

  factory Cries.fromJson(Map<String, dynamic> json) {
    return Cries(
      crySound: json['crySound'] as String?,
      cryLink: json['cryLink'] as String?,
    );
  }
}

class Form {
  String? name;
  String? url;

  Form({this.name, this.url});

  factory Form.fromJson(Map<String, dynamic> json) {
    return Form(
      name: json['name'] as String?,
      url: json['url'] as String?,
    );
  }
}

class GameIndex {
  int? gameIndex;
  Version? version;

  GameIndex({this.gameIndex, this.version});

  factory GameIndex.fromJson(Map<String, dynamic> json) {
    return GameIndex(
      gameIndex: json['game_index'] as int?,
      version: json['version'] != null
          ? Version.fromJson(json['version'] as Map<String, dynamic>)
          : null,
    );
  }
}

class Version {
  String? name;
  String? url;

  Version({this.name, this.url});

  factory Version.fromJson(Map<String, dynamic> json) {
    return Version(
      name: json['name'] as String?,
      url: json['url'] as String?,
    );
  }
}

class HeldItem {
  Item? item;

  HeldItem({this.item});

  factory HeldItem.fromJson(Map<String, dynamic> json) {
    return HeldItem(
      item: json['item'] != null
          ? Item.fromJson(json['item'] as Map<String, dynamic>)
          : null,
    );
  }
}

class Item {
  String? name;
  String? url;

  Item({this.name, this.url});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'] as String?,
      url: json['url'] as String?,
    );
  }
}

class Move {
  MoveDetail? move;

  Move({this.move});

  factory Move.fromJson(Map<String, dynamic> json) {
    return Move(
      move: json['move'] != null
          ? MoveDetail.fromJson(json['move'] as Map<String, dynamic>)
          : null,
    );
  }
}

class MoveDetail {
  String? name;
  String? url;

  MoveDetail({this.name, this.url});

  factory MoveDetail.fromJson(Map<String, dynamic> json) {
    return MoveDetail(
      name: json['name'] as String?,
      url: json['url'] as String?,
    );
  }
}

class Species {
  String? name;
  String? url;

  Species({this.name, this.url});

  factory Species.fromJson(Map<String, dynamic> json) {
    return Species(
      name: json['name'] as String?,
      url: json['url'] as String?,
    );
  }
}

class Sprites {
  String? frontDefault;
  String? frontShiny;
  String? backDefault;
  String? backShiny;

  Sprites({
    this.frontDefault,
    this.frontShiny,
    this.backDefault,
    this.backShiny,
  });

  factory Sprites.fromJson(Map<String, dynamic> json) {
    return Sprites(
      frontDefault: json['front_default'] as String?,
      frontShiny: json['front_shiny'] as String?,
      backDefault: json['back_default'] as String?,
      backShiny: json['back_shiny'] as String?,
    );
  }
}

class Stat {
  StatDetail? stat;
  int? baseStat;
  int? effort;

  Stat({this.stat, this.baseStat, this.effort});

  factory Stat.fromJson(Map<String, dynamic> json) {
    return Stat(
      stat: json['stat'] != null
          ? StatDetail.fromJson(json['stat'] as Map<String, dynamic>)
          : null,
      baseStat: json['base_stat'] as int?,
      effort: json['effort'] as int?,
    );
  }
}

class StatDetail {
  String? name;
  String? url;

  StatDetail({this.name, this.url});

  factory StatDetail.fromJson(Map<String, dynamic> json) {
    return StatDetail(
      name: json['name'] as String?,
      url: json['url'] as String?,
    );
  }
}

class Type {
  TypeDetail? type;

  Type({this.type});

  factory Type.fromJson(Map<String, dynamic> json) {
    return Type(
      type: json['type'] != null
          ? TypeDetail.fromJson(json['type'] as Map<String, dynamic>)
          : null,
    );
  }
}

class TypeDetail {
  String? name;
  String? url;

  TypeDetail({this.name, this.url});

  factory TypeDetail.fromJson(Map<String, dynamic> json) {
    return TypeDetail(
      name: json['name'] as String?,
      url: json['url'] as String?,
    );
  }
}
