import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/task.dart';
import '../provider/app_state.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final _tasks = appState.tasks;
    final _controller = TextEditingController();

    void addTask() {
      final text = _controller.text.trim();
      if (text.isEmpty) return;
      appState.addTask(text);
      _controller.clear();
    }

  void _toggleTask(int index) {
    setState(() {
      appState.toggleTask(index);
    });
  }

  void _deleteTask(int index) {
    setState(() {
      appState.removeTask(index);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

    return Scaffold(
      appBar: AppBar(title: const Text('目標（ToDo）管理'),backgroundColor: Theme.of(context).colorScheme.inversePrimary,),
      body: 
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'タスクを入力',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: addTask,
                  child: const Text('追加'),
                ),
              ],
            ),
            const SizedBox(height: 16),
              Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return Card(
                    color: task.isDone? Colors.amber : Colors.white,
                    child: ListTile(
                      leading: Checkbox(
                        value: task.isDone,
                        onChanged: (_) => _toggleTask(index),
                      ),
                      title: Text(
                        task.title,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteTask(index),
                      ),
                    ),
                  );
                },
              ),
            ),
            ]),
      ),
    );
  }
}
