import 'package:flutter/material.dart';
import 'package:tcg_app_sp/models/collection.dart';

class DeckConstructionMenuScreen extends StatefulWidget {
  final Collection collect;

  const DeckConstructionMenuScreen(this.collect, {super.key});

  @override
  DeckConstructionMenuScreenState createState() => DeckConstructionMenuScreenState();
}

class DeckConstructionMenuScreenState extends State<DeckConstructionMenuScreen> {
  List<Map<String, dynamic>> collection = [];

  @override
  void initState() {
    super.initState();
    collection = widget.collect.allCards;
    print(collection);
  }

  List<Map<String, dynamic>> selectedCards = [];

  void addCard(String cardId, String cardType, String cardName, String imgUrl, int quantity) {
    setState(() {
      Map<String, dynamic> newEntry = {
        'id': cardId,
        'name': cardName,
        'type': cardType,
        'imgURL': imgUrl,
        'quantity': quantity,
      };
      selectedCards.add(newEntry);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF404040),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Create Your Deck',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildCardDropdown('Collection', collection),
          _buildSelectedCardsList(),
        ],
      ),
    );
  }

  Widget _buildCardDropdown(String header, List<Map<String, dynamic>> cards) {
    return Column(
      children: [
        Text(header),
        DropdownButton<Map<String, dynamic>>(
          items: cards
              .map((card) => DropdownMenuItem<Map<String, dynamic>>(
                    value: card,
                    child: Text(card['name']),
                  ))
              .toList(),
          onChanged: (selectedCard) {
            _showQuantityDialog(selectedCard!);
          },
        ),
      ],
    );
  }

  void _showQuantityDialog(Map<String, dynamic> selectedCard) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Select Quantity'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            4,
            (index) => ListTile(
              title: Text('${index + 1}'),
              onTap: () {
                addCard(selectedCard['id'], selectedCard['type'], selectedCard['name'], selectedCard['imgURL'], index + 1);
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      );
    },
  );
}

  Widget _buildSelectedCardsList() {
  List<Map<String, dynamic>> pokemonCards = selectedCards.where((card) => card['type'] == 'Pokémon').toList();
  List<Map<String, dynamic>> trainerCards = selectedCards.where((card) => card['type'] == 'Trainer').toList();
  List<Map<String, dynamic>> energyCards = selectedCards.where((card) => card['type'] == 'Energy').toList();

  num totalPokemonQuantity = pokemonCards.fold(0, (total, card) => total + card['quantity']);
  num totalTrainerQuantity = trainerCards.fold(0, (total, card) => total + card['quantity']);
  num totalEnergyQuantity = energyCards.fold(0, (total, card) => total + card['quantity']);
  num totalOverallQuantity = totalPokemonQuantity + totalTrainerQuantity + totalEnergyQuantity;

  return Column(
    children: [
      if (pokemonCards.isNotEmpty)
        Column(
          children: [
            Text('Pokémon'),
            ...pokemonCards.map((card) => ListTile(
              leading: Image.network(card['imgURL']),
              title: Text(card['name']),
              trailing: Text('Quantity: ${card['quantity']}'),
            )).toList(),
          ],
        ),
      if (trainerCards.isNotEmpty)
        Column(
          children: [
            Text('Trainer'),
            ...trainerCards.map((card) => ListTile(
              leading: Image.network(card['imgURL']),
              title: Text(card['name']),
              trailing: Text('Quantity: ${card['quantity']}'),
            )).toList(),
          ],
        ),
      if (energyCards.isNotEmpty)
        Column(
          children: [
            Text('Energy'),
            ...energyCards.map((card) => ListTile(
              leading: Image.network(card['imgURL']),
              title: Text(card['name']),
              trailing: Text('Quantity: ${card['quantity']}'),
            )).toList(),
          ],
        ),
      Text('$totalOverallQuantity/60 Cards'),
    ],
  );
}
}