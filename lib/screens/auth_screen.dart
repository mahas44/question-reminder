import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:question_reminders/colors.dart';
import '../widgets/auth/auth_form.dart';
import 'package:flutter/services.dart';
import 'dart:math';
const Roles = ["User", "Moderator", "Admin"];
class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(
    String email,
    String password,
    String confirmPassword,
    String username,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) async {

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        final ref = FirebaseStorage.instance
            .ref()
            .child("user_images")
            .child(authResult.user.uid);

        await ref.putFile(image).onComplete;

        final url = await ref.getDownloadURL();

        await Firestore.instance
            .collection("users")
            .document(authResult.user.uid)
            .setData({
          "username": username,
          "email": email,
          "imageUrl": url,
          "role": Roles.elementAt(0),
          "description": "None",
        });
      }
    } on PlatformException catch (error) {
      var message = "Authentication failed";
      if (error.code == "ERROR_WRONG_PASSWORD") {
        message = "Hatalı şifre girişi.";
      } else if (error.code == "ERROR_USER_NOT_FOUND") {
        message = "Bu e-mail adresine kayıtlı bir kullanıcı mevcut değil.";
      } else if (error.toString().contains("ERROR_EMAIL_ALREADY_IN_USE")) {
        message = "Bu e-mail adresi zaten kullanılmakta.";
      }
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              width: deviceSize.width,
              height: deviceSize.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 40.0),
                    transform: Matrix4.rotationZ(-6 * pi / 180)
                      ..translate(-10.0),
                    decoration: ShapeDecoration(
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40))),
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
                      'Sor Bakalım',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 32,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  AuthForm(_submitAuthForm, _isLoading),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
