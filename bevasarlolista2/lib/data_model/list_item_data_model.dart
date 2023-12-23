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

  ListItemDataModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        date = DateTime.parse(map['date']),
        title = map['title'],
        comment = map['comment'],
        isChecked = map['isChecked'];

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'date': date.toIso8601String(),
      'title': title,
      'comment': comment,
      'isChecked': isChecked,
    };
  }
}
