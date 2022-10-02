import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
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
    _givenNameController.text =
        _getUserAttribute(CognitoUserAttributeKey.givenName);
    _familyNameController.text =
        _getUserAttribute(CognitoUserAttributeKey.familyName);

    var profilePictureKey = _getUserAttribute(CognitoUserAttributeKey.picture);
    if (profilePictureKey.isNotEmpty) {
      var result = await Amplify.Storage.getUrl(
        key: profilePictureKey,
        options: S3GetUrlOptions(accessLevel: StorageAccessLevel.private),
      );
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
            Stack(
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
                if (_profilePictureUrl != null)
                  Positioned(
                    right: 0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: _deleteImage,
                    ),
                  ),
              ],
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
          options: S3UploadFileOptions(
            accessLevel: StorageAccessLevel.private,
          ),
        );
        await Amplify.Auth.updateUserAttribute(
          userAttributeKey: CognitoUserAttributeKey.picture,
          value: key,
        );
        var result = await Amplify.Storage.getUrl(
          key: key,
          options: S3GetUrlOptions(accessLevel: StorageAccessLevel.private),
        );
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

  Future<void> _deleteImage() async {
    try {
      var profilePictureKey =
          _getUserAttribute(CognitoUserAttributeKey.picture);
      await Amplify.Storage.remove(
        key: profilePictureKey,
        options: RemoveOptions(accessLevel: StorageAccessLevel.private),
      );
      setState(() {
        _profilePictureUrl = null;
      });
      await Amplify.Auth.updateUserAttribute(
        userAttributeKey: CognitoUserAttributeKey.picture,
        value: '',
      );
    } on AmplifyException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
      ));
    }
  }

  String _getUserAttribute(CognitoUserAttributeKey key) {
    return _userAttributes!
        .firstWhere(
          (a) => a.userAttributeKey == key,
          orElse: () => AuthUserAttribute(
            userAttributeKey: key,
            value: '',
          ),
        )
        .value;
  }
}
