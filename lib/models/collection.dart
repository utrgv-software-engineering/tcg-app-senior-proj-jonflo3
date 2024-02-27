class Collection {
  List<String> cardIds;


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