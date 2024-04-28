import 'package:flutter/material.dart';
import 'package:tcg_app_sp/models/collection.dart';
import 'package:tcg_app_sp/screens/deck_builder_screen.dart';
import 'package:tcg_app_sp/screens/menu_screen.dart';
import 'package:tcg_app_sp/screens/view_deck_screen.dart';

class DeckMenuScreen extends StatefulWidget{
  final Collection collect;

  const DeckMenuScreen(this.collect, {super.key});
  @override
  DeckMenuScreenState createState() => DeckMenuScreenState();
}

class DeckMenuScreenState extends State<DeckMenuScreen> {
  List<List<Map<String, dynamic>>> deckNames = [];
  bool isListEmpty = true;

  @override
  void initState() {
    super.initState();
    deckNames = widget.collect.myDecks.allDecks;
    if (deckNames.isEmpty) {
      setState(() {
        isListEmpty = true;
      });
    } else {
      setState(() {
        isListEmpty = false;
      });
    }
  }

  @override
  Widget build(BuildContext context){
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
          'Build a Deck',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, 
        actions: const [
          
        ]
      ),
      body: isListEmpty
        ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No Decks in you Collection',
                style: TextStyle(
                  fontSize: 25, 
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(
                    builder: (context) => DeckBuilderScreen(widget.collect),
                  ));
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(const Color(0xFF404040)), 
                  padding: WidgetStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(10)), 
                ),
                child: const Text('Add a Deck',
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 18, 
                  ),
                ),
              ),
            ],
          ),
          )
        : Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: deckNames.length + 1, // Add 1 for the button
                itemBuilder: (context, index) {
                  if (index < deckNames.length) {
                    return Center(
                      child: ListTile(
                        title: Text('Deck ${index + 1}'),
                        onTap: () {
                          Navigator.push(context,MaterialPageRoute(
                            builder: (context) => ViewDeckScreen(index, widget.collect),
                          ));
                        },
                      ),
                    );
                  } else {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,MaterialPageRoute(
                            builder: (context) => DeckBuilderScreen(widget.collect),
                          ));
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(const Color(0xFF404040)),
                          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(10)),
                        ),
                        child: const Text('Add Deck',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
    );
  }
}
