import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'groupView.dart';
import 'post.dart';

class NewGroupList extends StatefulWidget {

  final List<Group> listItems;//should be List<Post> listItems
  final FirebaseUser user;

  NewGroupList(this.listItems, this.user);

  @override
  _NewGroupListState createState() => _NewGroupListState();
}

class _NewGroupListState extends State<NewGroupList> {
  void like(Function callBack) {
    this.setState(() {
      callBack();
    });
  }


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this.widget.listItems.length,
      itemBuilder: (context, index) {
        var group = this.widget.listItems[index];
        if (!group.members.contains(widget.user.uid)){
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
    );
  }
}
