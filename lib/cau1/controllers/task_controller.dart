import '../data/models/task_model.dart';
import '../data/repository/task_repository.dart';

class TaskController {
  TaskController({TaskRepository? repository})
      : _repository = repository ?? TaskRepository();

  final TaskRepository _repository;

  Stream<List<TaskModel>> streamTasks() => _repository.getTasks();

  Future<void> addTask(String title) async {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      throw Exception('Vui long nhap tieu de cong viec.');
    }

    await _repository.addTask(trimmedTitle);
  }

  Future<void> updateTaskStatus(TaskModel task, bool value) {
    return _repository.toggleTask(task.id, value);
  }

  Future<void> deleteTask(String taskId) {
    return _repository.removeTask(taskId);
  }
}
