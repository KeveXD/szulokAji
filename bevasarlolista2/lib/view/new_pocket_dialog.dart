import 'package:bevasarlolista2/viewmodel/pocket_viewmodel.dart';
import 'package:flutter/material.dart';

class NewPocketDialog extends StatefulWidget {
  final VoidCallback onAddNewPocket;

  NewPocketDialog({required this.onAddNewPocket});

  @override
  _NewPocketDialogState createState() => _NewPocketDialogState();
}

class _NewPocketDialogState extends State<NewPocketDialog> {
  final TextEditingController nameController = TextEditingController();
  late final PocketViewModel viewModel;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _showDialog(context);
    });
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        viewModel = PocketViewModel(context: context);
        return AlertDialog(
          title: Text('Új Zseb hozzáadása'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Név'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Mégsem'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Hozzáad'),
              onPressed: () async {
                viewModel.addNewPocket(nameController.text);

                widget.onAddNewPocket(); // Hívjuk meg a külső callbacket
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
