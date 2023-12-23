import 'package:flutter/material.dart';
import 'package:bevasarlolista2/view/listitem.dart';
import 'package:bevasarlolista2/model/main_view_model.dart';

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
            child: StreamBuilder<List<String>>(
              stream: viewModel.itemsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListItem(
                        itemName: snapshot.data![index],
                        onDelete: () {
                          viewModel.deleteItem(index);
                        },
                        onCheck: () {
                          viewModel.checkItem(index);
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
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
