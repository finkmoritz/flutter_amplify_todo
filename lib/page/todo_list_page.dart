import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

enum MenuOptions {
  signOut,
}

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({super.key});

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo List'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.person),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: MenuOptions.signOut,
                child: Text('Sign Out'),
              ),
            ],
            onSelected: (value) {
              switch(value) {
                case MenuOptions.signOut:
                  _signOut();
                  break;
                default:
                  throw Exception('Unknown MenuOption $value');
              }
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Congratulations, there is nothing left to do!'),
      ),
    );
  }

  _signOut() async {
    try {
      await Amplify.Auth.signOut();
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
      ));
    }
  }
}
