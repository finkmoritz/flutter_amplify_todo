import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_todo/page/password_change_page.dart';

enum MenuOptions {
  changePassword,
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
                value: MenuOptions.changePassword,
                child: Text('Change Password'),
              ),
              const PopupMenuItem(
                value: MenuOptions.signOut,
                child: Text('Sign Out'),
              ),
            ],
            onSelected: (value) {
              switch(value) {
                case MenuOptions.changePassword:
                  _changePassword();
                  break;
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

  _changePassword() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PasswordChangePage(),
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
