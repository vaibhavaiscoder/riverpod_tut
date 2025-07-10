class Task {
  final String id;
  final String title;
  final String desc;
  final bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.desc,
    this.isDone = false,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'isDone': isDone,
    };
  }
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      desc: map['desc'] ?? '',
      isDone: map['isDone'] ?? false,
    );
  }
}
