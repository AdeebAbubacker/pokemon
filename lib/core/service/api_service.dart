import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:pokemon/core/connection/connectivity_checker.dart';
import 'package:pokemon/core/model/poke_mon_list_model/poke_mon_list_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://pokeapi.co/api/v2";
  static Future<Either<String, PokeMonListModel>> getPokemonList({required int offset}) async {
    try {
      final hasInternet = await ConnectivityChecker().hasInternetAccess();
      if (!hasInternet) {
        return const Left("No Internet");
      }
      final url =
          Uri.parse('https://pokeapi.co/api/v2/pokemon?offset=${offset}&limit=20');

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
}
