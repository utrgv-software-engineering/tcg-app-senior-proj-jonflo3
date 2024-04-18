import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcg_app_sp/models/collection.dart';
import 'package:tcg_app_sp/screens/log_in_screen.dart';
import 'package:tcg_app_sp/screens/profile_screen.dart';
import 'package:tcg_app_sp/screens/search_card_screen.dart';
import 'package:tcg_app_sp/screens/card_info_screen.dart';
import 'package:tcg_app_sp/models/card.dart';

class CollectionScreen extends StatefulWidget {
  final Collection collect;

  const CollectionScreen(this.collect, {super.key});

  @override
  CollectionScreenState createState() => CollectionScreenState();
}

class CollectionScreenState extends State<CollectionScreen> {
  late Future<List<String>> futureImageUrls;

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
        elevation: 0, 
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          onPressed: () async {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => const ProfileScreen()
              )
            );
          },
          icon: const Icon(Icons.person),
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
              // Collection collect = Collection(cardIds: [], username: widget.username);
              // await collect.fetchUserData();
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => SearchCardScreen(widget.collect, widget.username),
              //   ),
              // );
            },
            icon: const Icon(
              Icons.add,
              size: 35,
              color: Colors.white,
            ),
          ),
          IconButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LogInScreen(),
                              ),
                            );
                          },
                          child: const Text("Yes"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("No"),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.logout,
                size: 35,
                color: Colors.white,
              ),
            ),
          ],
        ),
      // drawer: NavigationDrawer(collect: widget.collect),
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
                        // Collection collect = Collection(cardIds: [], username: widget.username);
                        // await collect.fetchUserData();
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
      ),
    );
  }
}


// class NavigationDrawer extends StatelessWidget {
//   final Collection collect;

//   const NavigationDrawer({super.key, required this.collect});

  
//   @override 
//   Widget build(BuildContext context) {
//     return Drawer(
//     child: SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: <Widget>[
//           buildHeader(context, collect),
//           buildMenuItems(context, collect),
//         ],
//       ),
//     ),
//   );
//   }

//   Widget buildHeader(BuildContext context, Collection collect) => Material(
//     color: const Color(0xFF404040),
//     child: InkWell(
//       onTap: () {},
//       child: Container(
//         padding: EdgeInsets.only(
//           top: 5 + MediaQuery.of(context).padding.top,
//           bottom: 15,
//           left: 15,
//         ),
//         child: Row(
//           children: [
//             const Icon(
//               Icons.account_circle,
//               size: 50,
//               color: Colors.white,
//             ),
//             const SizedBox(width: 5),
//             Text(
//             collect.getName(),
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//             )
//           ),
//           ]
//         )
//       )

//     )
//   );

//   Widget buildMenuItems(BuildContext context, Collection collect) => Column(
//     children: [
//       ListTile(
//         leading: const Icon(Icons.home_outlined),
//         title: const Text('Home'),
//         onTap: () {},
//       ),
//       ListTile(
//         title: const Text('Collection'),
//         onTap: () {},
//       ),
//       ListTile(
//         title: const Text('Build a Deck'),
//         onTap: () {
//           collect.getCollectionPrice();
//         },
//       ),
//       const Divider(), 
//       ListTile(
//         leading: const Icon(Icons.exit_to_app), 
//         title: const Text('Sign Out'),
//         onTap: () async {
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: const Text("Logout"),
//                 content: const Text("Are you sure you want to logout?"),
//                 actions: <Widget>[
//                   TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const LogInScreen(),
//                         ),
//                       );
//                     },
//                     child: const Text("Yes"),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: const Text("No"),
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       ),
//     ]
//   );

// }
