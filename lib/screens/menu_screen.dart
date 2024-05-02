import 'package:flutter/material.dart';
import 'package:tcg_app_sp/models/collection.dart';
import 'package:tcg_app_sp/models/decks.dart';
import 'package:tcg_app_sp/screens/deck_menu_screen.dart';
import 'package:tcg_app_sp/screens/log_in_screen.dart';
import 'package:tcg_app_sp/screens/collection_screen.dart';
import 'package:tcg_app_sp/screens/profile_screen.dart';
//import 'package:tcg_app_sp/screens/deck_builder_screen.dart';

class MenuScreen extends StatefulWidget {
  final Collection collect;
  final Decks deck;
  const MenuScreen(this.collect, this.deck, {super.key});

  @override
  MenuScreenState createState() => MenuScreenState();
}

class MenuScreenState extends State<MenuScreen> {
  

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF404040), 
        elevation: 0, 
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'PokeDecks',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, 
        actions: [
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
                          Navigator.push(context,MaterialPageRoute(builder: (context) => const LogInScreen()));
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
              Icons.exit_to_app,
              size: 35,
              color: Colors.white,
            ),
          ),
        ]
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (context) => CollectionScreen(widget.collect)),);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF404040),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), 
                ),
                minimumSize: const Size(200, 50),
              ),
              child: const Text('Collection',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeckMenuScreen(widget.collect)));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF404040),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), 
                ),
                minimumSize: const Size(200, 50),
              ),
              child: const Text('Decks',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen(widget.collect, widget.deck)));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF404040),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), 
                ),
                minimumSize: const Size(200, 50),
              ),
              child: const Text('Profile',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



