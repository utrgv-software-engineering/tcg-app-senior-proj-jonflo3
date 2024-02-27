import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcg_app_sp/models/collection.dart';
import 'package:tcg_app_sp/screens/collection_screen.dart';

class SearchCardScreen extends StatefulWidget {
  final Collection collect;

  SearchCardScreen(this.collect);

  @override
  _SearchCardScreenState createState() => _SearchCardScreenState();
}

class _SearchCardScreenState extends State<SearchCardScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> searchResults = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

void showAddToCollectionDialog(BuildContext context, String cardId, String cardName) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Add to Collection'),
        content: Text('Do you want to add $cardName to your collection?'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              Collection updatedCollection = Collection(cardIds: List<String>.from(widget.collect.cardIds));
              updatedCollection.cardIds.add(cardId);
              print(widget.collect.cardIds);
              // Update the collection in Firestore with the new card ID
              await FirebaseFirestore.instance.collection('UserCollection').doc('userId').set(updatedCollection.toJson());

              // Trigger a refresh of the CollectionScreen
              Navigator.pop(context); // Close the dialog
              Navigator.push(context, MaterialPageRoute(
                        builder: (context) => CollectionScreen(updatedCollection),
                      ),);
            },
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('No'),
          ),
        ],
      );
    },
  );
}

  void searchCards(String query) {
    List<Map<String, String>> results = [];

    FirebaseFirestore.instance
        .collection('PokeCards')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        String id = doc.id;
        String name = doc['name'].toString().toLowerCase();
        String imageUrl = doc['images']['small'];

        if (name.startsWith(query.toLowerCase())) {
          results.add({'id': id, 'name': name, 'imageUrl': imageUrl});
        }
      });

      if (mounted) {
        setState(() {
          searchResults = results;
        });
      }
    })
    .catchError((error) {
      print('Error fetching data: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Cards'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: (value) {
              searchCards(value);
            },
            decoration: InputDecoration(
              hintText: 'Search for cards...',
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    showAddToCollectionDialog(context, searchResults[index]['id']!, searchResults[index]['name']!);
                  },
                  leading: Image.network(searchResults[index]['imageUrl']!),
                  title: Text(searchResults[index]['name']!),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomAppBar(
          color: const Color(0xFF404040),
          child: Center(
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.autorenew,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 120,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.folder_open,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 120,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.account_circle,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}