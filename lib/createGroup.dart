import 'package:flutter/material.dart';
import 'package:kitchsafenew/joinGroup.dart';
import 'package:kitchsafenew/notificationService.dart';
import 'package:kitchsafenew/post.dart';
import 'package:kitchsafenew/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'joinedGroupList.dart';
import 'newGroupList.dart';
import 'textInputWidget.dart';
import 'post.dart';
import 'package:flushbar/flushbar.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

class CreateGroup extends StatefulWidget {

  final FirebaseUser user;

  CreateGroup(this.user);

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {

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

    //Map testAddMap = {'hii', 'Test helloa'}
    String token = getToken();

    setState(() {
      group.membersNameMap = {widget.user.uid : widget.user.displayName};
      group.notifications['devices'].add(token);
    });
    print(group.membersNameMap);
    //group.membersNameMap.update(key, (value) => null)

    this.setState(() {
      groups.add(group);
    });
    this.like(() => group.likePost(widget.user));
    group.members.add(widget.user.uid);

    //String token = getToken();
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
    updateGroups();
  }

  String validateField(dynamic value, Type dataType, {minLen: 0, maxLen: 50}) {
    if (value.toString().length == 0 || value.runtimeType != dataType) {
      if (dataType == String)  {
        return "please enter some text";
      } else if (dataType == double || dataType == int)  {
        return "please enter a number";
      } else if (dataType == String)  {
        return "please enter a true or false value";
      } else {
        return "enter a value";
      }

    }
    return '';
  }

  @override
  Widget build(BuildContext context) {

    String name = '';
    String password = '';
    double motionDetectTimerLen = 5;
    double minHeat = 50;

    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: <Widget>[
              Text(
                'Create a Group',
                style: TextStyle(fontSize: 18.0),
              ),
              TextField(
                maxLength: 25,
                decoration: InputDecoration(
                    hintText: 'Name'
                ),
                onChanged: (text) {
                  name = text;
                },
              ),
              TextField(
                maxLength: 10,
                decoration: InputDecoration(
                    hintText: 'Password',
                  //errorText: validateField(text, String),
                ),
                onChanged: (text) {
                  String message = validateField(text, String);
                  if (message == ''){
                    password = text;
                  } else {
                    final snackBar = SnackBar(
                      content: Text('$message'),
                    );

                    Scaffold.of(context).showSnackBar(snackBar);
                  }

                },
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      'Select the time that needs to pass before members are notified of potentially unattended kitchen equipment (35 seconds is recommended)'
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Time in Seconds',
                        //errorText: validateField(text, String),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (newVal) {
                        setState(() {
                          motionDetectTimerLen = num.tryParse(newVal);
                        });
                      },
                    ),
                    /*Slider(
                      value: motionDetectTimerLen,
                      onChanged: (newVal) {
                        setState(() {
                          motionDetectTimerLen = newVal;
                        });
                      },
                      min: 1,
                      max: 15,
                    ),*/
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                        'Select the minimum heat threshold that needs to be passed in order for equipment to be detected as on (40°C is recommended)'
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Temperature in Celsius',
                        //errorText: validateField(text, String),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (newVal) {
                        setState(() {
                          minHeat = num.tryParse(newVal);
                          print(minHeat);
                        });
                      },
                    ),
                  ],
                ),
              ),
              RaisedButton(
                  color: Colors.pink[400],
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    //1 <= motionDetectTimerLen && motionDetectTimerLen <=15
                    bool hasNull = (name=='' || password=='' || motionDetectTimerLen=='' || minHeat=='');
                    print('hasNumm');
                    print(hasNull);
                    if(!hasNull){
                      print('name and password');
                      print(name);
                      print(password);
                      newGroup(name, password, {'motionDetectTimerLen': motionDetectTimerLen, 'minHeat': minHeat});//TODO return later and make modifyable
                      Navigator.pop(context);
                    } else {
                      print('has Null component');
                      Navigator.pop(context);
                      /*final snackBar = SnackBar(
                        content: Text('Invalid Parameters Entered. Please Try Again'),
                      );
                      Scaffold.of(context).showSnackBar(snackBar);*/
                      Flushbar(
                        title:  "Invalid Parameters Entered",
                        message:  "Please Try Again",
                        duration:  Duration(seconds: 3),
                      )..show(context);
                    }

                    //if(_formKey.currentState.validate()){

                    //}
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}


