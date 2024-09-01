import 'package:flutter/material.dart';
import 'package:kitchsafenew/groupMembers.dart';
import 'package:kitchsafenew/groupSettings.dart';
import 'package:kitchsafenew/groupViewList.dart';
import 'package:kitchsafenew/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kitchsafenew/groupView.dart';
import 'post.dart';
import 'dart:async';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'database.dart';

class GroupView extends StatefulWidget {

  final Group group;
  final FirebaseUser user;
  //final FirebaseUser user;

  GroupView(this.group, this.user);

  @override
  _GroupViewState createState() => _GroupViewState();
}

class _GroupViewState extends State<GroupView> {

  void like(Function callBack) {
    this.setState(() {
      callBack();
    });
  }


  /*List<dynamic> widgetList = [
    Column(
      children: [
        Text(widget.group.name),
        Text('admin: ' + widget.group.admin),
        Text('members: ' + widget.group.members.elementAt(0).displayname),
        Text('code: ' + widget.group.id.toString()),
        Text('password: ' + widget.group.code),
      ],
    ),
    Text('hi'),
    FlatButton(
      child: Text('ur fat'),
    )
  ];*/

  List<dynamic> currentEnhancedFrame = [];
  String datetime = 'N/A';
  double minTemp = -1000.0;
  double maxTemp = -1000.0;
  int widthPixels = 0;
  int heightPixels = 0;
  bool cameraOn = false;

  /*void updateEnhancedCurrentFrame(){
    print('updated');
    setState(() {
      currentEnhancedFrame = widget.group.currentInfo['enhancedCurrentFrame']['Inputs'];
      datetime = widget.group.currentInfo['enhancedCurrentFrame']['datetime'];
      minTemp = widget.group.currentInfo['enhancedCurrentFrame']['minTemp'];
      maxTemp = widget.group.currentInfo['enhancedCurrentFrame']['maxTemp'];
      print(minTemp);
      widthPixels = currentEnhancedFrame.length;
      heightPixels = currentEnhancedFrame[0].length;
    });

  }*/

  Timer timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(Duration(seconds: 2), (Timer t) {

      Map<dynamic, dynamic> getData(){
        final db = FirebaseDatabase.instance.reference().child("groups");
        db.once().then((DataSnapshot snapshot){
          Map<dynamic, dynamic> values = snapshot.value;
          values.forEach((key,values) {
            print(values["currentInfo"]);
            print(values["currentInfo"].runtimeType);
            print('maxTemp');
            print(values["currentInfo"]['enhancedCurrentFrame']['maxTemp']);
            return values["currentInfo"];
          });
        });
      }

      //.child('-MOMv1bRLqHkdW4mmBVa').child('currentInfo').child("cameraInput").child("currentData");
      //print(currentDataRef.get().val());
      //Map<dynamic, dynamic> curVal = getData();

      //print(widget.group.currentInfo['enhancedCurrentFrame']['Inputs']);

      final db = FirebaseDatabase.instance.reference().child("groups");
      db.once().then((DataSnapshot snapshot){
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key,values) {
          //print(values["currentInfo"]);
          //print(values["currentInfo"].runtimeType);
          //print('maxTemp');
          //print(values["currentInfo"]['enhancedCurrentFrame']['maxTemp']);

          if (values["currentInfo"]['enhancedCurrentFrame'] == -1 || values["currentInfo"]['enhancedCurrentFrame'] == Null){
            print('val is null');
          } else if (!cameraOn && (values["currentInfo"]['enhancedCurrentFrame'] != -1 && values["currentInfo"]['enhancedCurrentFrame'] != Null)){
            datetime = values["currentInfo"]['enhancedCurrentFrame']['datetime'];
            cameraOn = DateTime.now().difference(DateTime.parse(datetime)).inSeconds < 5;
          } else {
            currentEnhancedFrame = values["currentInfo"]['enhancedCurrentFrame']['Inputs'];
            //print(currentEnhancedFrame);
            datetime = values["currentInfo"]['enhancedCurrentFrame']['datetime'];
            //minTemp = widget.group.currentInfo['enhancedCurrentFrame']['minTemp'];
            cameraOn = DateTime.now().difference(DateTime.parse(datetime)).inSeconds >5;
            //print('second diff');
            //print(DateTime.now().difference(DateTime.parse(datetime)).inSeconds);

            minTemp = values["currentInfo"]['enhancedCurrentFrame']['minTemp'];//TODO

            maxTemp = values["currentInfo"]['enhancedCurrentFrame']['maxTemp'];//widget.group.currentInfo['enhancedCurrentFrame']['maxTemp'];
            //print(curVal['enhancedCurrentFrame']['maxTemp']);
            widthPixels = currentEnhancedFrame.length;

            setState(() {

            });

            heightPixels = currentEnhancedFrame[0].length;
          }


          setState(() {

          });
        });
      });


      /*if(widget.group.currentInfo['enhancedCurrentFrame']['Inputs'] != Null){
        currentEnhancedFrame = widget.group.currentInfo['enhancedCurrentFrame']['Inputs'];
        print(currentEnhancedFrame);
        datetime = widget.group.currentInfo['enhancedCurrentFrame']['datetime'];
        //minTemp = widget.group.currentInfo['enhancedCurrentFrame']['minTemp'];

        Random random = new Random();
        int randomNumber = random.nextInt(100);
        minTemp = 0.0 + randomNumber + widget.group.currentInfo['enhancedCurrentFrame']['minTemp'];//TODO

        maxTemp = widget.group.currentInfo['enhancedCurrentFrame']['maxTemp'];//widget.group.currentInfo['enhancedCurrentFrame']['maxTemp'];
        //print(curVal['enhancedCurrentFrame']['maxTemp']);
        widthPixels = currentEnhancedFrame.length;
        heightPixels = currentEnhancedFrame[0].length;
        setState(() {

        });
      } else {
        currentEnhancedFrame = [];
        print(currentEnhancedFrame);
        //datetime = widget.group.currentInfo['enhancedCurrentFrame']['datetime'];
        //minTemp = widget.group.currentInfo['enhancedCurrentFrame']['minTemp'];

        Random random = new Random();
        int randomNumber = random.nextInt(100);
        minTemp = -1000.0;//TODO

        maxTemp = -1000.0;
        print(minTemp);
        widthPixels = 1;
        heightPixels = 1;
        setState(() {

        });
      }*/

    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  bool showNotification() {
    bool sentNotification = widget.group.notifications['sentNotification'];
    if (sentNotification == false){
      return false;
    } else if (widget.group.notifications['notificationMembersResolved'] == null && sentNotification){
      return true;
    } else if (!widget.group.notifications['notificationMembersResolved'].contains(widget.user.uid) && sentNotification){
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget GroupInfo() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(widget.group.name.toString(), style: TextStyle(
            fontSize: 18,
          ),),
          Text('admin: ' + widget.group.membersNameMap[widget.group.admin.toString()].toString()),
          //Text('members: ' + widget.group.members.elementAt(0).displayname),
          //Text('code: ' + widget.group.id.toString()),
          Text('password: ' + widget.group.code),
          Text('temperature threshold:' + widget.group.notificationSettings['minHeat']),
          Text('timer length:' + widget.group.notificationSettings['motionDetectTimerLen']),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name.toString() + ' Group'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: 'group settings',
            onPressed: () {
              if (true){//TODO make it so only admin can access
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GroupSettings(widget.group, widget.user)));
              } else {
                SnackBar snackBar = SnackBar(
                  content: Text('You must be the admin to edit this page'),
                );

                // Find the Scaffold in the widget tree and use
                // it to show a SnackBar.
                Scaffold.of(context).showSnackBar(snackBar);
              }

            },
          ),
          IconButton(
            icon: const Icon(Icons.group),
            tooltip: 'members',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GroupMembers(widget.group, widget.user)));
            },
          ),
        ],
      ),
      body: false ? Container(): ListView(
        children: [
          Container(
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              border: Border.all(
                  color: Colors.orange,
                  width: 3
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(widget.group.name.toString(), style: TextStyle(
                  fontSize: 24,
                ),),
                SizedBox(height: 10,),
                Align(alignment: Alignment.centerLeft, child: Text('admin: ' + widget.group.membersNameMap[widget.group.admin.toString()].toString(), textAlign: TextAlign.left)),
                //Text('members: ' + widget.group.members.elementAt(0).displayname),
                //Text('code: ' + widget.group.id.toString()),
                Align(alignment: Alignment.centerLeft, child: Text('password: ' + widget.group.code)),
                Align(alignment: Alignment.centerLeft, child: Text('temperature threshold: ' + widget.group.notificationSettings['minHeat'].toString())),
                Align(alignment: Alignment.centerLeft, child: Text('timer length: ' + widget.group.notificationSettings['motionDetectTimerLen'].toString() + ' seconds')),
              ],
            ),//GroupInfo(),
          ),
          showNotification()? Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.amber[50],
                  border: Border.all(
                      color: Colors.orange,
                      width: 3
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Column(
                children: [
                  Text('Unattended Equipment Detected!', style: TextStyle(
                    fontSize: 18,
                  ),),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Flexible(child: Text("Your home system has detected unattended kitchen equipment. Please either turn it off or bring someone's attention to it.")),
                      IconButton(
                        icon: Icon(Icons.cancel),
                        iconSize: 20.0,
                        color: Colors.red,
                        onPressed: () {
                          List<dynamic> curResolved = [];
                          List<dynamic> extendingList = widget.group.notifications['notificationMembersResolved'] == null? []: widget.group.notifications['notificationMembersResolved'];
                          curResolved.addAll(extendingList);
                          curResolved.add(widget.user.uid);
                          print('curResolved');
                          print(curResolved);
                          //widget.group.notifications['notificationMembersResolved'] = curResolved;
                          bool allResolved = true;
                          print('allResolved $allResolved');
                          for (String val in curResolved){
                            if (!widget.group.members.contains(val)) {
                              allResolved = false;
                              break;
                            }
                          }

                          if (allResolved){
                            widget.group.notifications['notificationMembersResolved'] = [];
                            widget.group.notifications['sentNotification'] = false;
                          } else {
                            widget.group.notifications['notificationMembersResolved'] = curResolved;
                          }
                          updateGroup(widget.group, widget.group.id);
                          setState(() {

                          });
                        },
                      ),

                    ],
                  ),
                ],
              )//(!widget.group.notifications['notificationMembersResolved'].contains(widget.user.uid)) ? Text('true'): Text('false'),// && widget.group.notifications['sentNotification']
          ): Container(),
          Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.amber[50],
                border: Border.all(
                    color: Colors.orange,
                    width: 3
                ),
                borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: (!cameraOn) ? Column(
              children: [
                Text('Camera', style: TextStyle(fontSize: 24),),
                Container(
                  height: MediaQuery.of(context).size.width,
                  child: Text('no camera is detected with this group'),
                ),
                Text('Date and Time: ' + 'N/A'),
                Text('Minimum Temperature: ' + 'N/A'),
                Text('Maximum Temperature: ' + 'N/A')
              ],
            ):Column(
              children: [
                Text('Camera'),
                Container(
                  height: MediaQuery.of(context).size.width,
                  child: GridView.count(
                    // Create a grid with 2 columns. If you change the scrollDirection to
                    // horizontal, this produces 2 rows.
                    crossAxisCount: widthPixels,
                    // Generate 100 widgets that display their index in the List.
                    children: List.generate(widthPixels*heightPixels, (index) {

                      List<dynamic> pixelColor = currentEnhancedFrame[(index/widthPixels).floor()][ index %heightPixels];
                      return Container(
                        height: MediaQuery.of(context).size.width / 32 - 5,
                        color: Color.fromRGBO(pixelColor[0], pixelColor[1], pixelColor[2], 1),
                      );
                    }),
                  ),
                ),
                //Text('Date and Time: ' + datetime),//TODO put this back
                Text('Minimum Temperature: ' + minTemp.toString()),
                Text('Maximum Temperature: ' + maxTemp.toString())
              ],
            ),
          ),
        ],
      ),
      //Expanded(child: GroupViewList(widget.group))
    );
  }
}
