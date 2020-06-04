import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_screen.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'screens/chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final cloud = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  String message;

  @override
  void initState()  {
    getCurrentUser();
//    getMessages();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser);
      }
    } catch (e) {
      print(e);
    }
  }



  List<String> mess;
  List<bool> user;

  TextAlign left = TextAlign.left;
  TextAlign right = TextAlign.right;

  Widget _buildTopics() {
    setState(() {

    });
    return ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: mess.length,
        itemBuilder: (BuildContext context, int index) {

          return _buildRow(mess[index], user[index] ? TextAlign.right : TextAlign.left);
        });
  }

  Widget _buildRow(String topic, TextAlign direct) {
    return SizedBox(
      height: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: RaisedButton(
            color: Color(0xFF183368),
//                      splashColor: press ? Colors.green : Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '$topic',
                  textAlign: direct,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            onPressed: () {
              setState(() {

              });
            }),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pushNamed(context, LoginScreen.id);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: cloud.collection('messages').snapshots(),
              // ignore: missing_return
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.deepOrange,
                    ),
                  );
                }
                  final messages = snapshot.data.documents;
                  List<Text> messageWidgets = [];
                  for (var message in messages) {
                    final messageText = message.data['text'];
                    final messageSender = message.data['user'];

                    final messageWidget = Text(
                        '$messageText from $messageSender');
                    messageWidgets.add(messageWidget);
                  }
                    return ListView(
                      children: messageWidgets,
                    );
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        //Do something with the user input.
                        message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.
                      cloud.collection('messages').add({
                        'user' : loggedInUser.email,
                        'text' : message,

                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
