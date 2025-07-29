## 🚀 Getting Started

### 📌 Core Riverpod Usage

| Goal                                       | Use            |
| ------------------------------------------ | -------------- |
| Rebuild widget on change                   | `ref.watch()`  |
| Trigger logic (e.g. on tap)                | `ref.read()`   |
| React outside of build (e.g. side effects) | `ref.listen()` |

---

## 🧠 Common Riverpod Provider Types

| Provider Type            | Description                                                                 |
| ------------------------ | --------------------------------------------------------------------------- |
| `Provider`               | For read-only values (pure dependencies).                                   |
| `StateProvider`          | For simple mutable state (like `setState`).                                 |
| `StateNotifierProvider`  | For complex state with business logic using `StateNotifier`.                |
| `ChangeNotifierProvider` | For using Flutter’s built-in `ChangeNotifier`.                              |
| `FutureProvider`         | For asynchronous values (e.g., fetching data from API).                     |
| `StreamProvider`         | For working with real-time data streams.                                    |
| `AutoDispose` modifier   | Automatically disposes provider when no longer in use (memory efficiency). |

---

## 🔄 Example Usage

### StateProvider Example

```dart
final counterProvider = StateProvider<int>((ref) => 0);

// In a widget:
final count = ref.watch(counterProvider);
