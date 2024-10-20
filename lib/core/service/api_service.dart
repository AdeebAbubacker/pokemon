import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:pokemon/core/connection/connectivity_checker.dart';
import 'package:pokemon/core/model/poke_mon_list_model/poke_mon_list_model.dart';
import 'package:http/http.dart' as http;
import 'package:pokemon/core/model/pokemon_detailed_model/pokemon_detailed_model.dart';
import 'package:pokemon/core/model/pokemon_type_model/pokemon_type_model.dart';

class ApiService {
  static const String baseUrl = "https://pokeapi.co/api/v2";

  static Future<Either<String, PokeMonListFullModel>> getPokemonList(
      {required int offset}) async {
    try {
      final hasInternet = await ConnectivityChecker().hasInternetAccess();
      if (!hasInternet) {
        print('No Internet');
        return const Left("No Internet");
      }

      // Fetch Pokémon list based on the offset
      final url = Uri.parse('$baseUrl/pokemon?offset=$offset&limit=130');
      final response = await http.get(url);

      if (response.statusCode != 200) {
        print('Failed to fetch Pokémon list');
        return Left('Failed to fetch Pokémon list');
      }

      var jsonMap = json.decode(response.body);
      var pokemonList = PokeMonListModel.fromJson(jsonMap);

      // Initialize a list to store Pokémon types
      List<List<String>> speciesTypesList = []; // Changed to a list of lists

      // Create a list of all species URLs
      int startId = offset + 1;
      int endId = offset + 130;
      List<Future<http.Response>> requests = [];

      // Send concurrent requests to fetch each Pokémon species details
      for (int id = startId; id <= endId; id++) {
        final speciesUrl = Uri.parse('$baseUrl/pokemon/$id');
        requests.add(http.get(speciesUrl)); // Collect all requests
      }

      // Wait for all requests to complete concurrently
      List<http.Response> responses = await Future.wait(requests);

      // Process each response after all requests are completed
      for (var speciesResponse in responses) {
        if (speciesResponse.statusCode != 200) {
          print('Failed to fetch Pokémon details');
          return const Left('Failed to fetch Pokémon species details');
        }

        var jsonMap2 = json.decode(speciesResponse.body);
        var pokemonDetails2 = PokemonDetailedModel.fromJson(jsonMap2);

        // Extract Pokémon type names
        List<String?> typeNames =
            pokemonDetails2.types!.map((type) => type.type?.name).toList();

        // Add the type names to the list
        speciesTypesList.add(typeNames
            .whereType<String>()
            .toList()); // Ensure we add only non-null types
      }

      // Return both the list of Pokémon and the type details list
      return Right(PokeMonListFullModel(
        pokeMonListModel: pokemonList,
        speciesTypes: speciesTypesList, // Changed to store types as lists
      ));
    } catch (e) {
      print('Error: ${e.toString()}');
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

  static Future<Either<String, PokeMonListFullModel>> getPokemonListByType(
      {required int typeId}) async {
    try {
      // Check for internet connection
      final hasInternet = await ConnectivityChecker().hasInternetAccess();
      if (!hasInternet) {
        print('No Internet');
        return const Left("No Internet");
      }

      // Fetch the list of Pokémon by type
      final typeUrl = Uri.parse('$baseUrl/type/$typeId');
      final response = await http.get(typeUrl);

      if (response.statusCode != 200) {
        print('Failed to fetch Pokémon by type');
        return Left('Failed to fetch Pokémon by type');
      }

      var jsonMap = json.decode(response.body);

      // Get the array of Pokémon from the response
      List<dynamic> pokemonArray = jsonMap['pokemon'];

      // Initialize a list to store Pokémon types and details
      List<List<String>> speciesTypesList = [];
      List<Future<http.Response>> requests = [];

      // Collect URLs for each Pokémon and send concurrent requests
      for (var pokemonEntry in pokemonArray) {
        var speciesUrl = Uri.parse(pokemonEntry['pokemon']['url']);
        requests.add(http.get(speciesUrl));
      }

      // Wait for all requests to complete
      List<http.Response> responses = await Future.wait(requests);

      // Process each response after all requests are completed
      for (var speciesResponse in responses) {
        if (speciesResponse.statusCode != 200) {
          print('Failed to fetch Pokémon details');
          return const Left('Failed to fetch Pokémon species details');
        }

        var jsonMap2 = json.decode(speciesResponse.body);
        var pokemonDetails2 = PokemonDetailedModel.fromJson(jsonMap2);

        // Extract Pokémon type names
        List<String?> typeNames =
            pokemonDetails2.types!.map((type) => type.type?.name).toList();

        // Add the type names to the list
        speciesTypesList.add(typeNames
            .whereType<String>()
            .toList()); // Ensure we add only non-null types
      }

      // Assuming you also need the Pokémon list model, build it from responses
      var pokemonList = PokeMonListModel.fromTypeArray(pokemonArray);

      // Return both the list of Pokémon and their type details
      return Right(PokeMonListFullModel(
        pokeMonListModel: pokemonList,
        speciesTypes: speciesTypesList,
      ));
    } catch (e) {
      print('Error: ${e.toString()}');
      return const Left("Something Went Wrong");
    }
  }
}
