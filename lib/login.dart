import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kitchsafenew/loading.dart';
import 'package:kitchsafenew/myHomePage.dart';
import 'auth.dart';
import 'groups.dart';

import 'package:kitchsafenew/miscellaneousNotificationMethods.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Login')), body: Body());
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  FirebaseUser user;

  @override
  void initState() {
    super.initState();
    signOutGoogle();
  }

  void click() async {
    print(user);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Loading()));
    await signInWithGoogle().then((user) => {
      this.user = user,

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => MyHomePage(user)))//MyHomePage(user)
    });
  }

  Widget googleLoginButton() {
    return OutlineButton(
        onPressed: this.click,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
        splashColor: Colors.grey,
        borderSide: BorderSide(color: Colors.grey),
        child: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(image: AssetImage('assets/google_logo.png'), height: 35),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text('Sign in with Google',
                        style: TextStyle(color: Colors.grey, fontSize: 25)))
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    //mySendSMS('hi it is me', ["2039885670"]);//TODO impliment this
    return Align(alignment: Alignment.center, child: googleLoginButton());
  }
}

