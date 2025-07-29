import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodbeginner/todo/toDoModel.dart';
import 'package:riverpodbeginner/todo/toDoProvider.dart';

class TodoPage extends ConsumerWidget {
  TodoPage({super.key});

  final titleController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);

    return Scaffold(
      backgroundColor: Colors.greenAccent,
      appBar: AppBar(title: const Text("TODO"),backgroundColor: Colors.greenAccent,),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          onPressed: () {
            final title = titleController.text.trim();
            if (title.isNotEmpty) {
              final newTask = Tasks(
                id: DateTime.now().microsecondsSinceEpoch.toString(),
                title: title,
              );
              ref.read(taskProvider.notifier).addTask(newTask);
              titleController.clear();
            }
          },
          child: const Text('ADD TASK'),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (BuildContext context, int index) {
                final task = tasks[index];
                return ListTile(
                  leading: const Icon(Icons.list),
                  title: Text(task.title),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      ref.read(taskProvider.notifier).removeTask(task.id);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



