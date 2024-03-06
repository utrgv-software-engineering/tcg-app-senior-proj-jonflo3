import 'package:flutter/material.dart';
import 'package:tcg_app_sp/models/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcg_app_sp/screens/card_info_screen.dart';
import 'package:tcg_app_sp/screens/search_card_screen.dart';

class CollectionScreen extends StatefulWidget {
  final Collection collect;

  CollectionScreen(this.collect);

  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  late Future<List<String>> futureImageUrls;
  
  Collection? get collect => null;


  @override
  void initState() {
    super.initState();
    futureImageUrls = fetchImageUrls(widget.collect.cardIds);
  }

  Future<List<String>> fetchImageUrls(List<String> cardIds) async {
    List<String> imageUrls = [];
    for (String cardId in cardIds) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('PokeCards').doc(cardId).get();
      if (snapshot.exists) {
        String imageUrl = snapshot['images']['small'];
        imageUrls.add(imageUrl);
      }
    }
    return imageUrls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF404040),
        title: const Text('Collection',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold, // Customize text color
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.push(context, MaterialPageRoute(
                        builder: (context) => SearchCardScreen(widget.collect),
                      ),);
            },
            icon: const Icon(
              Icons.add,
              size: 35,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<String>>(
          future: futureImageUrls,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('ERROR: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final List<String> imageUrls = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(10),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 5,
                    childAspectRatio: 735 / 1025,
                  ),
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CardInfoScreen(index, widget.collect),
                          ),
                        );
                      },
                      child: Container(
                        child: Image.network(
                          imageUrls[index],
                        ),
                      ),
                    );
                  
                  },
                ),
              );
            } else {
              return const Text('No Data');
            }
          },
        ),
      ),
      // BottomAppBar and other widgets
    );
  }
}