class Task {
  final String id;
  final String title;
  final String desc;
  final bool isDone;
  final bool isFav;

  Task({
    required this.id,
    required this.title,
    required this.desc,
    this.isDone = false,
    this.isFav = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'desc': desc,
      'isDone': isDone,
      'isFav': isFav,
    };
  }

  factory Task.fromMap(String id, Map<String, dynamic> map) {
    return Task(
      id: id,
      title: map['title'] ?? '',
      desc: map['desc'] ?? '',
      isDone: map['isDone'] ?? false,
      isFav: map['isFav'] ?? false,
    );
  }
}
