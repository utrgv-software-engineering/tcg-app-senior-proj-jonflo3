import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tcg_app_sp/SQLite/sqlite.dart';


//import 'package:tcg_app_sp/screens/deck_construction_menu_screen.dart';

class Collection {
  List<Map<String, dynamic>> allCards = [];
  List<String> cardIds;
  String username = '';

  void assignUserName(String un) {
    username = un;
  }

  Future<void> updateCardIDs() async {
    final db = DataBaseHelper();
    List<String> cardIDsList = await db.getCardIdsForUser(getName());
    cardIds = cardIDsList;

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

  Future<double> getCollectionPrice() async {
    String apiBase = 'https://api.pokemontcg.io/v2/cards';
    double collectionPrice = 0.0;

    for (int i = 0; i < cardIds.length; i++) {
      String curID = cardIds[i];
      var response = await http.get(Uri.parse('$apiBase?q=id:$curID'));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        // Check if the data contains the expected structure
        if (data['data'][0]['tcgplayer'] != null) {
          // Access the "prices" object within "tcgplayer"
          var prices = data['data'][0]['tcgplayer']['prices'];
          // Check if the "prices" object exists and is not null
          if (prices != null) {
            // Access the "market" variable within "prices"
            double marketPrice = 0.0;
            if (prices['holofoil'] != null) {
              marketPrice = prices['holofoil']['market'];
            } else {
              marketPrice = prices['normal']['market'];
            }
            collectionPrice += marketPrice;
          }
        }
      } 
    }
    return collectionPrice;
  }

  //SECTION 2
  void addCardID(String cardID) async {
    cardIds.add(cardID);

    /*DocumentReference userDocRef = FirebaseFirestore.instance.collection('usersAndTheirCollection').doc(username);
    await userDocRef.update({
        'PokeIDs': FieldValue.arrayUnion([cardID]),
    });*/

    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('PokeCards').doc(cardID).get();
    final db = DataBaseHelper();
    if (snapshot.exists) {
      String cardName = snapshot['name'];
      cardName = cardName.replaceAll("'", "''");
      String imgURL = snapshot['images']['small'];
      String cardType = snapshot['supertype'];
      
      db.addCardToCollection(
      cardID, 
      getName(), 
      cardName, 
      imgURL, 
      cardType
      );
    }
    updateCardIDs();
    cardIds = await db.getCardIdsForUser(getName());


  }

  void printList () {
    print(cardIds);
  }



  void removeCardID(String id) async {
    //allCards.removeWhere((element) => element['id'] == id);

    /*DocumentReference userDocRef = FirebaseFirestore.instance.collection('usersAndTheirCollection').doc(username);

    DocumentSnapshot snapshot = await userDocRef.get();
    if (snapshot.exists) {
      List<dynamic> idLIST = snapshot['PokeIDs'];
      idLIST.removeAt(index);
      await userDocRef.update({'PokeIDs': idLIST});

    } */

    final db = DataBaseHelper();
      db.deleteCardFromCollection(
      id, 
      getName(), 
    );
    updateCardIDs();
  }

  //Constructors 
  Collection({required this.cardIds, required this.username,}) {
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