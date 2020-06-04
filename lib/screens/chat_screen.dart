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
  final messageTextController = TextEditingController();
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
      backgroundColor: Colors.white,
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
                  final messages = snapshot.data.documents.reversed;
                  List<MessageBubble> messageWidgets = [];
                  for (var message in messages) {
                    final messageText = message.data['text'];
                    final messageSender = message.data['user'];
                    final current = loggedInUser.email;
                    bool comm = false;
                    if (current == messageSender) {
                      comm = true;
                    }

                    final messageWidget = MessageBubble(sender:'$messageSender', text:'$messageText', comm: comm);
                    messageWidgets.add(messageWidget);
                  }
                    return Expanded(
                      child: ListView(
                        reverse: true,
                        children: messageWidgets,
                      ),
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
                      controller: messageTextController,
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
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

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.comm});
  final bool comm;
  final String sender;
  final String text;
  final BorderRadius senders = BorderRadius.only(
    bottomLeft: Radius.circular(30.0),
    topLeft: Radius.circular(30.0),
    bottomRight: Radius.circular(30.0),
  );
  final BorderRadius receiver = BorderRadius.only(
    bottomLeft: Radius.circular(30.0),
    topRight: Radius.circular(30.0),
    bottomRight: Radius.circular(30.0),
  );
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: comm ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[

          Text(
            sender,
            style: TextStyle(
              color: Colors.black,
              fontSize: 10
            ),
          ),
          Material(
            borderRadius: comm ? senders : receiver,
            elevation: 5.0,
            color: Colors.green,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),

              ),
            ),
          ),
        ],
      ),
    );
  }
}
