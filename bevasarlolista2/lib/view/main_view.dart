import 'package:flutter/material.dart';
import 'package:bevasarlolista2/view/listitem.dart';
import 'package:bevasarlolista2/viewmodel/main_view_model.dart';
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
        title: Text('Bevásárlólista'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
                            viewModel.deleteItem(snapshot.data![index].id ?? 0);
                          },
                          onCheck: () {
                            //viewModel.checkItem(snapshot.data![index].id ?? 0);
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
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                viewModel.showAddItemDialog(context);
                //viewModel.loadItemsFromFirebase(context)
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('Új elem', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
