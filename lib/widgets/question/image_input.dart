import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  ImageInput(this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;

  Future<void> _takePicture(String sourceType) async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(
      source: sourceType == "kamera" ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 600, // auto crop image width
      maxHeight: 800,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = File(imageFile.path);
    });
    final appDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage =
        await File(imageFile.path).copy("${appDir.path}/$fileName");
    widget.onSelectImage(savedImage);
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
              border:
                  Border.all(width: 1, color: Theme.of(context).accentColor)),
          child: _storedImage != null
              ? Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  "Resim Seçilmedi",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline4,
                ),
          alignment: Alignment.center,
        ),
        FlatButton.icon(
          icon: Icon(Icons.camera),
          label: Text("Resim Seçiniz", style: Theme.of(context).textTheme.headline6,),
          textColor: Theme.of(context).accentColor,
          onPressed: () => showDialogForImage(context),
        ),
      ],
    );
  }
}
