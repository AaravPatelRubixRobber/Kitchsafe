import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kitchsafenew/database.dart';
import 'package:kitchsafenew/groups.dart';
import 'package:kitchsafenew/home.dart';
import 'package:kitchsafenew/login.dart';
import 'package:kitchsafenew/sendNotificationTest.dart';
import 'package:kitchsafenew/settings.dart';
import 'post.dart';
import 'joinedGroupList.dart';
import 'textInputWidget.dart';

import 'notificationService.dart';

class MyHomePage extends StatefulWidget {
  final FirebaseUser user;

  MyHomePage(this.user);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //add all defined variables here
  //List<Group> posts = [];

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

  Widget GroupWidget() {
    return Column(children: <Widget>[
      Expanded(child: JoinedGroupList(this.groups, widget.user)),
      //TextInputWidget(this.newGroup)
    ]);
  }

  //things for bottom navigation bar

  int _selectedIndex = 1;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  /*final List<Widget> _children = [
    Home(),//groups
    Home(),
    Settings()
  ];*/

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    //Navigator.push(context,
        //MaterialPageRoute(builder: (context) => Groups()));//add user in groups
  }

  @override
  void initState() {
    super.initState();
    updateGroups();
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Groups'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.person,
              ),
              tooltip: 'Sign Out',
              onPressed: () {
                _signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage())//MyHomePage(user)
              );
              },
            )
          ],),
        body: Groups(widget.user),/*_selectedIndex == 0 ? Groups(widget.user): (_selectedIndex == 1 ? Home(widget.user): Settings()),//_children[_selectedIndex],//Settings()
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text('Groups'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),*/
    );
  }
}