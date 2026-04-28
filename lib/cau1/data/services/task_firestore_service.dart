import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/task_model.dart';

class TaskFirestoreService {
  TaskFirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _tasksCollection =>
      _firestore.collection('tasks');

  Stream<List<TaskModel>> streamTasks() {
    return _tasksCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(TaskModel.fromFirestore).toList(growable: false),
        );
  }

  Future<void> createTask(String title) async {
    final docRef = _tasksCollection.doc();
    final task = TaskModel(
      id: docRef.id,
      title: title,
      isDone: false,
      createdAt: Timestamp.now(),
    );

    await _runWithTimeout(
      () => docRef.set(task.toMap()),
      actionName: 'them cong viec',
    );
  }

  Future<void> updateTaskStatus({
    required String taskId,
    required bool isDone,
  }) {
    return _runWithTimeout(
      () => _tasksCollection.doc(taskId).update({'isDone': isDone}),
      actionName: 'cap nhat cong viec',
    );
  }

  Future<void> deleteTask(String taskId) {
    return _runWithTimeout(
      () => _tasksCollection.doc(taskId).delete(),
      actionName: 'xoa cong viec',
    );
  }

  Future<void> _runWithTimeout(
    Future<void> Function() action, {
    required String actionName,
  }) async {
    try {
      await action().timeout(const Duration(seconds: 15));
    } on FirebaseException catch (error) {
      debugPrint(
        'Firestore error [$actionName]: ${error.code} - ${error.message}',
      );
      throw Exception(_mapFirebaseError(error));
    } on TimeoutException {
      debugPrint('Firestore timeout while trying to $actionName.');
      throw Exception(
        'Ket noi Firestore bi qua thoi gian. Hay kiem tra mang, Firestore Database va rules.',
      );
    } catch (error) {
      debugPrint('Unexpected error [$actionName]: $error');
      rethrow;
    }
  }

  String _mapFirebaseError(FirebaseException error) {
    switch (error.code) {
      case 'permission-denied':
        return 'Firestore dang chan quyen ghi. Hay mo rules cho phep doc/ghi.';
      case 'unavailable':
        return 'Khong ket noi duoc toi Firestore. Hay kiem tra mang tren emulator.';
      case 'not-found':
        return 'Firestore Database chua duoc tao trong Firebase Console.';
      case 'failed-precondition':
        return 'Firestore chua san sang hoac dang thieu cau hinh can thiet.';
      default:
        return error.message ?? 'Da xay ra loi khi lam viec voi Firestore.';
    }
  }
}
