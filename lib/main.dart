import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/Ui/Screens/home_screen.dart';
import 'package:pokemon/Ui/Screens/login_screen.dart';
import 'package:pokemon/core/view_model/fetch_all_pokemons/fetch_all_pokemons_bloc.dart';
import 'package:pokemon/core/view_model/get_pokemon_details/get_pokemon_details_bloc.dart';
import 'package:pokemon/core/view_model/get_pokemon_list/get_pokemon_list_bloc.dart';
import 'package:pokemon/firebase_options.dart';
import 'package:pokemon/test/api_testing.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetPokemonListBloc(),
        ),
        BlocProvider(
          create: (context) => FetchAllPokemonsBloc(),
        ),
        BlocProvider(
          create: (context) => GetPokemonDetailsBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const ApiTesting(),
      ),
    );
  }
}
