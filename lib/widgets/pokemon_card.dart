import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/models/captured_pokemon.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/models/pokemon_id.dart';
import 'package:pokedex/models/pokemon_type.dart';
import 'package:pokedex/screens/details.dart';
import 'package:pokedex/widgets/custom_chip.dart';
import 'package:pokedex/widgets/stats_bar.dart';

class PokemonCard extends StatelessWidget {
  const PokemonCard({Key? key, required this.pokemon, this.capturedPokemon})
      : super(key: key);

  final Pokemon pokemon;
  final CapturedPokemon? capturedPokemon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          DetailsScreen.routeName,
          arguments: ScreenArguments(
            id: pokemon.id,
            capturedPokemonId: capturedPokemon?.id,
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: pokemon.types.first.color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(children: [
          Positioned(
            bottom: -25,
            right: -25,
            child: SizedBox.square(
              dimension: 100,
              child: Image.asset(
                'assets/pokeball.png',
                color: Colors.white.withAlpha(70),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        '${pokemon.name}\n#${pokemon.id.toString()}',
                        maxLines: 2,
                        style: const TextStyle(height: 1.2),
                        minFontSize: 10,
                        maxFontSize: 20,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: pokemon.types
                            .map((t) => CustomChip(type: t))
                            .toList(),
                      ),
                      if (capturedPokemon != null) ...[
                        const SizedBox(height: 4),
                        StatsBar(
                          label: 'HP',
                          value: capturedPokemon!.hp,
                          maxValue: pokemon.stats.hp,
                        ),
                        const SizedBox(height: 4),
                        StatsBar(
                            label: 'XP',
                            value: capturedPokemon!.xp,
                            maxValue: pokemon.baseXp)
                      ]
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Hero(
                  tag: capturedPokemon?.id ?? pokemon.id,
                  child: CachedNetworkImage(
                    imageUrl: pokemon.sprites[0],
                  ),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
