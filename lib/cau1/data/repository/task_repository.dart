import '../models/task_model.dart';
import '../services/task_firestore_service.dart';

class TaskRepository {
  TaskRepository({TaskFirestoreService? service})
      : _service = service ?? TaskFirestoreService();

  final TaskFirestoreService _service;

  Stream<List<TaskModel>> getTasks() => _service.streamTasks();

  Future<void> addTask(String title) => _service.createTask(title);

  Future<void> toggleTask(String taskId, bool isDone) {
    return _service.updateTaskStatus(taskId: taskId, isDone: isDone);
  }

  Future<void> removeTask(String taskId) => _service.deleteTask(taskId);
}
