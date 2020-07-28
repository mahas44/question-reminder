import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:question_reminders/colors.dart';
import 'package:question_reminders/providers/user_provider.dart';
import 'package:question_reminders/widgets/accent_color_override.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;

class SettingsScreen extends StatefulWidget {
  static const routeName = "/settings";

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  DocumentSnapshot _userData;
  var _userName;
  var _uid;
  var _description;
  File _pickedImage;

  void _selectImage(File pickedImage) {
    setState(() {
      _pickedImage = pickedImage;
    });
  }

  @override
  void initState() {
    super.initState();
    _userData = Provider.of<UserProvider>(context, listen: false).userData;
    _uid = Provider.of<UserProvider>(context, listen: false).userId;
    _userName = _userData["username"];
    _description = _userData["description"];
  }

  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
    }

    try {
      StorageReference ref = FirebaseStorage.instance
          .ref()
          .child("user_images")
          .child(_uid.toString() +".jpg");
      if (_pickedImage != null) {
        await ref.putFile(_pickedImage).onComplete;
      }
      final url = await ref.getDownloadURL();
      await Firestore.instance.collection("users").document(_uid).updateData({
        "username": _userName,
        "description": _description,
        "imageUrl": url,
      });
      Provider.of<UserProvider>(context, listen: false).getUserData();
      Navigator.pop(context);
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kShrinePink300,
        title: Text(
          "Ayarlar",
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _submit,
          ),
        ],
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: _pickedImage == null
                      ? Image.network(
                          _userData["imageUrl"],
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          _pickedImage,
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                ),
                FlatButton.icon(
                  onPressed: () => showDialogForImage(context),
                  icon: Icon(Icons.photo),
                  label: Text("Profil Resmini Değiştir"),
                ),
                SizedBox(
                  height: 8,
                ),
                AccentColorOverride(
                  color: kShrineBrown900,
                  child: TextFormField(
                    style: TextStyle(color: Colors.black),
                    key: ValueKey("username"),
                    initialValue: _userName.toString(),
                    enableSuggestions: true,
                    validator: (value) {
                      if (value.isEmpty || value.length < 4) {
                        return "Kullanıcı adı en az 4 karakter olmalıdır.";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userName = value;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Kulllanıcı Adı",
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                AccentColorOverride(
                  color: kShrineBrown900,
                  child: TextFormField(
                    key: ValueKey("description"),
                    style: TextStyle(color: Colors.black),
                    initialValue: _description.toString(),
                    autocorrect: true,
                    textCapitalization: TextCapitalization.sentences,
                    enableSuggestions: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Bir açıklama giriniz.";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _description = value;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Açıklama",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future showDialogForImage(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Resim Seçimi"),
          content: Text("Resmi nereden seçmek istersiniz?"),
          actions: [
            FlatButton.icon(
              icon: Icon(Icons.add_photo_alternate),
              label: Text("Galeri"),
              onPressed: () {
                _takePicture("galeri");
                Navigator.of(context).pop();
              },
            ),
            FlatButton.icon(
              icon: Icon(Icons.camera_alt),
              label: Text("Kamera"),
              onPressed: () {
                _takePicture("kamera");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _takePicture(String sourceType) async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(
        source:
            sourceType == "kamera" ? ImageSource.camera : ImageSource.gallery,
        maxHeight: 800,
        maxWidth: 600
        );
    if (imageFile == null) {
      return;
    }

    final appDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage =
        await File(imageFile.path).copy("${appDir.path}/$fileName");

    _selectImage(savedImage);
  }
}
