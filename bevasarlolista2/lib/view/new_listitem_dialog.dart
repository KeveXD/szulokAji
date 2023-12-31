import 'package:flutter/material.dart';
import 'package:bevasarlolista2/data_model/list_item_data_model.dart';
import 'package:bevasarlolista2/viewmodel/main_viewmodel.dart';

Future<void> showAddItemDialog2(BuildContext context) async {
  TextEditingController titleController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  MainViewModel viewModel = MainViewModel();

  // Definiálj egy FocusNode-ot a Termék mezőhöz
  FocusNode titleFocusNode = FocusNode();

  // Fókusz beállítása a Termék mezőre a dialógusablak megjelenése előtt
  FocusScope.of(context).requestFocus(titleFocusNode);

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Új elem hozzáadása'),
        content: Column(
          children: [
            TextField(
              controller: titleController,
              focusNode: titleFocusNode, // Adjuk hozzá a FocusNode-ot
              decoration: InputDecoration(
                labelText: 'Termék',
                prefixIcon: Icon(Icons.shopping_cart),
              ),
            ),
            TextField(
              controller: commentController,
              decoration: InputDecoration(
                labelText: 'Megjegyzés',
                prefixIcon: Icon(Icons.comment),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Mégsem',
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () async {
              ListItemDataModel newItem = ListItemDataModel(
                id: await viewModel.newId(),
                date: DateTime.now(),
                title: titleController.text,
                comment: commentController.text,
                isChecked: false,
              );

              await viewModel.addItemToFirebase(newItem);
              Navigator.of(context).pop(); // Dialógus ablak bezárása
            },
            child: Text(
              'Hozzáad',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      );
    },
  ).then((value) async {
    await viewModel.loadItemsFromFirebase();
  });
}
