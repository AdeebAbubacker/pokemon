import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:pokemon/core/connection/connectivity_checker.dart';
import 'package:pokemon/core/model/poke_mon_list_model/poke_mon_list_model.dart';
import 'package:http/http.dart' as http;
import 'package:pokemon/core/model/pokemon_detailed_model/pokemon_detailed_model.dart';

class ApiService {
  static const String baseUrl = "https://pokeapi.co/api/v2";
  static Future<Either<String, PokeMonListModel>> getPokemonList(
      {required int offset}) async {
    try {
      final hasInternet = await ConnectivityChecker().hasInternetAccess();
      if (!hasInternet) {
        return const Left("No Internet");
      }
      final url = Uri.parse(
          'https://pokeapi.co/api/v2/pokemon?offset=${offset}&limit=20');

      final response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonMap = json.decode(response.body);
        var getProducts = PokeMonListModel.fromJson(jsonMap);
        print(getProducts);
        return right(getProducts); // Return the list of products
      } else if (response.statusCode == 500) {
        var jsonMap = json.decode(response.body);
        print('500');
        print('failure ${jsonMap}');
        return left('l');
      } else {
        print('eror');
        return left('l');
      }
    } catch (e) {
      print('eror ${e.toString()}');
      return const Left("Something Went Wrong");
    }
  }

  static Future<Either<String, PokeMonListModel>> fetchAllPokemons() async {
    try {
      final hasInternet = await ConnectivityChecker().hasInternetAccess();
      if (!hasInternet) {
        return const Left("No Internet");
      }
      final url = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=1000');

      final response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonMap = json.decode(response.body);
        var getProducts = PokeMonListModel.fromJson(jsonMap);
        print(getProducts.count);
        return right(getProducts); // Return the list of products
      } else if (response.statusCode == 500) {
        var jsonMap = json.decode(response.body);
        print('500');
        print('failure ${jsonMap}');
        return left('l');
      } else {
        print('eror');
        return left('l');
      }
    } catch (e) {
      print('eror ${e.toString()}');
      return const Left("Something Went Wrong");
    }
  }

  // static Future<Either<String, PokemonDetailedModel>> getPokemonDeatils(
  //     {required String pokemonId}) async {
  //   try {
  //     final hasInternet = await ConnectivityChecker().hasInternetAccess();
  //     if (!hasInternet) {
  //       return const Left("No Internet");
  //     }
  //     final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/${pokemonId}');

  //     final response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       var jsonMap = json.decode(response.body);
  //       var getProducts = PokemonDetailedModel.fromJson(jsonMap);
  //       print(getProducts);
  //       return right(getProducts); // Return the list of products
  //     } else if (response.statusCode == 500) {
  //       var jsonMap = json.decode(response.body);
  //       print('500');
  //       print('failure ${jsonMap}');
  //       return left('l');
  //     } else {
  //       print('eror');
  //       return left('l');
  //     }
  //   } catch (e) {
  //     print('eror ${e.toString()}');
  //     return const Left("Something Went Wrong");
  //   }
  // }

  static Future<Either<String, PokemonFullDetailModel>> getPokemonDetails({
    required String pokemonId,
  }) async {
    try {
      final hasInternet = await ConnectivityChecker().hasInternetAccess();
      if (!hasInternet) {
        return const Left("No Internet");
      }

      // Fetch Pokémon details
      final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$pokemonId');
      final response = await http.get(url);

      if (response.statusCode != 200) {
        return Left('Failed to fetch Pokémon details');
      }

      var jsonMap = json.decode(response.body);
      var pokemonDetails = PokemonDetailedModel.fromJson(jsonMap);

      // Fetch Pokémon species details
      final speciesUrl =
          Uri.parse('https://pokeapi.co/api/v2/pokemon-species/$pokemonId');
      final speciesResponse = await http.get(speciesUrl);

      if (speciesResponse.statusCode != 200) {
        return Left('Failed to fetch Pokémon species details');
      }

      var speciesData = json.decode(speciesResponse.body);
      String speciesName = speciesData['name'];
      String flavorText = speciesData['flavor_text_entries'][0]['flavor_text'];

      // Get different sprite URLs
      String frontImage = jsonMap['sprites']['front_default'];
      String backImage = jsonMap['sprites']['back_default'];
      String shinyImage = jsonMap['sprites']['front_shiny'];

      // Combine details into one model
      return Right(PokemonFullDetailModel(
        pokemonDetails: pokemonDetails,
        speciesName: speciesName,
        flavorText: flavorText,
        frontImage: frontImage,
        backImage: backImage,
        shinyImage: shinyImage,
      ));
    } catch (e) {
      return const Left("Something Went Wrong");
    }
  }
}
