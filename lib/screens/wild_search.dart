import 'package:flutter/material.dart';
import 'package:pokedex/providers/pokemon.dart';
import 'package:pokedex/widgets/pokemon_card.dart';
import 'package:provider/provider.dart';

class WildSearchScreen extends StatefulWidget {
  const WildSearchScreen({Key? key}) : super(key: key);
  static const routeName = '/wildSearchScreen';

  @override
  _WildSearchScreenState createState() => _WildSearchScreenState();
}

String _search = '';

class _WildSearchScreenState extends State<WildSearchScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PokemonProvider>(context);
    final list = provider.pokemons
        .where((e) => e.name.toLowerCase().contains(_search.toLowerCase()))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokedex'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            TextField(
              style:
                  Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 10),
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
              child: Container(
                padding: const EdgeInsets.all(10),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    mainAxisExtent: 90,
                  ),
                  itemBuilder: (context, index) {
                    return PokemonCard(pokemon: list[index]);
                  },
                  itemCount: list.length,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
