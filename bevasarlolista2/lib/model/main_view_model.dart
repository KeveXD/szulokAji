import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MainViewModel {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference _itemsCollection =
      FirebaseFirestore.instance.collection('items');

  Stream<List<String>> get itemsStream =>
      _itemsCollection.snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => doc['itemName'] as String).toList());

  Future<void> loadItemsFromFirebase() async {
    // Nem kell külön betölteni, mert a Stream automatikusan frissül a Firestore változásai alapján
  }

  Future<void> addItemToFirebase(String itemName) async {
    // Új elem hozzáadása Firestore-hoz
    await _itemsCollection.add({'itemName': itemName});
  }

  Future<void> deleteItem(int index) async {
    // Elem törlése Firestore-ból
    await _itemsCollection.doc(index.toString()).delete();
  }

  Future<void> checkItem(int index) async {
    // Elem státuszának módosítása Firestore-ban
    // Implementáció például _itemsCollection.doc(index.toString()).update({'checked': true})
  }

  Future<void> showAddItemDialog(BuildContext context) async {
    TextEditingController controller = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Item'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Item Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String newItemName = controller.text;
                await addItemToFirebase(newItemName);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
