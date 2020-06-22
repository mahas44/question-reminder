import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn);

  final void Function(File pickedImage) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _image;
  final picker = ImagePicker();

  void _pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 150);

    setState(() {
      _image = File(pickedFile.path);
    });
    widget.imagePickFn(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: _image == null ? AssetImage("assets/question_icon.png") : FileImage(_image),
        ),
        FlatButton.icon(
          icon: Icon(Icons.image),
          label: Text("Resim Ekle"),
          onPressed: _pickImage,
          // textColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}