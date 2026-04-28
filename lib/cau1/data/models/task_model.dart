import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  const TaskModel({
    required this.id,
    required this.title,
    required this.isDone,
    required this.createdAt,
  });

  final String id;
  final String title;
  final bool isDone;
  final Timestamp createdAt;

  factory TaskModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? <String, dynamic>{};

    return TaskModel(
      id: data['id'] as String? ?? document.id,
      title: data['title'] as String? ?? '',
      isDone: data['isDone'] as bool? ?? false,
      createdAt: data['createdAt'] as Timestamp? ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone,
      'createdAt': createdAt,
    };
  }

  TaskModel copyWith({
    String? id,
    String? title,
    bool? isDone,
    Timestamp? createdAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
