import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Collection {
  List<String> cardIds;
  String username = '';
  double collectionPrice = 0.0;



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
  }



  void removeCardID(int index) async {
    cardIds.removeAt(index);

    DocumentReference userDocRef = FirebaseFirestore.instance.collection('usersAndTheirCollection').doc(username);

    DocumentSnapshot snapshot = await userDocRef.get();
    if (snapshot.exists) {
      List<dynamic> idLIST = snapshot['PokeIDs'];
      idLIST.removeAt(index);
      await userDocRef.update({'PokeIDs': idLIST});

    } 
  }

  //Constructors 
  Collection({required this.cardIds, required this.username}) {
    assignUserName(username);
    fetchUserData();
  }

  factory Collection.fromJson(Map<String, dynamic> json, String username) {
    List<String> cardIds = List<String>.from(json['PokeIDs']);

    return Collection(cardIds: cardIds, username: username);
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