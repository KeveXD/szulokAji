import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final String itemName;
  final VoidCallback onDelete;
  final VoidCallback onCheck;

  ListItem({
    required this.itemName,
    required this.onDelete,
    required this.onCheck,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(itemName),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: onDelete,
          ),
          Checkbox(
            value: false, // Itt állíthatod be az alapértelmezett értéket
            onChanged: (bool? isChecked) {
              onCheck();
            },
          ),
        ],
      ),
      onTap: () {
        // Itt hozzáadhatod az egyes listaelemekhez tartozó egyedi interakciókat vagy kezeléseket.
        print('Selected item: $itemName');
      },
    );
  }
}
