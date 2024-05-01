import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:tcg_app_sp/models/card.dart';
import 'package:tcg_app_sp/models/collection.dart';
//import 'package:tcg_app_sp/models/userinfo.dart';
//import 'package:tcg_app_sp/screens/card_info_screen.dart';
//import 'package:tcg_app_sp/screens/collection_screen.dart';

class ProfileScreen extends StatefulWidget {
  final Collection collect;

  const ProfileScreen(this.collect, {super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen>{
  late Future<List<String>> futureImageUrls;
  late String usrName;
  late double collectionPrice = 0.0;

  @override
  void initState() {
    super.initState();
    usrName = widget.collect.getName();
    futureImageUrls = Future.value([]);
    initializeImageUrls();
  }

  Future<void> initializeImageUrls() async {
    List<String> imageUrls = await fetchImageUrls(widget.collect.cardIds);
    setState(() {
      futureImageUrls = Future.value(imageUrls);
    });
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
        elevation: 0, 
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          onPressed: () async {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.home),
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
          child: Column(
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
              const Text('Total cards: 999',
              style: TextStyle(
                fontSize: 18,
              ),
              ),
              const SizedBox(height: 5),
              const Text('Number of decks: 151',
              style: TextStyle(
                fontSize: 18,
              ),
              ),
              /*Expanded(
                child: ListView(
                  children: [
                    FutureBuilder<List<String>>(
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
                                    imageUrls[index],
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
                  ],
                ),
                ),  */            
            ],
          ),
        ),
    );
  }
}