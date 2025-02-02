import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/counter_provider.dart';

class CounterScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterStateProvider);
    final numberNotifierState = ref.watch(numberNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Counter: $counter',
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: numberNotifierState.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              numberNotifierState[index].toString(),
              style: TextStyle(fontSize: 24),
            ),
          );
        },
      ),

      floatingActionButton: floatingButtons(ref),
    );
  }

  // Row floatingButtons(WidgetRef ref) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: [
  //       FloatingActionButton(
  //         heroTag: 'decrement', // Assign a unique heroTag
  //         onPressed: () {
  //           ref.read(counterStateProvider.notifier).state--;
  //         },
  //         child: Icon(Icons.remove),
  //       ),
  //       FloatingActionButton(
  //         heroTag: 'increment', // Assign a unique heroTag
  //         onPressed: () {
  //           ref.read(counterStateProvider.notifier).state++;
  //         },
  //         child: Icon(Icons.add),
  //       ),
  //     ],
  //   );
  // }

  Row floatingButtons(WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingActionButton(
          heroTag: 'decrement',
          onPressed: () {
            ref.read(counterStateProvider.notifier).state--;
          },
          child: Icon(Icons.remove),
        ),
        FloatingActionButton(
          heroTag: 'increment',
          onPressed: () {
            // Add the current counter value to the list
            final counter = ref.read(counterStateProvider);
            ref.read(numberNotifierProvider.notifier).add(counter);
            ref.read(counterStateProvider.notifier).state++;
          },
          child: Icon(Icons.add),
        ),
      ],
    );
  }

}
