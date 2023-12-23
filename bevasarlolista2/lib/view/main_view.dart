import 'package:flutter/material.dart';
import 'package:bevasarlolista2/view/listitem.dart';
import 'package:bevasarlolista2/model/main_view_model.dart';
import 'package:bevasarlolista2/data_model/list_item_data_model.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  MainViewModel viewModel = MainViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.loadItemsFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MainView'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ListItemDataModel>>(
              stream: viewModel.itemsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListItem(
                        itemName: snapshot.data![index].title,
                        onDelete: () {
                          viewModel
                              .deleteItem(snapshot.data![index].id.toString());
                        },
                        onCheck: () {
                          viewModel
                              .checkItem(snapshot.data![index].id.toString());
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                viewModel.showAddItemDialog(context);
              },
              child: Text('Add Item'),
            ),
          ),
        ],
      ),
    );
  }
}
