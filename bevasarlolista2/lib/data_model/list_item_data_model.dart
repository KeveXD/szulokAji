class ListItemDataModel {
  int? id;
  DateTime date;
  String title;
  String comment;
  bool isChecked;

  ListItemDataModel({
    this.id,
    required this.date,
    required this.title,
    required this.comment,
    required this.isChecked,
  });
}
