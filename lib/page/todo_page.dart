import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_todo/models/LabelColor.dart';
import 'package:flutter_amplify_todo/models/Todo.dart';

import '../models/Label.dart';
import '../models/Note.dart';
import '../models/TodoLabel.dart';

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
  List<Label> _allLabels = [];
  List<String> _selectedLabelIDs = [];

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

    Amplify.DataStore.query(Label.classType).then((labels) {
      _allLabels = labels;
      setState(() {});
    });

    Amplify.DataStore.query(
      TodoLabel.classType,
      where: TodoLabel.TODO.eq(widget.todo.id),
    ).then((todoLabels) {
      _selectedLabelIDs.addAll(todoLabels.map((todoLabel) => todoLabel.label.id));
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
                    const SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _allLabels.map((label) {
                        var color = MaterialStateProperty.all(
                          _getColor(label.color),
                        );
                        return _selectedLabelIDs.contains(label.id)
                            ? ElevatedButton(
                                onPressed: () {
                                  _selectedLabelIDs.remove(label.id);
                                  setState(() {});
                                },
                                style: ButtonStyle(backgroundColor: color),
                                child: Text(label.name),
                              )
                            : OutlinedButton(
                                onPressed: () {
                                  _selectedLabelIDs.add(label.id);
                                  setState(() {});
                                },
                                style: ButtonStyle(foregroundColor: color),
                                child: Text(label.name),
                              );
                      }).toList(),
                    ),
                    const SizedBox(
                      height: 64.0,
                    ),
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
                            child: Text(
                                '${note.timestamp.substring(11, 16)} - ${note.text}'),
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

        await Amplify.DataStore.save(todo);

        // Delete old labels
        var todoLabels = await Amplify.DataStore.query(
          TodoLabel.classType,
          where: TodoLabel.TODO.eq(todo.id),
        );
        for (var todoLabel in todoLabels) {
          await Amplify.DataStore.delete(todoLabel);
        }

        // Insert selected labels
        for (var label in _allLabels) {
          if (_selectedLabelIDs.contains(label.id)) {
            await Amplify.DataStore.save(TodoLabel(todo: todo, label: label));
          }
        }

        if (_noteController.text.isNotEmpty) {
          await Amplify.DataStore.save(Note(
            todo: todo,
            text: _noteController.text.trim(),
            timestamp: DateTime.now().toIso8601String(),
          ));
        }

        Navigator.pop(context);
      } on DataStoreException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message),
        ));
      }
    }
  }

  Color _getColor(LabelColor labelColor) {
    switch (labelColor) {
      case LabelColor.RED:
        return Colors.red;
      case LabelColor.GREEN:
        return Colors.green;
      case LabelColor.BLUE:
        return Colors.blue;
    }
  }
}
