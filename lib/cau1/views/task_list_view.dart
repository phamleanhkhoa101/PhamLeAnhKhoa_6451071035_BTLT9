import 'package:flutter/material.dart';

import '../controllers/task_controller.dart';
import '../data/models/task_model.dart';
import '../utils/app_snackbar.dart';
import '../widgets/task_item.dart';
import 'add_task_view.dart';

class TaskListView extends StatefulWidget {
  const TaskListView({super.key});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  final TaskController _controller = TaskController();

  Future<void> _openAddTaskScreen() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddTaskView(controller: _controller),
      ),
    );
  }

  Future<void> _toggleTask(TaskModel task, bool value) async {
    try {
      await _controller.updateTaskStatus(task, value);
    } catch (_) {
      if (!mounted) {
        return;
      }
      AppSnackBar.show(
        context,
        'Khong the cap nhat trang thai cong viec.',
      );
    }
  }

  Future<void> _deleteTask(String taskId) async {
    try {
      await _controller.deleteTask(taskId);
      if (!mounted) {
        return;
      }
      AppSnackBar.show(context, 'Da xoa cong viec.');
    } catch (_) {
      if (!mounted) {
        return;
      }
      AppSnackBar.show(context, 'Khong the xoa cong viec.');
    }
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.playlist_add_check_circle_outlined, size: 72),
            SizedBox(height: 12),
            Text(
              'Chua co cong viec nao.\nNhan nut + de them cong viec moi.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sach cong viec - 6451071035'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<TaskModel>>(
        stream: _controller.streamTasks(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Khong the tai du lieu tu Firestore.'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final tasks = snapshot.data ?? [];
          if (tasks.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 10, bottom: 100),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];

              return Dismissible(
                key: ValueKey(task.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) => _deleteTask(task.id),
                child: TaskItem(
                  task: task,
                  onChanged: (value) => _toggleTask(task, value),
                  onDelete: () => _deleteTask(task.id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTaskScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}
