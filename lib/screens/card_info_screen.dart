import 'package:flutter/material.dart';
import 'package:tcg_app_sp/models/collection.dart';
import 'collection_screen.dart';


class CardInfoScreen extends StatefulWidget {
  final int index;
  final Collection collect;

  const CardInfoScreen(this.index, this.collect, {super.key});

  @override
  _CardInfoScreenState createState() => _CardInfoScreenState();
}

class _CardInfoScreenState extends State<CardInfoScreen> {
  late Map<String,dynamic> cardInformation;
  late int length; 
  //late CardInfo currentCard = CardInfo(); 

  @override
  void initState() {
    super.initState();
    //currentCard.setID(widget.collect.cardIds[widget.index]);
    cardInformation = fetchCardInfo(widget.collect.cardIds[widget.index]);

  }

  String getCardType() {
    List types = cardInformation['poke type'];
    String type = '';
    for(var i = 0; i < types.length; i++){
      type = "${type + types[i]} "; 
    }
    return type;
  }

  String getCardStage() {
    List stages = cardInformation['stage'];
    String stage = '';
    for(var i = 0; i < stages.length; i++){
      stage = "${stage + stages[i]} "; 
    }
    return stage;
  }

  String getCardMoves() {
    List moves = cardInformation['moves'];
    String move = "Attacks: \n";
    for(var i = 0; i < moves.length; i++){
      if(i == moves.length - 1){
        move = "${move + moves[i]['name']} ${moves[i]['text']}"; 
      }else if(i < moves.length - 1){
        move = "${move + moves[i]['name']} ${moves[i]['text']}  \n"; 
      }
    }
    return move;
  }

  String getCardWeakness() {
    List weak = cardInformation['weakness'];
    String weakness = "";
    for(var i = 0; i < weak.length; i++){
      weakness = "${weakness + weak[i]['type']} " +  weak[i]['value'];
    }
    return weakness;
  }

  String getCardRules() {
    List rule = cardInformation['rules'];
    String rules = "";
    for(var i = 0; i < rule.length; i++){
      rules = "${rules + rule[i][i]} ";
    }
    return rules;
  }

  Map<String,dynamic> fetchCardInfo(String id) {
    Map<String,dynamic> cardInfo;
    cardInfo = widget.collect.allCards.firstWhere((element) => element['id'] == id);

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
              showRemoveCardDialogue(context, 'Card');
          },
        ),
      ],
      ),
      body: Center(
        child: cardInformation['type'] == 'Pokémon'
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  child: Image.network(
                    cardInformation['imgURL'],
                  ),
                ),
                Row(
                  children: [
                    Text(cardInformation['name'],
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
                      Text('${cardInformation['type']} Card',
                        style: const TextStyle(
                        color: Color.fromARGB(255, 7, 6, 6),
                        fontSize: 25,)
                      ),
                      Text('Rarity: ${cardInformation['rarity']}'),
                      Text('Card Type: ${getCardType()}'),
                      Text('Stage: ${getCardStage()}'),
                      Text(getCardMoves()),
                      Text('Weakness: ${getCardWeakness()}'),
                      Text('Card Number: ${cardInformation['number']}'),
                    ],
                  ),
                ),
              ],
            )
          : cardInformation['type'] == 'Trainer'
          ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: Image.network(
                  cardInformation['imgURL'],
                ),
              ),
              Row(
                children: [
                  Text(cardInformation['name'],
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
                    Text('${cardInformation['type']} Card',
                      style: const TextStyle(
                      color: Color.fromARGB(255, 7, 6, 6),
                      fontSize: 25,)
                    ),
                    Text('Rarity: ${cardInformation['rarity']}'),
                    Text('Rules: ${cardInformation['rules']}'),
                    Text('Card Number: ${cardInformation['number']}'),
                  ],
                ),
              ),
            ]
          )
          : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: Image.network(
                  cardInformation['imgURL'],
                ),
              ),
              Row(
                children: [
                  Text(cardInformation['name'],
                    style: const TextStyle(
                      color: Color.fromARGB(255, 7, 6, 6),
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    ),
                  ),
                ],
              ),
            ]
          )
      ),
        
    );
  }
}