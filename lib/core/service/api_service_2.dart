// import 'dart:convert';

// import 'package:dartz/dartz.dart';
// import 'package:pokemon/core/connection/connectivity_checker.dart';
// import 'package:pokemon/core/model/poke_mon_list_model/poke_mon_list_model.dart';
// import 'package:http/http.dart' as http;
// import 'package:pokemon/core/model/pokemon_detailed_model/pokemon_detailed_model.dart';
// import 'package:pokemon/core/model/pokemon_type_model/pokemon_type_model.dart';

// class ApiServcieEEEE2 {
//   static const String baseUrl = "https://pokeapi.co/api/v2";
//   static Future<Either<String, PokeMonListFullModel>> getPokemonListByType(
//       {required int typeId}) async {
//     try {
//       // Check for internet connection
//       final hasInternet = await ConnectivityChecker().hasInternetAccess();
//       if (!hasInternet) {
//         print('No Internet');
//         return const Left("No Internet");
//       }

//       // Fetch the list of Pokémon by type
//       final typeUrl = Uri.parse('$baseUrl/type/$typeId');
//       final response = await http.get(typeUrl);

//       if (response.statusCode != 200) {
//         print('Failed to fetch Pokémon by type');
//         return Left('Failed to fetch Pokémon by type');
//       }

//       var jsonMap = json.decode(response.body);

//       // Get the array of Pokémon from the response
//       List<dynamic> pokemonArray = jsonMap['pokemon'];

//       // Initialize a list to store Pokémon types and details
//       List<List<String>> speciesTypesList = [];
//       List<Future<http.Response>> requests = [];

//       // Collect URLs for each Pokémon and send concurrent requests
//       for (var pokemonEntry in pokemonArray) {
//         var speciesUrl = Uri.parse(pokemonEntry['pokemon']['url']);
//         requests.add(http.get(speciesUrl));
//       }

//       // Wait for all requests to complete
//       List<http.Response> responses = await Future.wait(requests);

//       // Process each response after all requests are completed
//       for (var speciesResponse in responses) {
//         if (speciesResponse.statusCode != 200) {
//           print('Failed to fetch Pokémon details');
//           return const Left('Failed to fetch Pokémon species details');
//         }

//         var jsonMap2 = json.decode(speciesResponse.body);
//         var pokemonDetails2 = PokemonDetailedModel.fromJson(jsonMap2);

//         // Extract Pokémon type names
//         List<String?> typeNames =
//             pokemonDetails2.types!.map((type) => type.type?.name).toList();

//         // Add the type names to the list
//         speciesTypesList.add(typeNames
//             .whereType<String>()
//             .toList()); // Ensure we add only non-null types
//       }

//       // Assuming you also need the Pokémon list model, build it from responses
//       var pokemonList = PokeMonListModel.fromTypeArray(pokemonArray);

//       // Return both the list of Pokémon and their type details
//       return Right(PokeMonListFullModel(
//         pokeMonListModel: pokemonList,
//         speciesTypes: speciesTypesList,
//       ));
//     } catch (e) {
//       print('Error: ${e.toString()}');
//       return const Left("Something Went Wrong");
//     }
//   }
// }
