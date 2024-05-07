import 'package:flutter/material.dart';
import 'package:tcg_app_sp/screens/card_info_screen.dart';
import 'package:tcg_app_sp/models/collection.dart';
import 'package:tcg_app_sp/screens/search_card_screen.dart';
import 'package:tcg_app_sp/SQLite/sqlite.dart';
import 'package:tcg_app_sp/screens/menu_screen.dart';

class CollectionScreen extends StatefulWidget {
  final Collection collect;
  

  const CollectionScreen(this.collect, {super.key});

  @override
  CollectionScreenState createState() => CollectionScreenState();
}

class CollectionScreenState extends State<CollectionScreen> {
  List<Map<String,dynamic>> cardList = [];

  @override
  void initState() {
    super.initState();
  }

  Map<String,dynamic> fetchCardInfo(String id) {
    Map<String,dynamic> cardInfo;
    cardInfo = widget.collect.allCards.firstWhere((element) => element['id'] == id);

   return cardInfo;
  }

  Future<List<Map<String, dynamic>>> updateList(String user) async {
    List<Map<String, dynamic>> cL = await DataBaseHelper().listforColScreen(user);
    return cL;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF404040), 
        elevation: 0, 
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (context) => MenuScreen(widget.collect),));
            // Navigator.pop(context);
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: updateList(widget.collect.username),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if(snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> cL = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 5,
                  childAspectRatio: 735 / 1025,
                ),
                itemCount: cL.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Map<String,dynamic> cardInfo = fetchCardInfo(cL[index]['cardID']);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CardInfoScreen(cardInfo, widget.collect),
                        ),
                      );
                      //print(imgURL);
                    },
                    child: Image.network(
                      cL[index]['imgURL'],
                    ),
                  );
                },
              ),
            );
          
          }
        },
      ),
      
      
      /*Center(
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
      ),*/
    );
  }
}


