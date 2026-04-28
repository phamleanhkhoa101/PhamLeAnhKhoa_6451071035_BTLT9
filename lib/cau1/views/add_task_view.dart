import 'package:flutter/material.dart';

import '../controllers/task_controller.dart';
import '../utils/app_snackbar.dart';

class AddTaskView extends StatefulWidget {
  const AddTaskView({
    super.key,
    required this.controller,
  });

  final TaskController controller;

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await widget.controller.addTask(_titleController.text);
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppSnackBar.show(context, error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Them cong viec - 6451071035')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Tieu de cong viec',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _saveTask(),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui long nhap tieu de cong viec';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isSaving ? null : _saveTask,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text(_isSaving ? 'Dang luu...' : 'Luu cong viec'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
