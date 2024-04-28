import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tcg_app_sp/models/decks.dart';

//import 'package:tcg_app_sp/screens/deck_construction_menu_screen.dart';

class Collection {
  List<Map<String, dynamic>> allCards = [];
  List<String> cardIds;
  String username = '';
  double collectionPrice = 0.0;
  Decks myDecks;




  void assignUserName(String un) {
    username = un;
  }

  Future<void> updateCardIDs() async {
    List<String> cardIDsList = [];

    DocumentReference userDocRef = FirebaseFirestore.instance.collection('usersAndTheirCollection').doc(username);
    DocumentSnapshot snapshot = await userDocRef.get();
    if (snapshot.exists) {
      List<dynamic> idLIST = snapshot['PokeIDs'];
      cardIDsList = List<String>.from(idLIST.map((id) => id.toString()));
      cardIds = cardIDsList; 
    } 

    for(int i = 0; i < cardIds.length; i++){
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('PokeCards').doc(cardIds[i]).get();
      if (snapshot.exists) {
        if(snapshot['supertype'] == 'Pokémon'){
          String cardName = snapshot['name'];
          String cardRarity = snapshot['rarity'];
          String cardType = snapshot['supertype'];
          List pokeType = snapshot['types'];
          List stage = snapshot['subtypes'];
          List moves = snapshot['attacks'];
          List weakness = snapshot['weaknesses'];
          List retreatCost = snapshot['retreatCost'];
          String cardNum = snapshot['number'];
          String imgURL = snapshot['images']['small'];

          Map<String, dynamic> newEntry = {
            'id': cardIds[i],
            'name': cardName,
            'rarity': cardRarity,
            'type': cardType,
            'poke type': pokeType,
            'stage': stage,
            'moves': moves,
            'weakness': weakness,
            'retreat cost': retreatCost,
            'number': cardNum,
            'imgURL': imgURL,
          };

          allCards.add(newEntry);
        }else if(snapshot['supertype'] == 'Trainer'){
          String cardName = snapshot['name'];
          String cardRarity = snapshot['rarity'];
          String cardType = snapshot['supertype'];
          List cardRules = snapshot['rules'];
          String cardNum = snapshot['number'];
          String imgURL = snapshot['images']['small'];

          Map<String, dynamic> newEntry = {
            'id': cardIds[i],
            'name': cardName,
            'rarity': cardRarity,
            'type': cardType,
            'rules': cardRules,
            'number': cardNum,
            'imgURL': imgURL,
          };

          allCards.add(newEntry);
        }else{
          String cardName = snapshot['name'];
          //String cardRarity = snapshot['rarity'];
          String cardType = snapshot['supertype'];
          String cardNum = snapshot['number'];
          String imgURL = snapshot['images']['small'];

          Map<String, dynamic> newEntry = {
            'id': cardIds[i],
            'name': cardName,
            //'rarity': cardRarity,
            'type': cardType,
            'number': cardNum,
            'imgURL': imgURL,
          };

          allCards.add(newEntry);
        }
      }
    }
  }

  String getName() {
    return username;
  }

  Future<void> getCollectionPrice() async {
    String apiBase = 'https://api.pokemontcg.io/v2/cards';
    collectionPrice = 0; 
    for(int i = 0; i < cardIds.length; i++){
      String curID = cardIds[i];
      var response = await http.get(Uri.parse('$apiBase?q=id:$curID'));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        double averageSellPrice;
        if (data['data'][0]['tcgplayer']['prices']['holofoil'] != null) {
          averageSellPrice = data['data'][0]['tcgplayer']['prices']['holofoil']['market'];
        } else {
          averageSellPrice = data['data'][0]['tcgplayer']['prices']['normal']['market'];
        }
        collectionPrice = collectionPrice + averageSellPrice; 
      } 
    }
  }

  //SECTION 2
  void addCardID(String cardID) async {
    cardIds.add(cardID);

    DocumentReference userDocRef = FirebaseFirestore.instance.collection('usersAndTheirCollection').doc(username);
    await userDocRef.update({
        'PokeIDs': FieldValue.arrayUnion([cardID]),
    });

    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('PokeCards').doc(cardID).get();

    if (snapshot.exists) {
      if(snapshot['supertype'] == 'Pokémon'){
        String cardName = snapshot['name'];
        String cardRarity = snapshot['rarity'];
        String cardType = snapshot['supertype'];
        List pokeType = snapshot['types'];
        List stage = snapshot['subtypes'];
        List moves = snapshot['attacks'];
        List weakness = snapshot['weaknesses'];
        List retreatCost = snapshot['retreatCost'];
        String cardNum = snapshot['number'];
        String imgURL = snapshot['images']['small'];

        Map<String, dynamic> newEntry = {
          'id': cardID,
          'name': cardName,
          'rarity': cardRarity,
          'type': cardType,
          'poke type': pokeType,
          'stage': stage,
          'moves': moves,
          'weakness': weakness,
          'retreat cost': retreatCost,
          'number': cardNum,
          'imgURL': imgURL,
        };

        allCards.add(newEntry);
      }else if(snapshot['supertype'] == 'Trainer'){
        String cardName = snapshot['name'];
        String cardRarity = snapshot['rarity'];
        String cardType = snapshot['supertype'];
        List cardRules = snapshot['rules'];
        String cardNum = snapshot['number'];
        String imgURL = snapshot['images']['small'];

        Map<String, dynamic> newEntry = {
          'id': cardID,
          'name': cardName,
          'rarity': cardRarity,
          'type': cardType,
          'rules': cardRules,
          'number': cardNum,
          'imgURL': imgURL,
        };

        allCards.add(newEntry);
      }else{
        String cardName = snapshot['name'];
        String cardType = snapshot['supertype'];
        String cardNum = snapshot['number'];
        String imgURL = snapshot['images']['small'];

        Map<String, dynamic> newEntry = {
          'id': cardID,
          'name': cardName,
          'type': cardType,
          'number': cardNum,
          'imgURL': imgURL,
        };

        allCards.add(newEntry);
      }
    }

  }



  void removeCardID(int index) async {
    String id = cardIds[index];
    allCards.removeWhere((element) => element['id'] == id);

    DocumentReference userDocRef = FirebaseFirestore.instance.collection('usersAndTheirCollection').doc(username);

    DocumentSnapshot snapshot = await userDocRef.get();
    if (snapshot.exists) {
      List<dynamic> idLIST = snapshot['PokeIDs'];
      idLIST.removeAt(index);
      await userDocRef.update({'PokeIDs': idLIST});

    } 

    cardIds.removeAt(index);
  }

  //Constructors 
  Collection({required this.cardIds, required this.username,}) 
    : myDecks = Decks() {
    assignUserName(username);

  }

  factory Collection.fromJson(Map<String, dynamic> json, String username) {
    List<String> cardIds = List<String>.from(json['PokeIDs']);

    return Collection(cardIds: cardIds, username: username,);
  }

  Map<String, dynamic> toJson() {
    return {
      'PokeIDs': cardIds,
    };
  }

  Future<void> fetchUserData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('usersAndTheirCollection').doc(username).get();
    if (snapshot.exists) {
      await updateCardIDs();
    } else {
      await FirebaseFirestore.instance.collection('usersAndTheirCollection').doc(username).set({
        'username': username,
        'PokeIDs': [], 
        'ColPriceTotal': 0,
      });
    }
  }
}