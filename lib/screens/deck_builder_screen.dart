import 'package:flutter/material.dart';
import 'package:tcg_app_sp/models/collection.dart';
import 'package:tcg_app_sp/SQLite/sqlite.dart';

class DeckBuilderScreen extends StatefulWidget {
  final Collection collect;

  const DeckBuilderScreen(this.collect, {super.key});

  @override
  DeckBuilderScreenState createState() => DeckBuilderScreenState();
}

class DeckBuilderScreenState extends State<DeckBuilderScreen> {
  List<Map<String, dynamic>> collection = [];
  num cardSum60 = 0; 
  String deckName = 'New Deck';
  TextEditingController deckNameController = TextEditingController();
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    collection = widget.collect.allCards;
  }

  List<Map<String, dynamic>> selectedCards = [];

  void updateCardSum() {
    List<Map<String, dynamic>> pokemonCards = selectedCards.where((card) => card['type'] == 'Pokémon').toList();
    List<Map<String, dynamic>> trainerCards = selectedCards.where((card) => card['type'] == 'Trainer').toList();
    List<Map<String, dynamic>> energyCards = selectedCards.where((card) => card['type'] == 'Energy').toList();

    num totalPokemonQuantity = pokemonCards.fold(0, (total, card) => total + card['quantity']);
    num totalTrainerQuantity = trainerCards.fold(0, (total, card) => total + card['quantity']);
    num totalEnergyQuantity = energyCards.fold(0, (total, card) => total + card['quantity']);
    cardSum60 = totalPokemonQuantity + totalTrainerQuantity + totalEnergyQuantity;
  }

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
        title: Text(
          deckName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isEditing = true;
                          deckNameController.text = deckName;
                        });
                      },
                      child: const Text(
                        'Edit Deck Name',
                        style: TextStyle(
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isEditing)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: deckNameController,
                          decoration: const InputDecoration(
                            hintText: 'Enter Deck Name',
                          ),
                      ) ,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            deckName = deckNameController.text;
                            isEditing = false;
                          });
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ),
              _buildCardDropdown('Collection', collection, cardSum60),
              _buildSelectedCardsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardDropdown(String header, List<Map<String, dynamic>> cards, num cardSum60) {
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
            _showQuantityDialog(selectedCard!, cardSum60);
          },
        ),
      ],
    );
  }

  void _showQuantityDialog(Map<String, dynamic> selectedCard, num cardSum60) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (selectedCard['type'] == 'Energy') {
          TextEditingController quantityController = TextEditingController();

          return AlertDialog(
            title: const Text('Enter Quantity (1-60)'),
            content: TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (int.tryParse(value) != null) {
                  int quantity = int.parse(value);
                  if (quantity >= 1 && quantity <= 60) {
                    quantityController.text = quantity.toString();
                  } else {
                    quantityController.clear();
                  }
                } else {
                  quantityController.clear();
                }
              },
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  int quantity = int.parse(quantityController.text);
                  updateCardSum();
                  if (cardSum60 + quantity <= 60) {
                    addCard(selectedCard['id'], selectedCard['type'], selectedCard['name'], selectedCard['imgURL'], quantity);
                    updateCardSum();
                    Navigator.of(context).pop();
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            'Error',
                            style: TextStyle(color: Colors.red),
                          ),
                          content: const Text(
                            'You can\'t add this many cards. Card total has reached over 60',
                            style: TextStyle(color: Colors.red),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  //addCard(selectedCard['id'], selectedCard['type'], selectedCard['name'], selectedCard['imgURL'], quantity);
                  //Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: const Text('Select Quantity'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                4,
                (index) => ListTile(
                  title: Text('${index + 1}'),
                  onTap: () {
                    updateCardSum();
                    if (cardSum60 + index + 1 <= 60) {
                      addCard(selectedCard['id'], selectedCard['type'], selectedCard['name'], selectedCard['imgURL'], index + 1);
                      updateCardSum();
                      Navigator.of(context).pop();
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              'Error',
                              style: TextStyle(color: Colors.red),
                            ),
                            content: const Text(
                              'You can\'t add this many cards. Card total has reached over 60',
                              style: TextStyle(color: Colors.red),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          );
        }
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
    cardSum60 = totalPokemonQuantity + totalTrainerQuantity + totalEnergyQuantity;

    return Column(
      children: [
        if (pokemonCards.isNotEmpty)
          Column(
            children: [
              const Text('Pokémon'),
              ...pokemonCards.map((card) => _buildCardTile(card, cardSum60)),
            ],
          ),
        if (trainerCards.isNotEmpty)
          Column(
            children: [
              const Text('Trainer'),
              ...trainerCards.map((card) => _buildCardTile(card, cardSum60)),
            ],
          ),
        if (energyCards.isNotEmpty)
          Column(
            children: [
              const Text('Energy'),
              ...energyCards.map((card) => _buildCardTile(card, cardSum60)),
            ],
          ),
        Text('$cardSum60/60 Cards'),
        if (cardSum60 == 60)
          ElevatedButton(
            onPressed: () {
              final db = DataBaseHelper();
              db.saveDeck(widget.collect.username, deckName, pokemonCards, trainerCards, energyCards);
              Navigator.of(context).pop();
            },
            child: const Text('Save Deck'),
          ),
      ],
    );
  }

  Widget _buildCardTile(Map<String, dynamic> card, num totalOverallQuantity) {
    return ListTile(
      leading: Image.network(card['imgURL']),
      title: Text(card['name']),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_drop_up),
            onPressed: () {
              setState(() {
                if (totalOverallQuantity < 60){
                  if ((card['type'] == 'Pokémon' || card['type'] == 'Trainer') && card['quantity'] < 4) {
                    card['quantity']++;
                    updateCardSum();
                  } else if (card['type'] == 'Energy' && card['quantity'] < 60) {
                    card['quantity']++;
                    updateCardSum();
                  }
                }
              });
            },
          ),
          Text('Quantity: ${card['quantity']}'),
          IconButton(
            icon: const Icon(Icons.arrow_drop_down),
            onPressed: () {
              setState(() {
                if (card['quantity'] > 0) {
                  card['quantity']--;
                  updateCardSum();
                }
              });
            },
          ),
        ],
      ),
    );
  }
}