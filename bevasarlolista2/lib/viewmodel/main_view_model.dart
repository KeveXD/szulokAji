import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bevasarlolista2/data_model/list_item_data_model.dart';
import 'dart:async';
import 'package:bevasarlolista2/view/new_listitem_dialog.dart';

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
    await loadItemsFromFirebase();
  }

  Future<void> deleteItem(int id) async {
    // Keresd meg az elemet az ID alapján
    var doc =
        await firebaseItemsCollection.where('id', isEqualTo: id).limit(1).get();

    // Töröld az elemet, ha találtál egyezést
    if (doc.docs.isNotEmpty) {
      await doc.docs.first.reference.delete();
    }

    await loadItemsFromFirebase();
  }

  Future<void> checkItem(int itemId, bool isChecked) async {
    try {
      // Keresd meg az elemet az ID alapján
      var doc = await firebaseItemsCollection
          .where('id', isEqualTo: itemId)
          .limit(1)
          .get();

      // Frissítsd az elemet, ha találtál egyezést
      if (doc.docs.isNotEmpty) {
        await doc.docs.first.reference.update({'isChecked': isChecked});
      }

      // Frissítsük a streamet az elemekkel
      await loadItemsFromFirebase();
    } catch (e) {
      print('Error updating item: $e');
    }
  }

  Future<void> showAddItemDialog(BuildContext context) async {
    await showAddItemDialog2(context);
    loadItemsFromFirebase();
  }

  Future<void> updateItemInFirebase(ListItemDataModel updatedItem) async {
    try {
      // Keresd meg az elemet az ID alapján
      var doc = await firebaseItemsCollection
          .where('id', isEqualTo: updatedItem.id)
          .limit(1)
          .get();

      // Frissítsd az elemet, ha találtál egyezést
      if (doc.docs.isNotEmpty) {
        await doc.docs.first.reference.update(updatedItem.toMap());
      }

      // Frissítsük a streamet az elemekkel
      await loadItemsFromFirebase();
    } catch (e) {
      print('Error updating item: $e');
    }
  }

  Future<int?> newId() async {
    try {
      var snapshot = await firebaseItemsCollection.get();
      var existingIds = snapshot.docs
          .map((doc) =>
              ListItemDataModel.fromMap(doc.data() as Map<String, dynamic>).id)
          .whereType<int>()
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
