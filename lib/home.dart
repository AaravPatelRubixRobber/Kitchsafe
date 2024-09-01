import 'package:flutter/material.dart';
import 'post.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kitchsafenew/createGroup.dart';
import 'package:kitchsafenew/joinGroup.dart';
import 'package:kitchsafenew/post.dart';
import 'package:kitchsafenew/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {

  final FirebaseUser user;

  Home(this.user);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('New Notifictions')
      ],
    );
  }
}
