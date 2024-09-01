import 'package:flutter/material.dart';
import 'package:kitchsafenew/newGroupList.dart';
import 'joinedGroupList.dart';
import 'package:kitchsafenew/post.dart';
import 'package:kitchsafenew/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'groupView.dart';
import 'notificationService.dart';

class JoinGroup extends StatefulWidget {

  final FirebaseUser user;

  JoinGroup(this.user);

  @override
  _JoinGroupState createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {

  TextEditingController controller = new TextEditingController();

  List<Group> groups = [];
  String searchText = '';

  void like(Function callBack) {
    this.setState(() {
      callBack();
    });
  }

  onSearchTextChanged(String text) async {

    setState(() {
      searchText = text;
    });

    print(searchText);
  }

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
    updateGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Join a Group')),
      body: Column(
          children: [
            new Container(
              color: Theme.of(context).primaryColor,
              child: new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Card(
                  child: new ListTile(
                    leading: new Icon(Icons.search),
                    title: new TextField(
                      controller: controller,
                      decoration: new InputDecoration(
                          hintText: 'Search', border: InputBorder.none),
                      onChanged: onSearchTextChanged,
                    ),
                    trailing: new IconButton(icon: new Icon(Icons.cancel), onPressed: () {
                      controller.clear();
                      onSearchTextChanged('');
                    },),
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                          flex: 6,
                          child: ListView.builder(
                            itemCount: this.groups.length,
                            itemBuilder: (context, index) {
                              var group = this.groups[index];
                              if (!group.members.contains(widget.user.uid) && (group.name.contains(searchText) || searchText == '')){
                                return GestureDetector(
                                  onTap: () {
                                    if (group.members.contains(widget.user.uid)){
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => GroupView(group, widget.user)));
                                    }
                                  },
                                  child: Card(
                                      child: Row(children: <Widget>[
                                        Expanded(
                                            child: ListTile(
                                              title: Text(group.code),
                                              subtitle: Text('Admin: ' + group.admin),
                                            )),
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              child: Text(group.members.length.toString(),
                                                  style: TextStyle(fontSize: 20)),
                                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                            ),
                                            IconButton(
                                                icon: Icon(Icons.add_circle),
                                                onPressed: (){

                                                  String typedPwd = '';
                                                  showAlertDialog(BuildContext context) {

                                                    // set up the button
                                                    Widget okButton = FlatButton(
                                                      child: Text("OK"),
                                                      onPressed: () {
                                                        if(typedPwd == group.code){
                                                          this.like(() => group.likePost(widget.user));

                                                          Navigator.pop(context);
                                                        } else {
                                                          Navigator.pop(context);
                                                          Scaffold.of(context).showSnackBar(new SnackBar(
                                                              content: new Text('incorrect password')
                                                          ));
                                                        }
                                                      },
                                                    );

                                                    // set up the AlertDialog
                                                    AlertDialog alert = AlertDialog(
                                                      title: Text("Please Enter a Password"),
                                                      content: TextField(
                                                        maxLength: 10,
                                                        decoration: InputDecoration(
                                                            hintText: 'Password'
                                                        ),
                                                        onChanged: (text) {
                                                          typedPwd = text;
                                                        },
                                                      ),
                                                      actions: [
                                                        okButton,
                                                      ],
                                                    );

                                                    // show the dialog
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return alert;
                                                      },
                                                    );
                                                  }
                                                  if(!group.members.contains(widget.user.uid)){
                                                    showAlertDialog(context);
                                                  } else {
                                                    this.like(() => group.likePost(widget.user));
                                                  }
                                                  /*AlertDialog(
                            title: Text("My title"),
                            content: Text("This is my message."),
                            actions: [
                              FlatButton(
                                child: Text('hi'),
                                onPressed: () {
                                  this.like(() => group.likePost(widget.user));
                                },
                              ),
                            ],
                          );*/
                                                },
                                                color: group.members.contains(widget.user.uid)
                                                    ? Colors.green
                                                    : Colors.black)
                                          ],
                                        )
                                      ])),
                                );
                              } else {
                                return Container();
                              }
                            },
                          )
                      ),
                    ]
                )
            )
          ]
      ),
    );
    return Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    flex: 6,
                    child: JoinedGroupList(this.groups, widget.user)
                ),
              ]
            )
          )
        ]
    );
  }
}
