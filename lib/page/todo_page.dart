import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_todo/models/Todo.dart';

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
  late TextEditingController _nameTextController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameTextController = TextEditingController(text: widget.todo.name);
    _descriptionController = TextEditingController(text: widget.todo.description);
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    _descriptionController.dispose();
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
              children: [
                TextFormField(
                  controller: _nameTextController,
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
        await Amplify.DataStore.save(widget.todo.copyWith(
          name: _nameTextController.text.trim(),
          description: _descriptionController.text.trim(),
        )).then((_) => Navigator.pop(context));
      } on DataStoreException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message),
        ));
      }
    }
  }
}
