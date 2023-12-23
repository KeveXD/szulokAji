import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bevasarlolista2/data_model/list_item_data_model.dart';
import 'dart:async';

class MainViewModel {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference _itemsCollection =
      FirebaseFirestore.instance.collection('items');

  // Hozzunk létre egy StreamController-t a listaelemek kezeléséhez
  final _itemsController =
      StreamController<List<ListItemDataModel>>.broadcast();

  // Definiáljuk a stream-et, amely figyeli a listaelemeket
  Stream<List<ListItemDataModel>> get itemsStream => _itemsController.stream;

  Future<void> loadItemsFromFirebase() async {
    try {
      var snapshot = await _itemsCollection.get();
      var items = snapshot.docs
          .map((doc) =>
              ListItemDataModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      // Frissítjük a streamet az új elemekkel
      _itemsController.add(items);
    } catch (e) {
      print('Error loading items: $e');
    }
  }

  Future<void> addItemToFirebase(ListItemDataModel item) async {
    await _itemsCollection.add(item.toMap());
  }

  Future<void> deleteItem(String docId) async {
    await _itemsCollection.doc(docId).delete();
  }

  Future<void> checkItem(String docId) async {
    await _itemsCollection.doc(docId).update({'isChecked': true});
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
                  date: DateTime.now(),
                  title: titleController.text,
                  comment: commentController.text,
                  isChecked: false,
                );

                await addItemToFirebase(newItem);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Ne felejtsd el lezárni a StreamController-t, amikor már nincs rá szükség
  void dispose() {
    _itemsController.close();
  }
}
