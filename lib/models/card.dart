// ignore_for_file: unused_field, prefer_interpolation_to_compose_strings
import 'package:cloud_firestore/cloud_firestore.dart';

class CardInfo {
  String cardID = "";
  String _cardName = "";
  String _cardRarity = "";
  List _cardType = [];
  List _stage = []; 
  List _moves = []; 
  List _weakness = []; 
  List _retreatCost = [];
  String _cardNum = "";
  String _imgURL = "";

  void setID(String id) {
    cardID = id; 
    fetchCardInfo();
  }

  String getCardName() {
    return _cardName; 
  }

  String getRarity() {
    return _cardRarity;
  }

  String getCardType() {
    String type = "";
    for(var i = 0; i < _cardType.length; i++){
      type = "${type + _cardType[i]} "; 
    }
    return type;
  }

  String getCardMoves() {
    String moves = "Attacks: \n";
    for(var i = 0; i < _moves.length; i++){
      if(i == _moves.length - 1){
        moves = "${moves + _moves[i]['name']}: ${_moves[i]['text']}"; 
      }else if(i < _moves.length - 1){
        moves = "${moves + _moves[i]['name']}: ${_moves[i]['text']}  \n"; 
      }
    }
    return moves;
  }

  String getCardStage() {
    String stage = "";
    for(var i = 0; i < _stage.length; i++){
      stage = "${stage + _stage[i]} "; 
    }
    return stage;
  }

  String getCardWeakness() {
    String weakness = "";
    for(var i = 0; i < _weakness.length; i++){
      weakness = "${weakness + _weakness[i]['type']} " +  _weakness[i]['value'];
    }
    return weakness;
  }

  String getCardNum() {
    return _cardNum;
  }

  String getImageURL() {
    return _imgURL;
  }

  void fetchCardInfo() async {
    //List<dynamic> cardInfo = [];
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('PokeCards').doc(cardID).get();
    if (snapshot.exists) {
      _cardName = snapshot['name'];
      _cardRarity = snapshot['rarity'];
      _cardType = snapshot['types'];
      _stage = snapshot['subtypes'];
      _moves = snapshot['attacks'];
      _weakness = snapshot['weaknesses'];
      _retreatCost = snapshot['retreatCost'];
      _cardNum = snapshot['number'];
      _imgURL = snapshot['images']['small'];

    }

  }

}