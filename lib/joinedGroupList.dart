import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kitchsafenew/database.dart';
import 'groupView.dart';
import 'post.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




class JoinedGroupList extends StatefulWidget {

  final List<Group> listItems;//should be List<Post> listItems
  final FirebaseUser user;

  JoinedGroupList(this.listItems, this.user);

  @override
  _JoinedGroupListState createState() => _JoinedGroupListState();
}

class _JoinedGroupListState extends State<JoinedGroupList> {
  void like(Function callBack) {
    this.setState(() {
      callBack();
    });
  }

  bool showNotification(thisGroup) {
    bool sentNotification = thisGroup.notifications['sentNotification'];
    if (sentNotification == false){
      return false;
    } else if (thisGroup.notifications['notificationMembersResolved'] == null && sentNotification){
      return true;
    } else if (!thisGroup.notifications['notificationMembersResolved'].contains(widget.user.uid) && sentNotification){
      return true;
    } else {
      return false;
    }
  }

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String thisDevice;
  @override
  Widget build(BuildContext context) {
    if(this.widget.listItems.length == 0){
      //return Text('You have no currently joined groups. Join or create a group!');
      return Container(
        color: Colors.grey[100],
        child: Center(
          child: SpinKitChasingDots(
            color: Colors.orange,
            size: 50.0,
          ),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: this.widget.listItems.length,
        itemBuilder: (context, index) {
          var group = this.widget.listItems[index];
          if(group.members.contains(widget.user.uid)) {
            return GestureDetector(
              onTap: () {
                /*String getToken() {
                  _firebaseMessaging.getToken().then((value){
                    print('the token is ' + value);
                    String x = value;
                    print('x: $x');
                    if (!group.devices.contains(x)){
                      print('not contained');
                      group.devices.add(x);
                      updateGroup(group, group.id);
                      setState(() {

                      });
                    }
                    return value;
                  });
                }*/
                //thisDevice = getToken();

                //print(thisDevice);
                _firebaseMessaging.getToken().then((value){
                  print('the token is ' + value);
                  String x = value;
                  print('x: $x');
                  if (!group.devices.contains(x)){
                    print('not contained');
                    if(group.notifications['devices'] == Null || group.notifications['devices'] == ['']){
                      setState(() {
                        group.notifications['devices'] = [x];
                      });
                    } if (group.devices == Null || group.devices == ['']){
                      group.devices = [x];
                    } else {
                      group.devices.add(x);
                      group.notifications['devices'].add(x);
                      List<dynamic> curDevices = group.notifications['devices'];
                      if (curDevices != Null){
                        curDevices.add(x);
                      } else {
                        curDevices = [x];
                      }

                      print('curDevices');
                      print(curDevices);
                      group.notifications['devices'] = curDevices;
                    }
                    updateGroup(group, group.id);
                    setState(() {

                    });
                  }
                  return value;
                });

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
                          subtitle: Text('Admin: ' + group.membersNameMap[group.admin].toString()),//FirebaseAuth.getInstance().getUser(group.admin)
                        )),
                    Row(
                      children: <Widget>[
                        Container(
                          child: !showNotification(group) ? Text(group.members.length.toString(),
                              style: TextStyle(fontSize: 20)) : Text('!',
                              style: TextStyle(fontSize: 20, color: Colors.red)),
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        ),
                        IconButton(
                          icon: Icon(Icons.more_vert),
                          onPressed: (){
                            showAlertDialog(BuildContext context) {
                              AlertDialog alert = AlertDialog(
                                title: Text("Choose an Action"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FlatButton(
                                      onPressed: () {
                                        this.like(() => group.likePost(widget.user));
                                        Navigator.pop(context);
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete),
                                          Text('Leave'),
                                        ],
                                      ),
                                    ),
                                   FlatButton(
                                      onPressed: () {
                                        if (group.admin == widget.user.uid){
                                          this.like(() => group.likePost(widget.user));
                                          Navigator.pop(context);
                                        } else {
                                          final snackBar = SnackBar(
                                            content: Text('You must be a group admin to do this action'),
                                          );

                                          Scaffold.of(context).showSnackBar(snackBar);
                                        }

                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete_forever, color: group.admin == widget.user.uid ? Colors.black38: Colors.black,),
                                          Text('Delete'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return alert;
                                },
                              );
                            }
                            showAlertDialog(context);
                          },
                          color: Colors.black,
                        ),
                      ],
                    )
                  ])),
            );
          } else {
            return Container();
          }
        },
      );
    }

  }
}
