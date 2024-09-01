import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kitchsafenew/groupView.dart';
import 'post.dart';

class GroupMembers extends StatefulWidget {

  final Group group;//should be List<Post> listItems
  final FirebaseUser user;

  GroupMembers(this.group, this.user);

  @override
  _GroupMembersState createState() => _GroupMembersState();
}

class _GroupMembersState extends State<GroupMembers> {

  bool editMode = false;
  bool isAdmin;

  bool changeEditMode() {
    if(editMode == false && isAdmin){//change to if admin
      setState(() {
        editMode = true;
      });

      return true;
    } else if(editMode == true){
      setState(() {
        editMode = false;
      });

      return false;
    }
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override

  void initState() {
    editMode = false;
    isAdmin = widget.group.admin == widget.user.uid;
  }

  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Group Members'
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'edit members',
            onPressed: () {
              changeEditMode();
              if (!isAdmin) {
                final snackBar = SnackBar(
                  content: Text('You must be admin to edit this page'),
                );

                _scaffoldKey.currentState.showSnackBar(snackBar);
              }
            },
          ),
        ],
      ),
      body: widget.group.members.length != 0 ? ListView.builder(
          itemCount: widget.group.members.length,
          itemBuilder: (BuildContext context, int index) {

            String memberID = widget.group.members.elementAt(index);

            return Column(
              children: [
                ListTile(
                  title: Text(widget.group.membersNameMap[widget.group.members.elementAt(index)].toString()),
                  subtitle: Text(widget.group.admin == widget.group.members.elementAt(index) ? 'admin':'member'),//change to if admin
                  onLongPress: () {
                    changeEditMode();
                    if (!isAdmin) {
                      final snackBar = SnackBar(
                        content: Text('You must be admin to edit this page'),
                      );

                      Scaffold.of(context).showSnackBar(snackBar);
                    }
                    /*if (!isAdmin) {
                      final snackBar = SnackBar(
                        content: Text('You must be admin to edit this page'),
                      );

                      Scaffold.of(context).showSnackBar(snackBar);
                    }*/
                  },
                  trailing: editMode ? IconButton(
                    icon: Icon(Icons.remove_circle, color: Colors.red,),
                    onPressed: () {
                      widget.group.members.remove(widget.group.members.elementAt(index));
                      widget.group.update();
                      setState(() {
                      });
                    },
                  ) : Icon(Icons.person),
                ),
                Divider(),
              ],
            );
          },
      ) : Text('An error has occured, please try refreshing the page'),
    );
  }
}
