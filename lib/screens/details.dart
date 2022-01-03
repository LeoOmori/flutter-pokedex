import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/models/captured_pokemon.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/models/pokemon_id.dart';
import 'package:pokedex/models/pokemon_type.dart';
import 'package:pokedex/providers/pokemon.dart';
import 'package:pokedex/widgets/custom_tabbar.dart';
import 'package:pokedex/widgets/stats_bar.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({required this.pokemon, Key? key}) : super(key: key);

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Altura: ${pokemon.height / 10}m'),
          const SizedBox(
            height: 8,
          ),
          Text('Peso: ${pokemon.weight / 10}kg'),
        ],
      ),
    );
  }
}

class StatsPokemon extends StatelessWidget {
  const StatsPokemon({
    required this.pokemon,
    Key? key,
  }) : super(key: key);

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          ItemList(label: 'HP', value: pokemon.stats.hp),
          const SizedBox(height: 10),
          ItemList(label: 'Attack', value: pokemon.stats.attack),
          const SizedBox(height: 10),
          ItemList(label: 'Defense', value: pokemon.stats.defense),
          const SizedBox(height: 10),
          ItemList(label: 'SP Atack', value: pokemon.stats.specialAttack),
          const SizedBox(height: 10),
          ItemList(label: 'SP Defense', value: pokemon.stats.specialDefense),
          const SizedBox(height: 10),
          ItemList(label: 'Speed', value: pokemon.stats.speed),
        ],
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  const ItemList({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label),
        Expanded(
          flex: 4,
          child: StatsBar(
            value: value,
            maxValue: 255,
            size: 10,
          ),
        )
      ],
    );
  }
}

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  static const routeName = '/details';

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PokemonProvider>(context);
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    final capturedPokemon = args.capturedPokemonId != null
        ? provider.getCapturedPokemonById(args.capturedPokemonId!)
        : null;
    final pokemon = provider.getPokemonById(args.id!);

    Widget _getPanel(index) {
      switch (index) {
        case 0:
          return AboutScreen(pokemon: pokemon!);
        case 1:
          return StatsPokemon(pokemon: pokemon!);
        default:
          return Container();
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Detalhe'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            AnimatedContainer(
              height: 200,
              duration: const Duration(milliseconds: 2),
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(30)),
                color: pokemon!.types.first.color,
              ),
              child: Stack(
                children: [
                  SizedBox(
                    child: Center(
                      child: SizedBox.square(
                        dimension: 150,
                        child: Image.asset(
                          'assets/pokeball.png',
                          color: Colors.white.withAlpha(70),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText(
                              pokemon.name,
                            ),
                            AutoSizeText(
                              '#${args.id}',
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Hero(
                              tag: capturedPokemon?.id ?? args.id!,
                              child: CachedNetworkImage(
                                imageUrl: pokemon.sprites[0],
                                height: 120,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 230,
              padding: const EdgeInsets.all(20),
              child: CustomTabBar(
                labels: const [Text('sobre'), Text('Status')],
                getContent: _getPanel,
              ),
            ),
            if (capturedPokemon == null)
              SizedBox(
                width: 200,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    provider.capturePokemon(CapturedPokemon(
                      id: DateTime.now().millisecondsSinceEpoch,
                      pokemonId: pokemon.id,
                      xp: pokemon.baseXp,
                      hp: pokemon.stats.hp,
                    ));
                    Navigator.popUntil(
                      context,
                      ModalRoute.withName(HomeScreen.routeName),
                    );
                  },
                  child: const Text('Capturar'),
                ),
              ),
            if (capturedPokemon != null && pokemon.evolvesTo != null)
              SizedBox(
                width: 200,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    provider.evolvePokemon(capturedPokemon);
                    Navigator.popUntil(
                      context,
                      ModalRoute.withName(HomeScreen.routeName),
                    );
                  },
                  child: const Text('Evoluir'),
                ),
              ),
          ],
        ));
  }
}
