import 'package:cloud_firestore/cloud_firestore.dart';

class Collection {
  List<String> cardIds;
  String username = '';



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
    } else {
      
    }
  }

  String getName() {
    return username;
  }

  void addCardID(String cardID) async {
    cardIds.add(cardID);

    DocumentReference userDocRef = FirebaseFirestore.instance.collection('usersAndTheirCollection').doc(username);
    DocumentSnapshot snapshot = await userDocRef.get();

    if (snapshot.exists) {
      await userDocRef.update({
        'PokeIDs': FieldValue.arrayUnion([cardID])
      });
    } else {

    }

  }


  void removeCardID(int index) async {
    cardIds.removeAt(index);

    DocumentReference userDocRef = FirebaseFirestore.instance.collection('usersAndTheirCollection').doc(username);

    DocumentSnapshot snapshot = await userDocRef.get();
    if (snapshot.exists) {
      List<dynamic> idLIST = snapshot['PokeIDs'];
      idLIST.removeAt(index);
      await userDocRef.update({'PokeIDs': idLIST});

    } else {

    }
  }


  //Collection({required this.cardIds});

  Collection({required this.cardIds, required this.username}) {
    // Function called inside the constructor
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
        'PokeIDs': [], // Set PokeIDs as an empty array
      });
    }
  }
}