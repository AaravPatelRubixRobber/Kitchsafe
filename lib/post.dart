import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:kitchsafenew/database.dart';

class Group {
  String name;
  String code;
  String admin;
  bool sendNewNotification = false;
  List<String> devices = [''];
  Set members = {};
  Map membersNameMap;
  Map notificationSettings;
  Map currentInfo;
  Map notifications;
  DatabaseReference id;

  Group(this.name, this.code, this.admin, this.notificationSettings, this.currentInfo, this.notifications);
  //Group(this.name, this.code, this.admin, this.notificationSettings);

  void likePost(FirebaseUser user) {
    if (this.members.contains(user.uid)) {
      this.members.remove(user.uid);
      this.membersNameMap.remove(user.uid);
    } else {
      this.members.add(user.uid);
      this.membersNameMap.addAll({user.uid: user.displayName});
    }
    this.update();
  }

  void update() {
    updateGroup(this, this.id);
  }

  void setId(DatabaseReference id) {
    this.id = id;
  }

  Map<String, dynamic> toJson() {
    return {
      'name' : this.name,
      'admin': this.admin,
      'devices': this.devices,
      'members': this.members.toList(),
      'membersNameMap': this.membersNameMap,
      'code' : this.code,
      'notificationSettings': this.notificationSettings,
      'currentInfo': this.currentInfo,
      'notifications': this.notifications,
      'sendNewNotification': this.sendNewNotification,
    };
  }
}

Group createGroup(record) {
  Map<String, dynamic> attributes = {
    'name':'',
    'admin': '',
    'devices': [],
    'members': [],
    'membersNameMap': {
      'test':'Test Hello',
      'test2': 'hello2'
    },
    'sendNewNotification': false,
    'code' : '',
    'notificationSettings': {
      'motionDetectTimerLen': -1,
      'minHeat': -1
    },
    'currentInfo': {
      'cameraInput': {'savedData': -1, 'currentData': -1},
      'enhancedCurrentFrame': -1,
      'applianceOn': false,
      'motionDetectCountdown': -1,
      'equipmentUnattended': false
    },
    'notifications': {
      'sentNotification':false,
      'currentNotificationSeverity': -1,
      'sendNewNotification' : false,
      'devices': [],
      'notificationMembersResolved': [],
    }
  };

  record.forEach((key, value) => {attributes[key] = value});

  Group group = new Group(attributes['name'], attributes['code'], attributes['admin'], attributes['notificationSettings'], attributes['currentInfo'], attributes['notifications']);
  //Group group = new Group(attributes['name'], attributes['code'], attributes['admin'], attributes['notificationSettings']);
  group.members = new Set.from(attributes['members']);
  group.devices = new List.from(attributes['devices']);
  group.membersNameMap = new Map.from(attributes['membersNameMap']);
  group.sendNewNotification = false;
  //TODO include group.devices = lksafjl;aksjflksd;
  return group;
}