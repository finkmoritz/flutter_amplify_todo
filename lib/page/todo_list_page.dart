import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_todo/models/ModelProvider.dart';
import 'package:flutter_amplify_todo/page/edit_profile_page.dart';
import 'package:flutter_amplify_todo/page/todo_page.dart';
import 'package:flutter_amplify_todo/page/password_change_page.dart';

enum MenuOptions {
  editProfile,
  changePassword,
  signOut,
  deleteAccount,
}

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({super.key});

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  List<Todo> _todoList = [];

  @override
  void initState() {
    super.initState();
    _loadTodoList();
  }

  Future<void> _loadTodoList() async {
    _todoList = await Amplify.DataStore.query(Todo.classType);
    setState(() {});
  }

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
                value: MenuOptions.editProfile,
                child: Text('Edit Profile'),
              ),
              const PopupMenuItem(
                value: MenuOptions.changePassword,
                child: Text('Change Password'),
              ),
              const PopupMenuItem(
                value: MenuOptions.signOut,
                child: Text('Sign Out'),
              ),
              const PopupMenuItem(
                value: MenuOptions.deleteAccount,
                child: Text(
                  'Delete Account',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case MenuOptions.editProfile:
                  _editProfile();
                  break;
                case MenuOptions.changePassword:
                  _changePassword();
                  break;
                case MenuOptions.signOut:
                  _signOut();
                  break;
                case MenuOptions.deleteAccount:
                  _deleteAccount();
                  break;
                default:
                  throw Exception('Unknown MenuOption $value');
              }
            },
          ),
        ],
      ),
      body: _todoList.isEmpty
          ? const Center(
              child: Text('Congratulations, there is nothing left to do!'),
            )
          : ListView.builder(
              itemCount: _todoList.length,
              itemBuilder: (context, index) {
                var todo = _todoList[index];
                return ListTile(
                  title: Text(todo.name),
                  subtitle: Text(todo.description ?? ''),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createToDo,
        child: const Icon(Icons.add),
      ),
    );
  }

  _editProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EditProfilePage(),
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

  _deleteAccount() async {
    try {
      await Amplify.Auth.deleteUser();
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
      ));
    }
  }

  _createToDo() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ToDoPage(
          todo: Todo(name: ''),
        ),
      ),
    );
    _loadTodoList();
  }
}
