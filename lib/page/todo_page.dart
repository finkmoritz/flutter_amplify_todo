import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_todo/models/Todo.dart';

import '../models/Note.dart';

class ToDoPage extends StatefulWidget {
  final Todo todo;

  const ToDoPage({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _noteController;
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.todo.name);
    _descriptionController =
        TextEditingController(text: widget.todo.description);
    _noteController = TextEditingController(text: '');

    Amplify.DataStore.query(
      Note.classType,
      where: Note.TODO.eq(widget.todo.id),
    ).then((notes) {
      _notes = notes;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                      validator: _validate,
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      minLines: 5,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                    const SizedBox(height: 64.0,),
                    const Text(
                      'Work Log',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ] +
                  _notes
                      .map((note) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${note.timestamp.substring(11, 16)} - ${note.text}'),
                          ))
                      .toList() +
                  [
                    TextFormField(
                      controller: _noteController,
                      decoration: const InputDecoration(
                        labelText: 'Add Note',
                      ),
                    ),
                  ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _save,
        child: const Icon(Icons.save),
      ),
    );
  }

  String? _validate(String? name) {
    if (name?.isEmpty ?? true) {
      return 'Name cannot be empty';
    }
    return null;
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      try {
        Todo todo = widget.todo.copyWith(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
        );
        await Amplify.DataStore.save(todo).then((_) async {
          if (_noteController.text.isNotEmpty) {
            await Amplify.DataStore.save(Note(
              todo: todo,
              text: _noteController.text.trim(),
              timestamp: DateTime.now().toIso8601String(),
            )).then((_) => Navigator.pop(context));
          } else {
            Navigator.pop(context);
          }
        });
      } on DataStoreException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message),
        ));
      }
    }
  }
}
