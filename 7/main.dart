import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statemanagementtest/create_todo.dart';
import 'package:statemanagementtest/todo.dart';

void main() {
  // Todo todo = Todo(); // shared Object
  runApp(ChangeNotifierProvider(
    create: (_) => Todo(),
    child: MaterialApp(
      initialRoute: '/home',
      routes: {
        '/home': (_) => MyApp(), // UI  -> MyApp()
        '/todo': (_) => CreateTodo(), // UI  -> CreateTodo()
      },
      // routes: {
      //   '/home': (_) => ChangeNotifierProvider(
      //         create: (_) => todo, // Data -> Todo()
      //         child: MyApp(), // UI  -> MyApp()
      //       ),
      //   '/todo': (_) => ChangeNotifierProvider(
      //         create: (_) => todo, // Data -> Todo()
      //         child: CreateTodo(), // UI  -> CreateTodo()
      //       ),
      // },
    ),
  ));
}

// State management
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        child: Consumer<Todo>(
          builder: (context, todo, child) => ListView.builder(
            itemCount: todo.tasks.length,
            itemBuilder: (context, index) => Container(
                child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 8,
              ),
              title: Text(
                todo.tasks[index].title,
                style: TextStyle(
                  fontSize: 28,
                ),
              ),
              subtitle: Text(
                todo.tasks[index].details,
                style: TextStyle(
                  fontSize: 28,
                ),
              ),
              trailing: Icon(
                Icons.check_circle,
                size: 36,
                color: Colors.green,
              ),
            )),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/todo');
        },
        child: Icon(
          Icons.add,
          size: 40,
        ),
      ),
    );
  }
}
