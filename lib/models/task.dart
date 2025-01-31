class Task {
  final int? id;
  final String title;
  final String description;
  DateTime? date;
  bool isCompleted;

  Task(
      {this.id,
      required this.date,
      required this.title,
      required this.description,
      required this.isCompleted});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'date': date?.toIso8601String() ?? "",
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
      id: map['id'],
      date: DateTime.parse(map['date']),
    );
  }
}
