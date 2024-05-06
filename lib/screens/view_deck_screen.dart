import 'package:tcg_app_sp/models/collection.dart';
import 'package:flutter/material.dart';
import 'package:tcg_app_sp/SQLite/sqlite.dart';
import 'package:tcg_app_sp/screens/deck_menu_screen.dart';

class ViewDeckScreen extends StatefulWidget {
  final String deckName;
  final Collection collect;

  const ViewDeckScreen(this.deckName, this.collect, {super.key});

  @override
  _ViewDeckScreenState createState() => _ViewDeckScreenState();
}

class _ViewDeckScreenState extends State<ViewDeckScreen> {
  List<Map<String, dynamic>> deckCards = [];

  @override
  void initState() {
    super.initState();
    fetchDeckCards();
  }

  Future<void> fetchDeckCards() async {
    final db = DataBaseHelper();
    String user = widget.collect.username;

    List<Map<String, dynamic>> deckCardsFromDB = await db.searchDeck(user, widget.deckName);

    setState(() {
      deckCards = deckCardsFromDB;
    });
  }

  void showRemoveCardDialogue(BuildContext context, String deck) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Do you want to delete $deck?'),
          content: Text("You can't retrieve $deck once its deleted"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                setState(() {
                  final db = DataBaseHelper();
                  db.deleteDeck(widget.collect.username, deck);
                });
                Navigator.pop(context); // Close the dialog
                Navigator.push(context, MaterialPageRoute(
                        builder: (context) => DeckMenuScreen(widget.collect),
                      ),);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
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
        actions: [
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () async {
              showRemoveCardDialogue(context, widget.deckName);
          },
        ),
      ],
      ),
      body: Center(
        child: Column(
          children: [
            _buildCardList('Pokémon', 'Pokémon'),
            _buildCardList('Trainer', 'Trainer'),
            _buildCardList('Energy', 'Energy'),
          ],
        ),
      ),
    );
  }

  Widget _buildCardList(String header, String cardType) {
    List<Map<String, dynamic>> cardsOfType = deckCards.where((card) => card['cardType'] == cardType).toList();

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
      title: Text(card['cardName']),
      subtitle: Text('Quantity: ${card['quantity']}'),
    );
  }
}