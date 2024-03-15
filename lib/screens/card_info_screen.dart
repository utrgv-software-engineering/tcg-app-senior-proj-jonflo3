import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tcg_app_sp/models/collection.dart';
import 'collection_screen.dart';

class CardInfoScreen extends StatefulWidget {
  final int index;
  final Collection collect;

  CardInfoScreen(this.index, this.collect);

  @override
  _CardInfoScreenState createState() => _CardInfoScreenState();
}

class _CardInfoScreenState extends State<CardInfoScreen> {
  late Future<List<dynamic>> cardInformation;
  late int length; 

  @override
  void initState() {
    super.initState();
    cardInformation = fetchCardInfo(widget.collect.cardIds[widget.index]);
    fetchNumofMoves(cardInformation).then((value) {
      setState(() {
        length = value;
      });
    });
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

  Future<int> fetchNumofMoves(Future<List<dynamic>> cardInfoFuture) async {
  List<dynamic> cardInfo = await cardInfoFuture;
  int length = cardInfo[4].length;

  return length;
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
                widget.collect.cardIds.removeAt(widget.index);
              });

              // Trigger a refresh of the CollectionScreen
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
              showRemoveCardDialogue(context, 'card');
              /*setState(() {
                widget.collect.cardIds.removeAt(widget.index);
              });

              Navigator.push(context, MaterialPageRoute(
                builder: (context) => CollectionScreen(widget.collect),
              ),);*/
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
            final List<dynamic> cardInfo = snapshot.data!;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    child: Image.network(
                    cardInfo[8],
                    ),
                  ),
                  Row(
                    children: [
                      Text(cardInfo[0],
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
                        Text('Rarity: ${cardInfo[1]}'),
                        Text('Card Type: ${cardInfo[2][0]}'),
                        Text('Stage: ${cardInfo[3][0]}'),
                        Text(length == 1 ? 'Attack 1: ${cardInfo[4][0]['text']} Damage: ${cardInfo[4][0]['damage']}' : 
                        length == 2 ? 'Attack 1: ${cardInfo[4][0]['text']} Damage: ${cardInfo[4][0]['damage']} \n Attack 2: ${cardInfo[4][0]['text']} Damage: ${cardInfo[4][0]['damage']}': 
                        'Another string'),
                        Text('Weakness: ${cardInfo[5][0]['type']} ${cardInfo[5][0]['value']}'),
                        Text('Card Number: ${cardInfo[7]}'),
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