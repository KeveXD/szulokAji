import 'package:flutter/material.dart';

class ListItem extends StatefulWidget {
  final String itemName;
  final VoidCallback onDelete;
  final Function(bool) onCheck; // Módosítottuk a típust

  ListItem({
    required this.itemName,
    required this.onDelete,
    required this.onCheck,
  });

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(
          widget.itemName,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: widget.onDelete,
            ),
            Checkbox(
              value: isChecked,
              onChanged: (bool? value) async {
                setState(() {
                  isChecked = value ?? false;
                });
                widget
                    .onCheck(isChecked); // Itt továbbítjuk az isChecked értéket
              },
            ),
          ],
        ),
        onTap: () {
          // Itt hozzáadhatod az egyes listaelemekhez tartozó egyedi interakciókat vagy kezeléseket.
          print('Selected item: ${widget.itemName}');
        },
      ),
    );
  }
}
