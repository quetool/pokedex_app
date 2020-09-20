import 'package:pokedex_app/api/api_client.dart';

class PokemonBase {
  PokemonBase({
    this.name,
    this.url,
  });

  PokemonBase.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String;
    url = json['url'] as String;
  }
  String name;
  String url;
  Pokemon pokemon;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    return data;
  }

  void getPokemonData(Function(Pokemon pokemon) completion) {
    ApiClient().getPokemonDetails(name).then(
          (response) =>
              ApiClient().responseHandlerPokemon(response, (error, pokemon) {
            pokemon = pokemon;
            completion(pokemon);
          }),
        );
  }
}

class Pokemon {
  String name;
  String url;
  List<Abilities> abilities;
  int baseExperience;
  List<PokeForms> forms;
  int height;
  int id;
  bool isDefault;
  String locationAreaEncounters;
  int order;
  Ability species;
  Sprites sprites;
  List<Stats> stats;
  List<Types> types;
  List<Moves> moves;
  int weight;

  Pokemon({
    this.name,
    this.url,
    this.abilities,
    this.baseExperience,
    this.forms,
    this.height,
    this.id,
    this.isDefault,
    this.locationAreaEncounters,
    this.order,
    this.species,
    this.sprites,
    this.stats,
    this.types,
    this.weight,
  });

  Pokemon.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String;
    url = json['url'] as String;
    if (json['abilities'] != null) {
      abilities = <Abilities>[];
      json['abilities'].forEach((dynamic v) {
        abilities.add(Abilities.fromJson(v as Map<String, dynamic>));
      });
    }
    baseExperience = json['base_experience'] as int;
    if (json['forms'] != null) {
      forms = <PokeForms>[];
      json['forms'].forEach((dynamic v) {
        forms.add(PokeForms.fromJson(v as Map<String, dynamic>));
      });
    }
    height = json['height'] as int;
    id = json['id'] as int;
    isDefault = json['is_default'] as bool;
    locationAreaEncounters = json['location_area_encounters'] as String;
    order = json['order'] as int;
    species = json['species'] != null
        ? Ability.fromJson(json['species'] as Map<String, dynamic>)
        : null;
    sprites = json['sprites'] != null
        ? Sprites.fromJson(json['sprites'] as Map<String, dynamic>)
        : null;
    if (json['stats'] != null) {
      stats = <Stats>[];
      json['stats'].forEach((dynamic v) {
        stats.add(Stats.fromJson(v as Map<String, dynamic>));
      });
    }
    if (json['types'] != null) {
      types = <Types>[];
      json['types'].forEach((dynamic v) {
        types.add(Types.fromJson(v as Map<String, dynamic>));
      });
    }
    if (json['moves'] != null) {
      moves = <Moves>[];
      json['moves'].forEach((dynamic v) {
        moves.add(Moves.fromJson(v as Map<String, dynamic>));
      });
    }
    weight = json['weight'] as int;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    if (abilities != null) {
      data['abilities'] = abilities.map((v) => v.toJson()).toList();
    }
    data['base_experience'] = baseExperience;
    if (forms != null) {
      data['forms'] = forms.map((v) => v.toJson()).toList();
    }
    data['height'] = height;
    data['id'] = id;
    data['is_default'] = isDefault;
    data['location_area_encounters'] = locationAreaEncounters;
    data['order'] = order;
    if (species != null) {
      data['species'] = species.toJson();
    }
    if (sprites != null) {
      data['sprites'] = sprites.toJson();
    }
    if (stats != null) {
      data['stats'] = stats.map((v) => v.toJson()).toList();
    }
    if (types != null) {
      data['types'] = types.map((v) => v.toJson()).toList();
    }
    if (moves != null) {
      data['moves'] = moves.map((v) => v.toJson()).toList();
    }
    data['weight'] = weight;
    return data;
  }
}

class PokeForms {
  String name;
  String url;

  PokeForms({
    this.name,
    this.url,
  });

  PokeForms.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String;
    url = json['url'] as String;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    return data;
  }
}

class Abilities {
  Ability ability;
  bool isHidden;
  int slot;

  Abilities({
    this.ability,
    this.isHidden,
    this.slot,
  });

  Abilities.fromJson(Map<String, dynamic> json) {
    ability = json['ability'] != null
        ? Ability.fromJson(json['ability'] as Map<String, dynamic>)
        : null;
    isHidden = json['is_hidden'] as bool;
    slot = json['slot'] as int;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (ability != null) {
      data['ability'] = ability.toJson();
    }
    data['is_hidden'] = isHidden;
    data['slot'] = slot;
    return data;
  }
}

class Ability {
  String name;
  String url;

  Ability({
    this.name,
    this.url,
  });

  Ability.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String;
    url = json['url'] as String;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    return data;
  }
}

class Sprites {
  String backDefault;
  String backFemale;
  String backShiny;
  String backShinyFemale;
  String frontDefault;
  String frontFemale;
  String frontShiny;
  String frontShinyFemale;
  Other other;

  Sprites({
    this.backDefault,
    this.backFemale,
    this.backShiny,
    this.backShinyFemale,
    this.frontDefault,
    this.frontFemale,
    this.frontShiny,
    this.frontShinyFemale,
    this.other,
  });

  Sprites.fromJson(Map<String, dynamic> json) {
    backDefault = json['back_default'] as String;
    backFemale = json['back_female'] as String;
    backShiny = json['back_shiny'] as String;
    backShinyFemale = json['back_shiny_female'] as String;
    frontDefault = json['front_default'] as String;
    frontFemale = json['front_female'] as String;
    frontShiny = json['front_shiny'] as String;
    frontShinyFemale = json['front_shiny_female'] as String;
    other = json['other'] != null
        ? Other.fromJson(json['other'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['back_default'] = backDefault;
    data['back_female'] = backFemale;
    data['back_shiny'] = backShiny;
    data['back_shiny_female'] = backShinyFemale;
    data['front_default'] = frontDefault;
    data['front_female'] = frontFemale;
    data['front_shiny'] = frontShiny;
    data['front_shiny_female'] = frontShinyFemale;
    if (other != null) {
      data['other'] = other.toJson();
    }
    return data;
  }
}

class Other {
  OfficialArtwork officialArtwork;

  Other({
    this.officialArtwork,
  });

  Other.fromJson(Map<String, dynamic> json) {
    officialArtwork = json['official-artwork'] != null
        ? OfficialArtwork.fromJson(
            json['official-artwork'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (officialArtwork != null) {
      data['official-artwork'] = officialArtwork.toJson();
    }
    return data;
  }
}

class OfficialArtwork {
  String frontDefault;

  OfficialArtwork({
    this.frontDefault,
  });

  OfficialArtwork.fromJson(Map<String, dynamic> json) {
    frontDefault = json['front_default'] as String;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['front_default'] = frontDefault;
    return data;
  }
}

class Stats {
  int baseStat;
  int effort;
  Ability stat;

  Stats({
    this.baseStat,
    this.effort,
    this.stat,
  });

  Stats.fromJson(Map<String, dynamic> json) {
    baseStat = json['base_stat'] as int;
    effort = json['effort'] as int;
    stat = json['stat'] != null
        ? Ability.fromJson(json['stat'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['base_stat'] = baseStat;
    data['effort'] = effort;
    if (stat != null) {
      data['stat'] = stat.toJson();
    }
    return data;
  }
}

class Types {
  int slot;
  Ability type;

  Types({
    this.slot,
    this.type,
  });

  Types.fromJson(Map<String, dynamic> json) {
    slot = json['slot'] as int;
    type = json['type'] != null
        ? Ability.fromJson(json['type'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['slot'] = slot;
    if (type != null) {
      data['type'] = type.toJson();
    }
    return data;
  }
}

class Moves {
  Move move;
  List<VersionGroupDetails> versionGroupDetails;

  Moves({
    this.move,
    this.versionGroupDetails,
  });

  Moves.fromJson(Map<String, dynamic> json) {
    move = json['move'] != null
        ? Move.fromJson(json['move'] as Map<String, dynamic>)
        : null;
    if (json['version_group_details'] != null) {
      versionGroupDetails = <VersionGroupDetails>[];
      json['version_group_details'].forEach((dynamic v) {
        versionGroupDetails
            .add(VersionGroupDetails.fromJson(v as Map<String, dynamic>));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (move != null) {
      data['move'] = move.toJson();
    }
    if (versionGroupDetails != null) {
      data['version_group_details'] =
          versionGroupDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Move {
  String name;
  String url;

  Move({
    this.name,
    this.url,
  });

  Move.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String;
    url = json['url'] as String;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    return data;
  }
}

class VersionGroupDetails {
  int levelLearnedAt;
  Move moveLearnMethod;
  Move versionGroup;

  VersionGroupDetails({
    this.levelLearnedAt,
    this.moveLearnMethod,
    this.versionGroup,
  });

  VersionGroupDetails.fromJson(Map<String, dynamic> json) {
    levelLearnedAt = json['level_learned_at'] as int;
    moveLearnMethod = json['move_learn_method'] != null
        ? Move.fromJson(json['move_learn_method'] as Map<String, dynamic>)
        : null;
    versionGroup = json['version_group'] != null
        ? Move.fromJson(json['version_group'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['level_learned_at'] = levelLearnedAt;
    if (moveLearnMethod != null) {
      data['move_learn_method'] = moveLearnMethod.toJson();
    }
    if (versionGroup != null) {
      data['version_group'] = versionGroup.toJson();
    }
    return data;
  }
}
