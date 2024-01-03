import 'package:bevasarlolista2/data_model/pocket_data_model.dart';
import 'package:bevasarlolista2/view/new_pocket_dialog.dart';
import 'package:bevasarlolista2/view/pocket_listitem.dart';
import 'package:bevasarlolista2/viewmodel/pocket_viewmodel.dart';
import 'package:flutter/material.dart';

class PocketPage extends StatefulWidget {
  @override
  _PocketPageState createState() => _PocketPageState();
}

class _PocketPageState extends State<PocketPage> {
  late Future<List<PocketDataModel>> _pocketsFuture;
  late PocketViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = PocketViewModel(context: context);
    _pocketsFuture = viewModel.pocketStream.first;
    viewModel.loadPockets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zsebek'),
        centerTitle: true,
      ),
      body: Focus(
        child: FutureBuilder<List<PocketDataModel>>(
          future: _pocketsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return PocketListItem(
                    pocket: snapshot.data![index],
                    onDelete: () {
                      viewModel.deletePocket(snapshot.data![index].id ?? -1);
                    },
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNewPocketDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showNewPocketDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewPocketDialog(
          onAddNewPocket: () {},
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PocketPage(),
  ));
}
