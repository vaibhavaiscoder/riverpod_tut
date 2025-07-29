import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'counterProvider.dart';

class CounterScreen extends ConsumerWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the counterProvider's state
    final counter = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Riverpod Counter')),
      body: Center(
        child: Text(
          'Counter value: $counter',
          style: TextStyle(fontSize: 24),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Update the state using ref.read
          ref.read(counterProvider.notifier).state++;
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
