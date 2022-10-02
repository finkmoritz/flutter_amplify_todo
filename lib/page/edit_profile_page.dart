import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String? _profilePictureUrl;
  late TextEditingController _givenNameController;
  late TextEditingController _familyNameController;
  List<AuthUserAttribute>? _userAttributes;

  @override
  void initState() {
    super.initState();
    _givenNameController = TextEditingController(text: '');
    _familyNameController = TextEditingController(text: '');
    _loadUserAttributes();
  }

  @override
  void dispose() {
    _givenNameController.dispose();
    _familyNameController.dispose();
    super.dispose();
  }

  Future<void> _loadUserAttributes() async {
    _userAttributes = await Amplify.Auth.fetchUserAttributes();
    _givenNameController.text = _userAttributes!
        .firstWhere(
          (a) => a.userAttributeKey == CognitoUserAttributeKey.givenName,
          orElse: () => const AuthUserAttribute(
            userAttributeKey: CognitoUserAttributeKey.givenName,
            value: '',
          ),
        )
        .value;
    _familyNameController.text = _userAttributes!
        .firstWhere(
          (a) => a.userAttributeKey == CognitoUserAttributeKey.familyName,
          orElse: () => const AuthUserAttribute(
            userAttributeKey: CognitoUserAttributeKey.familyName,
            value: '',
          ),
        )
        .value;

    var profilePictureKey = _userAttributes!
        .firstWhere(
          (a) => a.userAttributeKey == CognitoUserAttributeKey.picture,
          orElse: () => const AuthUserAttribute(
            userAttributeKey: CognitoUserAttributeKey.picture,
            value: '',
          ),
        )
        .value;
    if (profilePictureKey.isNotEmpty) {
      var result = await Amplify.Storage.getUrl(key: profilePictureKey);
      _profilePictureUrl = result.url;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget child = const CircularProgressIndicator();
    if (_userAttributes != null) {
      child = Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: _uploadImage,
              child: CircleAvatar(
                radius: 0.25 * MediaQuery.of(context).size.width,
                backgroundImage: _profilePictureUrl == null
                    ? null
                    : NetworkImage(_profilePictureUrl!),
              ),
            ),
            TextFormField(
              controller: _givenNameController,
              decoration: const InputDecoration(
                labelText: 'Given Name',
              ),
              validator: _validate,
            ),
            TextFormField(
              controller: _familyNameController,
              decoration: const InputDecoration(
                labelText: 'Family Name',
              ),
              validator: _validate,
            ),
            ElevatedButton(
              onPressed: _save,
              child: const Text('Save'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: child,
        ),
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
        await Amplify.Auth.updateUserAttributes(attributes: [
          AuthUserAttribute(
            userAttributeKey: CognitoUserAttributeKey.givenName,
            value: _givenNameController.text.trim(),
          ),
          AuthUserAttribute(
            userAttributeKey: CognitoUserAttributeKey.familyName,
            value: _familyNameController.text.trim(),
          ),
        ]).then((_) => Navigator.pop(context));
      } on AmplifyException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message),
        ));
      }
    }
  }

  Future<void> _uploadImage() async {
    final xfile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xfile != null) {
      final currentUser = await Amplify.Auth.getCurrentUser();
      final key = currentUser.userId;
      final file = File(xfile.path);
      try {
        await Amplify.Storage.uploadFile(
          local: file,
          key: key,
        );
        await Amplify.Auth.updateUserAttribute(
          userAttributeKey: CognitoUserAttributeKey.picture,
          value: key,
        );
        var result = await Amplify.Storage.getUrl(key: key);
        setState(() {
          _profilePictureUrl = result.url;
        });
      } on AmplifyException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message),
        ));
      }
    }
  }
}
