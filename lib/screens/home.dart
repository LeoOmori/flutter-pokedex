import 'package:flutter/material.dart';
// import 'package:pokedex/models/captured_pokemon.dart';
import 'package:pokedex/providers/pokemon.dart';
import 'package:pokedex/widgets/pokemon_card.dart';
import 'package:pokedex/screens/wild_search.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _search = '';
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PokemonProvider>(context);
    // if (provider.capturedPokemons.isEmpty) return const SizedBox.shrink();
    final list = provider.capturedPokemons
        .where((e) =>
            provider
                .getPokemonById(e.pokemonId)
                ?.name
                .toLowerCase()
                .contains(_search.toLowerCase()) ??
            false)
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pokemons'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.pushNamed(context, WildSearchScreen.routeName);
        },
        label: const Text(
          'Pokemons\nselvagens',
          style: TextStyle(color: Colors.grey, fontSize: 8),
          textAlign: TextAlign.center,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: Colors.cyan,
            width: 3,
          ),
        ),
        icon: const Icon(
          Icons.search,
          color: Colors.cyan,
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: SizedBox.square(
              dimension: 200,
              child: Image.asset(
                'assets/pokeball.png',
                color: Colors.black.withAlpha(70),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                TextField(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      ?.copyWith(fontSize: 10),
                  decoration: const InputDecoration(
                    hintText: 'Pesquisar meus pokemons',
                  ),
                  onChanged: (v) {
                    setState(() {
                      _search = v;
                    });
                  },
                ),
                Expanded(
                    child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: PokemonCard(
                        pokemon:
                            provider.getPokemonById(list[index].pokemonId)!,
                        capturedPokemon: list[index],
                      ),
                    );
                  },
                  itemCount: list.length,
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
