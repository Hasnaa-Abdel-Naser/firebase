import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statemanagementtest/todo.dart';

class CreateTodo extends StatefulWidget {
  const CreateTodo({Key? key}) : super(key: key);

  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  final titleCont = TextEditingController();
  final detailsCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Todo'),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              'Title',
              style: TextStyle(
                fontSize: 28,
              ),
            ),
            TextField(
              controller: titleCont,
              style: TextStyle(
                fontSize: 28,
              ),
            ),
            Text(
              'Details',
              style: TextStyle(
                fontSize: 28,
              ),
            ),
            TextField(
              controller: detailsCont,
              style: TextStyle(
                fontSize: 28,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<Todo>(
                  context,
                  listen: false,
                ).addTaskToList(
                  titleCont.text,
                  detailsCont.text,
                );
                Navigator.pop(context);
              },
              child: Text(
                'Add Todo',
                style: TextStyle(
                  fontSize: 28,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
