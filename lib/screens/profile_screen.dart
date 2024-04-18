import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcg_app_sp/models/card.dart';
import 'package:tcg_app_sp/models/collection.dart';
import 'package:tcg_app_sp/screens/card_info_screen.dart';
import 'package:tcg_app_sp/screens/collection_screen.dart';

class ProfileScreen extends StatefulWidget {
  // final Collection collect;

  const ProfileScreen({super.key});
  // const ProfileScreen(this.collect, {super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen>{
  late Future<List<String>> futureImageUrls;

  // @override
  // void initState() {
  //   super.initState();
  //   futureImageUrls = fetchImageUrls(widget.collect.cardIds);
  // }

  // Future<List<String>> fetchImageUrls(List<String> cardIds) async {
  //   List<String> imageUrls = [];
  //   for (String cardId in cardIds) {
  //     DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('PokeCards').doc(cardId).get();
  //     if (snapshot.exists) {
  //       String imageUrl = snapshot['images']['small'];
  //       imageUrls.add(imageUrl);
  //     }
  //   }
  //   return imageUrls;
  // }

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
            // Navigator.push(
            //   context, 
            //   MaterialPageRoute(
            //     builder: (context) => CollectionScreen(widget.collect, widget.username),
            //   )
            // );
          },
          icon: const Icon(Icons.home),
          ),
        title: const Text(
          'Hello, admin!',
          style: TextStyle(
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
                backgroundImage: AssetImage('./lib/images/placeholder.jpg'),
              ),
              const Text('admin',
              style: TextStyle(
                fontSize: 24,
              ),
              ),
              const SizedBox(height: 5),
              const Text('Current value: \$9,999,999.99',
              style: TextStyle(
                fontSize: 18,
              ),
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
              const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Image.network('https://product-images.tcgplayer.com/451703.jpg', height: 125,),
                    const Text("Pikachu"),
                    Image.network('https://m.media-amazon.com/images/I/71nbfl-JklS._AC_UF894,1000_QL80_.jpg', height: 125,),
                    const Text("Charizard"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Image.network('https://m.media-amazon.com/images/I/51An2H2TLdL._AC_UF894,1000_QL80_.jpg', height: 125,),
                    const Text("Squirtle"),
                    Image.network('https://product-images.tcgplayer.com/274433.jpg', height: 125,),
                    const Text("Bulbasaur"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Image.network('https://m.media-amazon.com/images/I/71U+6OllbdL._AC_UF894,1000_QL80_DpWeblab_.jpg', height: 125,),
                    const Text("Mewtwo"),
                    Image.network('https://product-images.tcgplayer.com/fit-in/437x437/253176.jpg', height: 125,),
                    const Text("Mew"),
                  ],
                ),                
              // FutureBuilder<List<String>>(
              //   future: futureImageUrls,
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const CircularProgressIndicator();
              //     } else if (snapshot.hasError) {
              //       return Text('ERROR: ${snapshot.error}');
              //     } else if (snapshot.hasData) {
              //       final List<String> imageUrls = snapshot.data!;
              //       return Padding(
              //         padding: const EdgeInsets.all(10),
              //         child: GridView.builder(
              //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //             crossAxisCount: 4,
              //             crossAxisSpacing: 10,
              //             mainAxisSpacing: 5,
              //             childAspectRatio: 735 / 1025,
              //           ),
              //           itemCount: imageUrls.length,
              //           itemBuilder: (context, index) {
              //             return GestureDetector(
              //               onTap: () {
              //                 CardInfo currentCard = CardInfo();
              //                 currentCard.setID(widget.collect.cardIds[index]);
              //                 Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                     builder: (context) => CardInfoScreen(index, widget.collect, widget.username),
              //                   ),
              //                 );
              //               },
              //               child: Image.network(
              //                 imageUrls[index],
              //               ),
              //             );
              //           },
              //         ),
              //       );
              //     } else {
              //       return const Text('No Data');
              //     }
              //   },
              // ),
            ],
          ),
        ),
    );
  }
}