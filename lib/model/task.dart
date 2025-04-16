class Task {
  String title;
  bool isDone;

  Task({required this.title, this.isDone = false});

  // Optional: 保存や読み込みのための toMap/fromMap
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isDone': isDone,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'],
      isDone: map['isDone'] ?? false,
    );
  }
}
