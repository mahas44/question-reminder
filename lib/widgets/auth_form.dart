import 'dart:io';
import 'package:question_reminders/colors.dart';
import 'package:question_reminders/widgets/accent_color_override.dart';

import 'user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final bool isLoading;

  final void Function(
    String email,
    String password,
    String confirmPassword,
    String username,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  AuthForm(this.submitFn, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();

  var _userEmail = "";
  var _userName = "";
  var _password = "";
  var _confirmPassword = "";
  var _isLogin = true;
  var _userImage;

  void _submit() {
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
        _password.trim(),
        _confirmPassword.trim(),
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
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      width: deviceSize.width * 0.9,
      height: _isLogin ? deviceSize.height * 0.4 : deviceSize.height * 0.5,
      margin: EdgeInsets.all(16),
      child: Card(
        color: kShrinePink100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 8,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
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
                  height: 8,
                ),
                if(!_isLogin)
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
                SizedBox(
                  height: 8,
                ),
                AccentColorOverride(
                  color: kShrineBrown900,
                  child: TextFormField(
                    key: ValueKey("password"),
                    controller: _passwordController,
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return "Şifre en az 7 karakter olmalıdır.";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value;
                    },
                    decoration: InputDecoration(
                      labelText: "Şifre",
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                if (!_isLogin)
                  AccentColorOverride(
                    color: kShrineBrown900,
                    child: TextFormField(
                      key: ValueKey("confirmPassword"),
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return "Şifreniz eşleşmeli.";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _confirmPassword = value;
                      },
                      decoration: InputDecoration(
                        labelText: "Şifre Doğrulama",
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                  ),
                SizedBox(
                  height: 8,
                ),
                if (widget.isLoading) CircularProgressIndicator(),
                if (!widget.isLoading)
                  RaisedButton(
                    child: Text(_isLogin ? "Giriş" : "Kaydol"),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: _submit,
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
    );
  }
}
