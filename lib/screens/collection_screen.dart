import 'package:flutter/material.dart';
import 'package:tcg_app_sp/screens/card_info_screen.dart';
import 'package:tcg_app_sp/models/card.dart';
import 'package:tcg_app_sp/models/collection.dart';
import 'package:tcg_app_sp/screens/search_card_screen.dart';
import 'package:tcg_app_sp/screens/menu_screen.dart';
import 'package:tcg_app_sp/SQLite/sqlite.dart';
//import 'package:tcg_app_sp/screens/deck_builder_screen.dart';

class CollectionScreen extends StatefulWidget {
  final Collection collect;
  

  const CollectionScreen(this.collect, {super.key});

  @override
  CollectionScreenState createState() => CollectionScreenState();
}

class CollectionScreenState extends State<CollectionScreen> {
  List<String> imgURLs = [];

  @override
  void initState() {
    super.initState();
    fetchImageUrls(widget.collect.username);
  }

  Future<void> fetchImageUrls(String user) async {
    List<String> urls = await DataBaseHelper().getImageUrlsForUser(user);
    setState(() {
      imgURLs = urls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF404040), 
        elevation: 0, 
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (context) => MenuScreen(widget.collect),));
          },
        ), 
        title: const Text(
          'Collection',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, 
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchCardScreen(widget.collect),
                ),
              );
            },
            icon: const Icon(
              Icons.add,
              size: 35,
              color: Colors.white,
            ),
          ),
        ]
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 5,
              childAspectRatio: 735 / 1025,
            ),
            itemCount: imgURLs.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  CardInfo currentCard = CardInfo();
                  currentCard.setID(widget.collect.cardIds[index]);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CardInfoScreen(index, widget.collect),
                    ),
                  );
                },
                child: Image.network(
                  imgURLs[index],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
