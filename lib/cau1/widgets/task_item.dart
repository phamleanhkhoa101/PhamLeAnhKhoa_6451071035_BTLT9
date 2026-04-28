import 'package:flutter/material.dart';

import '../data/models/task_model.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({
    super.key,
    required this.task,
    required this.onChanged,
    required this.onDelete,
  });

  final TaskModel task;
  final ValueChanged<bool> onChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: CheckboxListTile(
        value: task.isDone,
        onChanged: (value) => onChanged(value ?? false),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isDone ? TextDecoration.lineThrough : null,
            color: task.isDone ? Colors.grey : null,
          ),
        ),
        secondary: IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline),
          tooltip: 'Xoa cong viec',
        ),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}
