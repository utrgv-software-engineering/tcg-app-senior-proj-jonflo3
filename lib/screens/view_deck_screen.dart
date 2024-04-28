import 'package:tcg_app_sp/models/collection.dart';
import 'package:flutter/material.dart';

class ViewDeckScreen extends StatefulWidget {
  final int index;
  final Collection collect;

  const ViewDeckScreen(this.index, this.collect, {super.key});

  @override
  _ViewDeckScreenState createState() => _ViewDeckScreenState();
}

class _ViewDeckScreenState extends State<ViewDeckScreen> {

  @override
  void initState() {
    super.initState();
    print(widget.collect.myDecks.allDecks);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF404040),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'View Deck',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            _buildCardList('Pokémon', 'Pokémon', widget.collect.myDecks.allDecks[widget.index]),
            _buildCardList('Trainer', 'Trainer', widget.collect.myDecks.allDecks[widget.index]),
            _buildCardList('Energy', 'Energy', widget.collect.myDecks.allDecks[widget.index]),
          ],
        ),
      ),
    );
  }

  Widget _buildCardList(String header, String cardType, List<Map<String, dynamic>> selectedDeck) {
    List<Map<String, dynamic>> cardsOfType = selectedDeck.where((card) => card['type'] == cardType).toList();

    return Column(
      children: [
        if (cardsOfType.isNotEmpty)
          Column(
            children: [
              Text(header),
              ...cardsOfType.map((card) => _buildCardTile(card)).toList(),
            ],
          ),
      ],
    );
  }

  Widget _buildCardTile(Map<String, dynamic> card) {
    return ListTile(
      leading: Image.network(card['imgURL']),
      title: Text(card['name']),
      subtitle: Text('Quantity: ${card['quantity']}'),
    );
  }
}