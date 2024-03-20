import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcg_app_sp/models/collection.dart';
import 'package:tcg_app_sp/screens/collection_screen.dart';

class SearchCardScreen extends StatefulWidget {
  final Collection collect;

  const SearchCardScreen(this.collect, {Key? key}) : super(key: key);

  @override
  SearchCardScreenState createState() => SearchCardScreenState();
}

class SearchCardScreenState extends State<SearchCardScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> searchResults = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void showAddToCollectionDialog(
      BuildContext context, String cardId, String cardName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add to Collection'),
          content: Text('Do you want to add $cardName to your collection?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                widget.collect.addCardID(cardId);
                await FirebaseFirestore.instance
                    .collection('UserCollection')
                    .doc('userId')
                    .set(widget.collect.toJson());

                Navigator.pop(context, widget.collect);
                if (mounted) {
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CollectionScreen(widget.collect)),
                    );
                  });
                }
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

  void searchCards(String query) {
    List<Map<String, String>> results = [];

    FirebaseFirestore.instance
        .collection('PokeCards')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        String id = doc.id;
        String name = doc['name'].toString().toLowerCase();
        String imageUrl = doc['images']['small'];
        if (name.startsWith(query.toLowerCase())) {
          results.add({'id': id, 'name': name, 'imageUrl': imageUrl});
        }
      }

      if (mounted) {
        setState(() {
          searchResults = results;
        });
      }
    }).catchError((error) {
      throw Exception(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Cards'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(height: 1, color: Colors.black), // Thin black line
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                searchCards(value);
              },
              decoration: InputDecoration(
                hintText: 'Search for cards...',
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    showAddToCollectionDialog(
                        context,
                        searchResults[index]['id']!,
                        searchResults[index]['name']!);
                  },
                  leading: Image.network(searchResults[index]['imageUrl']!),
                  title: Text(searchResults[index]['name']!),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey.shade800,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.autorenew,
                  size: 35,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.folder_open,
                  size: 35,
                  color: Colors.white,
                ),
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
    );
  }
}
