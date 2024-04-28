
class Decks {
  List<List<Map<String, dynamic>>> allDecks = [];

  void addDeck(List<Map<String, dynamic>> selectedCards) {
    allDecks.add(selectedCards);
  }
}