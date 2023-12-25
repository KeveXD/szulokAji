import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bevasarlolista2/data_model/list_item_data_model.dart';
import 'dart:async';

class MainViewModel {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference firebaseItemsCollection =
      FirebaseFirestore.instance.collection('items');

  final _listItemsController =
      StreamController<List<ListItemDataModel>>.broadcast();

  Stream<List<ListItemDataModel>> get itemsStream =>
      _listItemsController.stream;

  Future<void> loadItemsFromFirebase() async {
    try {
      var snapshot = await firebaseItemsCollection.get();
      var items = snapshot.docs
          .map((doc) =>
              ListItemDataModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      // Frissítsük a streamet
      _listItemsController.sink.add(items);
    } catch (e) {
      print('Error loading items: $e');
    }
  }

  Future<void> addItemToFirebase(ListItemDataModel item) async {
    await firebaseItemsCollection.add(item.toMap());
  }

  Future<void> deleteItem(int id) async {
    // Keresd meg az elemet az ID alapján
    var doc =
        await firebaseItemsCollection.where('id', isEqualTo: id).limit(1).get();

    // Töröld az elemet, ha találtál egyezést
    if (doc.docs.isNotEmpty) {
      await doc.docs.first.reference.delete();
    }

    // Frissítsük a streamet az elemek nélkül
    await loadItemsFromFirebase();
  }

  Future<void> checkItem(String docId) async {
    await firebaseItemsCollection.doc(docId).update({'isChecked': true});
  }

  Future<void> showAddItemDialog(BuildContext context) async {
    TextEditingController titleController = TextEditingController();
    TextEditingController commentController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Item'),
          content: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: commentController,
                decoration: InputDecoration(labelText: 'Comment'),
              ),
            ],
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
                ListItemDataModel newItem = ListItemDataModel(
                  id: await newId(),
                  date: DateTime.now(),
                  title: titleController.text,
                  comment: commentController.text,
                  isChecked: false,
                );

                await addItemToFirebase(newItem);
                await loadItemsFromFirebase();
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<int?> newId() async {
    try {
      var snapshot = await firebaseItemsCollection.get();
      var existingIds = snapshot.docs
          .map((doc) =>
              ListItemDataModel.fromMap(doc.data() as Map<String, dynamic>).id)
          .whereType<int>() // Szűrjük ki a null értékeket
          .toList();

      int newId = 0;
      while (existingIds.contains(newId)) {
        newId++;
      }
      //print("lol $newId");
      return newId;
    } catch (e) {
      print('Error generating new ID: $e');
      return null; // Alapértelmezett érték, ha hiba történik
    }
  }

  void dispose() {
    _listItemsController.close();
  }
}
