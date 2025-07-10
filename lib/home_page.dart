import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_tut2/models/taskModel.dart';
import 'package:riverpod_tut2/providers/task_provider.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final taskProvider = ref.watch(taskStreamProvider);
        return taskProvider.when(
          data: (tasks) {
            return Scaffold(
              appBar: AppBar(title: Text('Task App')),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(controller: titleController),
                    TextField(controller: descController),
                    ElevatedButton(
                      onPressed: () {
                        final newTask = Task(
                          id: DateTime.now().microsecondsSinceEpoch.toString(),
                          title: titleController.text,
                          desc: descController.text,
                        );
                        ref.read(taskDBServiceProvider).addNewTask(newTask);
                      },
                      child: Text('Add Task'),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return ListTile(
                          title: Text(task.title),
                          subtitle: Text(task.desc),
                          leading: Checkbox(
                            value: task.isDone,
                            onChanged: (value) {
                              final updatedTask = Task(
                                id: task.id,
                                title: task.title,
                                desc: task.desc,
                                isDone: !task.isDone,
                              );
                              ref
                                  .read(taskDBServiceProvider)
                                  .updateTask(updatedTask);
                            },
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              ref.read(taskDBServiceProvider).deleteTask(task);
                            },
                            icon: Icon(Icons.delete),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          error: (error, stackTrace) {
            return Scaffold(body: Center(child: Text('Error $error')));
          },
          loading: () =>
              Scaffold(body: Center(child: CircularProgressIndicator())),
        );
      },
    );
  }
}
