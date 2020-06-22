import 'dart:io';
import 'dart:math';
import 'package:question_reminders/colors.dart';
import 'package:question_reminders/widgets/accent_color_override.dart';

import 'user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final bool isLoading;

  final void Function(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  AuthForm(this.submitFn, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  var _userEmail = "";
  var _userName = "";
  var _userPassword = "";
  var _isLogin = true;
  var _userImage;

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (_userImage == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
            content: Text("Lütfen resim seçiniz"),
            backgroundColor: Theme.of(context).errorColor),
      );
      return;
    }
    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _userImage,
        _isLogin,
        context,
      );
    }
  }

  void _pickedImage(File image) {
    _userImage = image;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 10.0),
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 40.0),
          transform: Matrix4.rotationZ(-6 * pi / 180)..translate(-10.0),
          decoration: ShapeDecoration(
            shape: BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
            // borderRadius: BorderRadius.circular(30),
            color: kShrineBrown400,
            shadows: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black26,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Text(
            'Question Reminder',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 32,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        Card(
          color: kShrinePink100,
          margin: EdgeInsets.all(10),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  AccentColorOverride(
                    color: kShrineBrown900,
                    child: TextFormField(
                      key: ValueKey("email"),
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: false,
                      validator: (value) {
                        if (value.isEmpty || !value.contains("@")) {
                          return "Geçerli bir email adresi giriniz.";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userEmail = value;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Email",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (!_isLogin)
                    AccentColorOverride(
                      color: kShrineBrown900,
                      child: TextFormField(
                        key: ValueKey("username"),
                        autocorrect: true,
                        textCapitalization: TextCapitalization.sentences,
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
                          labelText: "Kullanıcı Adı",
                        ),
                      ),
                    ),
                  if (!_isLogin)
                    SizedBox(
                      height: 10,
                    ),
                  AccentColorOverride(
                    color: kShrineBrown900,
                    child: TextFormField(
                      key: ValueKey("password"),
                      validator: (value) {
                        if (value.isEmpty || value.length < 7) {
                          return "Şifre en az 7 karakter olmalıdır.";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userPassword = value;
                      },
                      decoration: InputDecoration(
                        labelText: "Şifre",
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      child: Text(_isLogin ? "Giriş" : "Kaydol"),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      onPressed: _trySubmit,
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      textColor: Theme.of(context).accentColor,
                      child: Text(_isLogin
                          ? "Yeni bir hesap oluştur"
                          : "Zaten bir hesabım var"),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
