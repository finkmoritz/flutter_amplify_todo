import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_todo/models/ModelProvider.dart';
import 'package:flutter_amplify_todo/page/todo_list_page.dart';

import 'amplifyconfiguration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<HubEvent>? hubSubscription;

  @override
  initState() {
    super.initState();
    _configureAmplify();
  }

  @override
  void dispose() {
    hubSubscription?.cancel();
    super.dispose();
  }

  Future<void> _configureAmplify() async {
    await Amplify.addPlugins([
      AmplifyAuthCognito(),
      AmplifyDataStore(modelProvider: ModelProvider.instance),
      AmplifyAPI(),
    ]);

    try {
      await Amplify.configure(amplifyconfig);
      _subscribe();
      //_insertTodoLabels();
    } on AmplifyAlreadyConfiguredException {
      safePrint(
          "Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
    }
  }

  Future<void> _subscribe() async {
    hubSubscription = Amplify.Hub.listen([HubChannel.Auth], (event) {
      switch (event.eventName) {
        case 'SIGNED_IN':
          safePrint('Successfully signed in');
          break;
        case 'SIGNED_OUT':
          safePrint('Successfully signed out');
          break;
        case 'SESSION_EXPIRED':
          safePrint('Session expired');
          break;
        case 'USER_DELETED':
          safePrint('Successfully deleted user account');
          break;
      }
    });
  }

  Future<void> _insertTodoLabels() async {
    var existingLabels = await Amplify.DataStore.query(Label.classType);
    if (existingLabels.isEmpty) {
      Amplify.DataStore.save(Label(name: 'Urgent', color: LabelColor.RED));
      Amplify.DataStore.save(Label(name: 'Fun', color: LabelColor.GREEN));
      Amplify.DataStore.save(Label(name: 'Mandatory', color: LabelColor.BLUE));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      child: MaterialApp(
        builder: Authenticator.builder(),
        title: 'Flutter Amplify ToDo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ToDoListPage(),
      ),
    );
  }
}
