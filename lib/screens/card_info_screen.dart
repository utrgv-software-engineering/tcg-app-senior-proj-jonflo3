import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tcg_app_sp/models/collection.dart';
import 'collection_screen.dart';
import 'package:tcg_app_sp/models/card.dart';

class CardInfoScreen extends StatefulWidget {
  final int index;
  final Collection collect;

  const CardInfoScreen(this.index, this.collect, {super.key});

  @override
  CardInfoScreenState createState() => CardInfoScreenState();
}

class CardInfoScreenState extends State<CardInfoScreen> {
  late Future<List<dynamic>> cardInformation;
  late int length; 
  late CardInfo currentCard = CardInfo(); 

  @override
  void initState() {
    super.initState();
    currentCard.setID(widget.collect.cardIds[widget.index]);
    cardInformation = fetchCardInfo(widget.collect.cardIds[widget.index]);

  }

  Future<List<dynamic>> fetchCardInfo(String id) async {
    List<dynamic> cardInfo = [];
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('PokeCards').doc(id).get();
    if (snapshot.exists) {
      String name = snapshot['name'];
      String rarity = snapshot['rarity'];
      List cardType = snapshot['types'];
      List stage = snapshot['subtypes'];
      List attack = snapshot['attacks'];
      List weakness = snapshot['weaknesses'];
      List retreatCost = snapshot['retreatCost'];
      String cardNum = snapshot['number'];
      String imageUrl = snapshot['images']['small'];

      cardInfo = [name, rarity, cardType, stage, attack, weakness, retreatCost, cardNum, imageUrl];
    }
    return cardInfo;
  }



void showRemoveCardDialogue(BuildContext context, String cardName) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add to Collection'),
        content: Text('Do you want to remove $cardName from your collection?'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              setState(() {
                widget.collect.removeCardID(widget.index);
              });
              Navigator.pop(context); // Close the dialog
              Navigator.push(context, MaterialPageRoute(
                        builder: (context) => CollectionScreen(widget.collect),
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
        title: const Text('Card Information'),
        actions: [
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () async {
              showRemoveCardDialogue(context, currentCard.getCardName());
          },
        ),
      ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: cardInformation, 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('ERROR: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    child: Image.network(
                    currentCard.getImageURL(),
                    ),
                  ),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(currentCard.getCardName(),
                        style: const TextStyle(
                          color: Color.fromARGB(255, 7, 6, 6),
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Card Information',
                          style: TextStyle(
                          color: Color.fromARGB(255, 7, 6, 6),
                          fontSize: 25,)
                        ),
                        Text("Rarity: ${currentCard.getRarity()}"),
                        Text('Card Type: ${currentCard.getCardType()}'),
                        Text('Stage: ${currentCard.getCardStage()}'),
                        Text(currentCard.getCardMoves()),
                        Text('Weakness: ${currentCard.getCardWeakness()}'),
                        Text('Card Number: ${currentCard.getCardNum()}'),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No Data'));
          }
        },
      ),
    );
  }
}