import 'package:flutter/material.dart';
import 'package:kitchsafenew/createGroup.dart';
import 'package:kitchsafenew/joinGroup.dart';
import 'package:kitchsafenew/post.dart';
import 'package:kitchsafenew/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:kitchsafenew/sendNotificationTest.dart';
import 'joinedGroupList.dart';
import 'newGroupList.dart';
import 'textInputWidget.dart';
import 'post.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'notificationService.dart';

//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:kitchsafenew/notificationService.dart';


class Groups extends StatefulWidget {

  final FirebaseUser user;

  Groups(this.user);

  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  //grop stuff
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  List<Message> messagesList;

  _getToken() {
    _firebaseMessaging.getToken().then((token) {
      print("Device Token: $token");
    });
  }

  _configureFirebaseListeners() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        _setMessage(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
        _setMessage(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        _setMessage(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );
  }

  _setMessage(Map<String, dynamic> message) {
    final notification = message['notification'];
    final data = message['data'];
    final String title = notification['title'];
    final String body = notification['body'];
    String mMessage = data['message'];
    print("Title: $title, body: $body, message: $mMessage");
    setState(() {
      Message msg = Message(title, body, mMessage);
      messagesList.add(msg);
    });
  }

  //group stuff
  void like(Function callBack) {
    this.setState(() {
      callBack();
    });
  }

  List<Group> groups = [];

  void newGroup(String name, String code, Map notificationSettings) {
    Map currentInfo = {
      'cameraInput': {'savedData': -1, 'currentData': -1},
      'enhancedCurrentFrame': -1,
      'applianceOn': false,
      'motionDetectCountdown': -1,
      'equipmentUnattended': false
    };
    Map notifications = {
      'sentNotification':false,
      'currentNotificationSeverity': -1,
      'sendNewNotification' : false,
      'devices': [],
      'notificationMembersResolved': [],
    };
    var group = new Group(name, code, widget.user.uid, notificationSettings, currentInfo, notifications);
    //var group = new Group(name, code, widget.user.displayName, notificationSettings);
    group.setId(saveGroup(group));
    this.setState(() {
      groups.add(group);
    });
    this.like(() => group.likePost(widget.user));
    group.members.add(widget.user.uid);

    String token = getToken();
    group.devices.add(token);
  }

  void updateGroups() {
    getAllGroups().then((groups) => {
      this.setState(() {
        this.groups = groups;
      })
    });
  }


  @override
  void initState() {
    super.initState();

    //notification stuff
    messagesList = List<Message>();
    _getToken();
    _configureFirebaseListeners();

    //group stuff
    updateGroups();
  }


  @override
  Widget build(BuildContext context) {

    updateGroups();//fix this later****//TODO fix this
    //return Text('groups');


    return Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                      margin: EdgeInsets.all(10.0),
                      padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.orangeAccent),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => JoinGroup(widget.user)));
                        },
                        child: Text('Find Group'),
                      )
                    /*TextField(
                      decoration: InputDecoration(
                          hintText: 'Join a Group'
                      ),
                      onChanged: (text) {
                      },
                    ),*/
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.orangeAccent),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CreateGroup(widget.user)));//CreateGroup(widget.user)
                      },
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.add,
                              color: Colors.deepOrange,
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: FlatButton(
                              child: Text('Create Group'),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => CreateGroup(widget.user)));//CreateGroup(widget.user)
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              flex: 7,
              child: JoinedGroupList(this.groups, widget.user)
          ),
          //TextInputWidget(this.newGroup)
        ]);
  }
}

class Message {
  String title;
  String body;
  String message;
  Message(title, body, message) {
    this.title = title;
    this.body = body;
    this.message = message;
  }
}
