class Collection {
  List<String> cardIds;

  void addCardID(String cardID) {
    cardIds.add(cardID);
  }

  void removeCardID(int index) {
    cardIds.removeAt(index);
  }


  Collection({required this.cardIds});

  factory Collection.fromJson(Map<String, dynamic> json) {
    List<String> cardIds = List<String>.from(json['cardIds']);
    return Collection(cardIds: cardIds);
  }

  Map<String, dynamic> toJson() {
    return {
      'cardIds': cardIds,
    };
  }
}