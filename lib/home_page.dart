import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_tut2/models/taskModel.dart';
import 'package:riverpod_tut2/providers/task_provider.dart';
import 'package:riverpod_tut2/routes/app_routes.dart';

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
              appBar: AppBar(title: Text('Task App'),actions: [
                IconButton(onPressed: (){
                  context.push(Routes.FAVORITES);
                }, icon: Icon(Icons.favorite)),              IconButton(onPressed: (){
                  context.push(Routes.VIDEODETAILS);
                }, icon: Icon(Icons.info)),
              ],),
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
                        return GestureDetector(
                          onTap: () {
                            final updatedTitleController = TextEditingController(text: task.title);
                            final updatedDescController = TextEditingController(text: task.desc);

                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Edit Task'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        controller: updatedTitleController,
                                        decoration: InputDecoration(labelText: 'Title'),
                                      ),
                                      TextFormField(
                                        controller: updatedDescController,
                                        decoration: InputDecoration(labelText: 'Description'),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        final updatedTask = Task(
                                          id: task.id,
                                          title: updatedTitleController.text,
                                          desc: updatedDescController.text,
                                          isDone: task.isDone,
                                          isFav: task.isFav,
                                        );

                                        ref.read(taskDBServiceProvider).updateTask(updatedTask);
                                        Navigator.of(context).pop(); // Close dialog
                                      },
                                      child: const Text('Update'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },

                          child: Dismissible(

                            key: ValueKey(task.id),
                            direction: DismissDirection.endToStart, // swipe left to right
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20),
                              color: Colors.red,
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (_) {
                              ref.read(taskDBServiceProvider).deleteTask(task);
                            },
                            child: ListTile(
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
                                    isFav: task.isFav,
                                  );
                                  ref
                                      .read(taskDBServiceProvider)
                                      .updateTask(updatedTask);
                                },
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  final updatedTask = Task(
                                    id: task.id,
                                    title: task.title,
                                    desc: task.desc,
                                    isDone: task.isDone,
                                    isFav: !task.isFav,
                                  );
                                  ref.read(taskDBServiceProvider).updateTask(updatedTask);
                                },
                                icon: task.isFav ? Icon(Icons.favorite,color: Colors.red,) : Icon(Icons.favorite_border),
                              ),
                            ),
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
