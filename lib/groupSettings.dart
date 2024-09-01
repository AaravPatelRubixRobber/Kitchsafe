import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kitchsafenew/groupView.dart';
import 'post.dart';

class GroupSettings extends StatefulWidget {

  final Group group;//should be List<Post> listItems
  final FirebaseUser user;

  GroupSettings(this.group, this.user);

  @override
  _GroupSettingsState createState() => _GroupSettingsState();
}

class _GroupSettingsState extends State<GroupSettings> {

  bool editMode = false;
  bool isAdmin;


  void changeEditMode() {
    if(editMode == false && isAdmin){//change to if admin
      setState(() {
        editMode = true;
      });
    } else if(editMode == true){
      setState(() {
        editMode = false;
      });

    }
  }

  void newGroupName(val) {
    widget.group.name = '$val';
  }

  void newGroupCode(val) {
    widget.group.code = '$val';
  }

  void newGroupMinHeat(val) {
    widget.group.notificationSettings['minHeat'] = val;
  }

  void newGroupMotionDetectTimerLen(val) {
    widget.group.notificationSettings['motionDetectTimerLen'] = val;
  }

  String validateField(dynamic value, Type dataType, {minLen: 0, maxLen: 50}) { //TODO work on this validator later
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

  void initState() {
    editMode = false;
    isAdmin = widget.group.admin == widget.user.uid;
  }


  Widget EditDoubleItem(String valName, double startVal, Function setValNewGroup, String description){

    TextEditingController myController = TextEditingController(text: "$startVal");

    return Column(
        children: [
          Container(
            constraints: new BoxConstraints(
              minHeight: 80.0,
            ),
            child: Row(
            children: [
              SizedBox(width: 10,),
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '$valName',
                        style: TextStyle(
                          fontSize: 16,
                          //fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(description, style: TextStyle(
                          color: Colors.grey,
                        ),)
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                flex: 2,
                child: editMode ? TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter a number here',
                  ),
                  controller: myController,
                  onSubmitted: (doubleNum) {
                    setValNewGroup(num.tryParse(doubleNum).toDouble());
                    widget.group.update();
                    setState(() {

                    });
                  },
                ): Text('$startVal'),
              ),
            ],
          ),
          ),
          Divider(
            color: Colors.black,
          )
        ],
      );
  }

  Widget EditStringItem(String valName, String startVal,  Function setValNewGroup, String description){

    TextEditingController myController = TextEditingController(text: "$startVal");

    return Column(
      children: [
        Container(
          constraints: new BoxConstraints(
            minHeight: 80.0,
          ),
          child: Row(
            children: [
              SizedBox(width: 10,),
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '$valName',
                        style: TextStyle(
                          fontSize: 16,
                          //fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(description, style: TextStyle(
                          color: Colors.grey,
                        ),)
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                flex: 2,
                child: editMode? TextField(
                  decoration: InputDecoration(
                      hintText: 'Enter text here'
                  ),
                  controller: myController,
                  onSubmitted: (text) {
                    String message = validateField(text, String);
                    if(message == '') {
                      setValNewGroup(text);
                      widget.group.update();
                      setState(() {

                      });
                    } else {
                      final snackBar = SnackBar(
                        content: Text('$message'),
                      );

                      Scaffold.of(context).showSnackBar(snackBar);
                    }

                  },
                ): Text('$startVal'),
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.black,
        )
      ],
    );
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Settings'),
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
              setState(() {
                //editMode = true;
              });
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          EditStringItem('Name', widget.group.name, newGroupName, 'the group name that members will see'),
          EditStringItem('Code', widget.group.code, newGroupCode, 'the password needed in order to join the group'),
          EditDoubleItem('Minimum Heat', widget.group.notificationSettings['minHeat'].toDouble(), newGroupMinHeat, 'the minimum heat threshold that needs to be passed in order for equipment to be detected as on (40°C is recommended)'),
          EditDoubleItem('Motion Detection Timer', widget.group.notificationSettings['motionDetectTimerLen'].toDouble(), newGroupMotionDetectTimerLen, 'the time that needs to pass before members are notified of potentially unattended kitchen equipment (35 seconds is recommended)'),
        ],

      )/*Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Name'
            ),
          ),
          Expanded(
            flex: 3,
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Name'
              ),
              onSubmitted: (text) {
                newGroupName(text);
                setState(() {

                });
                widget.group.update();
              },
            ),
          ),
        ],
      )*//*Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*Text(
              'Basic Info'
          ),*/
          /*ConstrainedBox(
              constraints: new BoxConstraints(
                minHeight: 5.0,
                minWidth: 5.0,
                maxHeight: 30.0,
                maxWidth: 30.0,
              ),
              child: StringItem('name', newGroupName)
          ),*/
          /*Container(
            child: Column(
              children: [
                Expanded(
                  child: Text(
                    'Basic Info'
                  ),
                ),
                //StringItem('name', newGroupName),
              ],
            ),
          )*/
        ],
      ),*/

    );
  }
}
