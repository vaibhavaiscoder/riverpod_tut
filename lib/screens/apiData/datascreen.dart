import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_tut/models/userModel.dart';
import 'package:riverpod_tut/providers/dataProvider.dart';

import 'createUserView.dart';

class DataScreen extends ConsumerWidget {
  const DataScreen({super.key});
  @override
  Widget build(BuildContext context, ref) {
    final asyncData = ref.watch(dataProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Async Data Example')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.3, // Set a fixed height
              child: CreateUserView(),
            ),
          ),
        ),
        child: Icon(Icons.add),
      ),
      body: Center(
        child: asyncData.when(
          data: (data) {
            List<Datum> userList = data.map((e) => e).toList();
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                          itemCount: userList.length,
                          itemBuilder: (_, index) {
                            final userData = userList[index];
                            return InkWell(
                              onTap: () => showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                      '${userData.firstName} ${userData.lastName}'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        radius: 40,
                                        backgroundImage:
                                            NetworkImage(userData.avatar),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                          'This is more information about ${userData.firstName}.'),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('Close'),
                                    ),
                                  ],
                                ),
                              ),
                              child: Card(
                                color: Colors.blue,
                                elevation: 4,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: ListTile(
                                  title: Text(userData.firstName),
                                  subtitle: Text(userData.lastName),
                                  trailing: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(userData.avatar),
                                  ),
                                ),
                              ),
                            );
                          }))
                ],
              ),
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => Text('Error: $error'),
        ),
      ),
    );
  }
}
