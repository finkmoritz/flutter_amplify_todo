import 'dart:async';

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
  StreamSubscription<QuerySnapshot<Todo>>? _subscription;
  List<Todo> _todoList = [];
  bool _showDone = true;

  @override
  void initState() {
    super.initState();
    _loadTodoList();

    _subscription = Amplify.DataStore.observeQuery(
      Todo.classType,
      where: _showDone ? null : Todo.ISDONE.eq(false),
      sortBy: [Todo.NAME.ascending()],
    ).listen((QuerySnapshot<Todo> snapshot) {
      setState(() {
        _todoList = snapshot.items;
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _loadTodoList() async {
    _todoList = await Amplify.DataStore.query(
      Todo.classType,
      where: _showDone ? null : Todo.ISDONE.eq(false),
      sortBy: [Todo.NAME.ascending()],
      pagination: const QueryPagination(
        page: 0,
        limit: 20,
      ),
    );
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
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon((_subscription?.isPaused ?? true)
                    ? Icons.sync_disabled
                    : Icons.sync),
                onPressed: () {
                  if (_subscription?.isPaused ?? true) {
                    _subscription?.resume();
                  } else {
                    _subscription?.pause();
                  }
                  setState(() {});
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('show completed'),
                  Checkbox(
                    value: _showDone,
                    onChanged: (value) async {
                      _showDone = value ?? true;
                      await _loadTodoList();
                    },
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: _todoList.isEmpty
                ? const Center(
                    child:
                        Text('Congratulations, there is nothing left to do!'),
                  )
                : ListView.builder(
                    itemCount: _todoList.length,
                    itemBuilder: (context, index) {
                      var todo = _todoList[index];
                      return ListTile(
                        leading: InkWell(
                          onTap: () => _toggleStatus(todo),
                          child: Icon(
                            todo.isDone
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        title: Text(todo.name),
                        subtitle: Text(todo.description ?? ''),
                        trailing: InkWell(
                          onTap: () => _deleteTodo(todo),
                          child: const Icon(
                            Icons.delete_outlined,
                          ),
                        ),
                        onTap: () => _editToDo(todo),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _editToDo(Todo(
          name: '',
          isDone: false,
          notes: const [],
        )),
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

  _editToDo(Todo todo) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ToDoPage(
          todo: todo,
        ),
      ),
    );
    _loadTodoList();
  }

  _toggleStatus(Todo todo) async {
    try {
      await Amplify.DataStore.save(todo.copyWith(
        isDone: !todo.isDone,
      ));
      _loadTodoList();
    } on DataStoreException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
      ));
    }
  }

  _deleteTodo(Todo todo) async {
    try {
      await Amplify.DataStore.delete(todo);
      _loadTodoList();
    } on DataStoreException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
      ));
    }
  }
}
