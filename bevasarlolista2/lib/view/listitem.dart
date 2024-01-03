import 'package:flutter/material.dart';
import 'package:bevasarlolista2/data_model/list_item_data_model.dart';

class ListItem extends StatefulWidget {
  final ListItemDataModel listItem;
  final VoidCallback onDelete;
  final Function(bool) onCheck;

  ListItem({
    required this.listItem,
    required this.onDelete,
    required this.onCheck,
  });

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  late bool isChecked; // Módosítottuk a típust

  @override
  void initState() {
    super.initState();
    // Inicializáljuk az isChecked értékét a listaelem alapján
    isChecked = widget.listItem.isChecked ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(
          widget.listItem.title,
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
                widget.onCheck(isChecked);
              },
            ),
          ],
        ),
        onTap: () {
          // Itt hozzáadhatod az egyes listaelemekhez tartozó egyedi interakciókat vagy kezeléseket.
          print('Selected item: ${widget.listItem.title}');
        },
      ),
    );
  }
}
