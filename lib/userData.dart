import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:kitchsafenew/database.dart';

class UserData {
  String name;
  String code;
  String admin;
  Set members = {};
  DatabaseReference id;

  UserData(this.name, this.code, this.admin);

  void likePost(FirebaseUser user) {
    if (this.members.contains(user.uid)) {
      this.members.remove(user.uid);
    } else {
      this.members.add(user.uid);
    }
    this.update();
  }

  void update() {
    updateUserData(this, this.id);
  }

  void setId(DatabaseReference id) {
    this.id = id;
  }

  Map<String, dynamic> toJson() {
    return {
      'name' : this.name,
      'admin': this.admin,
      'members': this.members.toList(),
      'code' : this.code,
    };
  }
}

UserData createUserData(record) {
  Map<String, dynamic> attributes = {
    'name':'',
    'admin': '',
    'members': [],
    'code' : ''
  };

  record.forEach((key, value) => {attributes[key] = value});

  UserData userData = new UserData(attributes['name'], attributes['code'], attributes['admin']);
  userData.members = new Set.from(attributes['members']);
  return userData;
}