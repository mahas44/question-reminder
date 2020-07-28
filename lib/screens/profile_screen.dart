import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_reminders/providers/chat_provider.dart';
import 'package:question_reminders/providers/user_provider.dart';
import 'package:question_reminders/screens/settings_screen.dart';
import 'package:question_reminders/widgets/question/question_list.dart';
import 'dart:ui';

class ProfileScreen extends StatelessWidget {
  static const routeName = "/profile";

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;
    String myId = Provider.of<UserProvider>(context, listen: false).userId;
    var userData;
    var type = "my";
    if (data == null) {
      userData = Provider.of<UserProvider>(context, listen: false).userData;
    } else {
      userData = data["userData"];
      type = data["type"];
    }
    final double statusBarHeight =
        MediaQueryData.fromWindow(window).padding.top;
    return Scaffold(
      appBar: (data != null && type == "look")
          ? AppBar(
              automaticallyImplyLeading: true,
            )
          : null,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(125, 125, 125, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 255, 255, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                buildColumn(userData, context),
                SizedBox(
                  height: 32,
                ),
                buildContainer(userData),
                SizedBox(
                  height: 16,
                ),
                buildRow(data, context, userData, myId),
                SizedBox(
                  height: 20,
                ),
                buildButtonRow(
                    context, statusBarHeight, type, userData.documentID),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column buildColumn(userData, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(80),
          child: Image.network(
            userData["imageUrl"],
            height: 160,
            width: 160,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          userData["username"],
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(
          height: 8,
        ),
        Text(userData["description"],
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            )),
      ],
    );
  }

  Container buildContainer(userData) {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            userData["score"].toString() + " Puan",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w400, fontSize: 18),
          ),
          Text(
            userData["friendsCount"] == null
                ? "0 Takipçi"
                : userData["friendsCount"].toString() + " Arkadaş",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w400, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Row buildRow(
      Map<String, dynamic> data, BuildContext context, userData, String myId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        if (data != null && data["type"] == "look")
          Column(
            children: <Widget>[
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.message),
              ),
              Text("Mesaj Gönder")
            ],
          ),
        if (data == null)
          Column(
            children: <Widget>[
              IconButton(
                onPressed: () =>
                    showDialogRequest(context, userData.documentID),
                icon: Icon(Icons.person_add),
              ),
              Text("Arkadaş İstekleri")
            ],
          ),
        if (data != null &&
            data["type"] == "look" &&
            (userData["friends"] == null ||
                !userData["friends"].contains(myId)))
          Column(
            children: <Widget>[
              Builder(
                builder: (context) {
                  return IconButton(
                    onPressed: () {
                      Scaffold.of(context).removeCurrentSnackBar();
                      _showSnackBar(context);
                      Provider.of<UserProvider>(context, listen: false)
                          .addFriendRequest(userData.documentID);
                    },
                    icon: Icon(Icons.person_add),
                  );
                },
              ),
              Text("Arkadaş Ekle")
            ],
          ),
        if (data == null)
          Column(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(SettingsScreen.routeName);
                },
                icon: Icon(Icons.edit),
              ),
              Text("Profili Düzenle")
            ],
          ),
      ],
    );
  }

  void _showSnackBar(BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text("Arkadaşlık isteği gönderildi."),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Row buildButtonRow(
      BuildContext context, double statusBarHeight, String type, uid) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        if (type != "look")
          RaisedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.notification_important),
            label: Text("Hatırlatıcı"),
            elevation: 8,
          ),
        RaisedButton.icon(
          onPressed: () => _openMyQuestion(context, statusBarHeight, type, uid),
          icon: Icon(Icons.help_outline),
          label: type == "look" ? Text("Soruları") : Text("Sorularım"),
          elevation: 8,
        ),
      ],
    );
  }

  void _openMyQuestion(
      BuildContext context, double statusBarHeight, String type, uid) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(top: statusBarHeight),
          child: Scaffold(
            appBar: AppBar(
              primary: true,
              automaticallyImplyLeading: true,
              title: type == "look" ? Text("Soruları") : Text("Sorularım"),
              centerTitle: true,
            ),
            body: QuestionList(
              type: "my",
              secondType: type == "look" ? "look" : "my",
              selectedFilter: "my",
              uid: uid,
            ),
          ),
        );
      },
    );
  }

  Future showDialogRequest(BuildContext context, String uid) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Arkadaşlık İstekleri"),
          actions: [
            FlatButton.icon(
              icon: Icon(Icons.close),
              label: Text("Kapat"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          content: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.3,
            child: FutureBuilder(
              future:
                  Firestore.instance.collection("users").document(uid).get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final List requests = snapshot.data["requests"] as List;
                if (requests == null) {
                  return Center(
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text("Arakadaşlık isteği bulunmamaktadır.")),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, _) => Divider(
                    height: 1,
                    thickness: 2,
                    color: Theme.of(context).primaryColor,
                  ),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                      future: Provider.of<UserProvider>(context).getUserById(
                        requests.elementAt(index),
                      ),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListTile(
                            title: Text(snapshot.data["username"]),
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(snapshot.data["imageUrl"]),
                            ),
                            trailing: Container(
                              width: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      Icons.cancel,
                                      color: Theme.of(context).errorColor,
                                    ),
                                    onPressed: () {
                                      Provider.of<UserProvider>(context,
                                              listen: false)
                                          .requestRejected(
                                              uid, requests.elementAt(index));
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      Provider.of<UserProvider>(context,
                                              listen: false)
                                          .requestAccepted(
                                              uid, requests.elementAt(index));
                                      Provider.of<ChatProvider>(context,
                                              listen: false)
                                          .createdChatRoom(
                                              uid, requests.elementAt(index));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
