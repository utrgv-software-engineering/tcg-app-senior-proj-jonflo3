import 'package:flutter/material.dart';
import 'package:tcg_app_sp/models/collection.dart';
import 'package:tcg_app_sp/screens/deck_construction_menu_screen.dart';
import 'package:tcg_app_sp/screens/menu_screen.dart';

class DeckBuilderScreen extends StatefulWidget{
  final Collection collect;

  const DeckBuilderScreen(this.collect, {super.key});
  @override
  DeckBuilderScreenState createState() => DeckBuilderScreenState();
}

class DeckBuilderScreenState extends State<DeckBuilderScreen> {
  List<String> deckNames = [];
  bool isListEmpty = true;

  @override
  void initState() {
    super.initState();
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
        actions: [
          
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
                    builder: (context) => DeckConstructionMenuScreen(widget.collect),
                  ));
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF404040)), 
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(10)), 
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
        : ListView.builder(
            itemCount: deckNames.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(deckNames[index]),
                onTap: () {
                  
                },
              );
            },
          ),
    );
  }
}
