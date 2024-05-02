import 'package:flutter/material.dart';
import 'package:tcg_app_sp/models/decks.dart';
import 'package:tcg_app_sp/screens/card_info_screen.dart';
import 'package:tcg_app_sp/models/card.dart';
import 'package:tcg_app_sp/models/collection.dart';
import 'package:tcg_app_sp/SQLite/sqlite.dart';

class ProfileScreen extends StatefulWidget {
  final Collection collect;
  final Decks deck;  

  const ProfileScreen(this.collect, this.deck, {super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  List<String> imgURLs = [];
  late String usrName;
  late double collectionPrice = 0.0;
  late int cardsQty = widget.collect.allCards.length;
  late int decksQty = widget.deck.allDecks.length;

  @override
  void initState() {
    super.initState();
    usrName = widget.collect.getName();
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
            // Navigator.push(context,MaterialPageRoute(builder: (context) => MenuScreen(widget.collect),));
            Navigator.pop(context);
          },
        ), 
        title: Text(
          'Hello, $usrName!',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://st3.depositphotos.com/6672868/13701/v/450/depositphotos_137014128-stock-illustration-user-profile-icon.jpg'),
              ),
              Text(usrName,
              style: const TextStyle(
                fontSize: 24,
              ),
              ),
              const SizedBox(height: 5),
              FutureBuilder<double>(
                future: widget.collect.getCollectionPrice(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Or some other loading indicator
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    collectionPrice = snapshot.data!;
                    // Now you can use collectionPrice as a double value
                    return Text('Collection Price: \$${collectionPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18),);
                  }
                },
              ),
              const SizedBox(height: 5),
              Text('Total cards: $cardsQty',
              style: const TextStyle(
                fontSize: 18,
              ),
              ),
              const SizedBox(height: 5),
              Text('Number of decks: $decksQty',
              style: const TextStyle(
                fontSize: 18,
              ),
              ),
            Expanded(
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
            ],
          )
        )
      ),
    );
  }
}
