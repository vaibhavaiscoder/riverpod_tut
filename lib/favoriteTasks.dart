import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_tut2/providers/task_provider.dart';

import 'models/taskModel.dart';

class FavoriteTasks extends StatelessWidget {
  const FavoriteTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final taskProvider = ref.watch(favTaskStreamProvider);
        return taskProvider.when(
          data: (tasks) {
            return Scaffold(
              appBar: AppBar(title: Text('Favorite Tasks')),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child:  ListView.builder(
                  shrinkWrap: true,
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Dismissible(
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
                    );
                  },
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
