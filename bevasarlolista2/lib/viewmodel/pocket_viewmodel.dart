import 'dart:async';

import 'package:bevasarlolista2/data_model/pocket_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PocketViewModel {
  final BuildContext context;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference firebaseItemsCollection =
      FirebaseFirestore.instance.collection('pockets');

  final pocketsController = StreamController<List<PocketDataModel>>.broadcast();

  Stream<List<PocketDataModel>> get pocketStream => pocketsController.stream;

  PocketViewModel({required this.context});

  Future<void> addNewPocket(String name) async {
    int? id = await newId();
    PocketDataModel newPocket =
        PocketDataModel(id: id, name: name, special: true);
    await firebaseItemsCollection.add(newPocket.toMap());
    await loadPockets();
  }

  Future<void> loadPockets() async {
    try {
      var snapshot = await firebaseItemsCollection.get();
      var items = snapshot.docs
          .map((doc) =>
              PocketDataModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      // Hozzunk létre egy új "Összes" pocket-et, és adjuk hozzá az items listához
      //int? newId2= await newId();
      PocketDataModel allPocket =
          PocketDataModel(id: 333, name: 'Összes', special: true);
      items.add(allPocket);

      // Frissítsük a streamet
      pocketsController.sink.add(items);
    } catch (e) {
      print('Error loading items: $e');
    }
  }

  Future<int?> newId() async {
    try {
      var snapshot = await firebaseItemsCollection.get();
      var existingIds = snapshot.docs
          .map((doc) =>
              PocketDataModel.fromMap(doc.data() as Map<String, dynamic>).id)
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

  Future<void> deletePocket(int id) async {
    // Keresd meg az elemet az ID alapján
    var doc =
        await firebaseItemsCollection.where('id', isEqualTo: id).limit(1).get();

    // Töröld a zsebet, ha találtál egyezést
    if (doc.docs.isNotEmpty) {
      await doc.docs.first.reference.delete();
    }

    await loadPockets();
  }
}
