import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_tut/providers/dataProvider.dart';

class CreateUserView extends ConsumerWidget {
  CreateUserView({super.key});

  final nameController = TextEditingController();
  final jobController = TextEditingController();

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Create User')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: jobController,
              decoration: InputDecoration(labelText: 'Job'),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text;
                final job = jobController.text;
                await ref
                    .read(userAddProvider.notifier)
                    .createUser(name, job)
                    .then((_) {
                  // Refresh the data after creating a user
                  ref.refresh(dataProvider);
                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User created successfully!')),
                  );
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to create user: $error')),
                  );
                });
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
