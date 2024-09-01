/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kitchsafenew/groupView.dart';
import 'post.dart';
import 'dart:async';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';


class GroupViewList extends StatefulWidget {

  final Group group;//should be List<Post> listItems
  //final FirebaseUser user;

  GroupViewList(this.group);

  @override
  _GroupViewListState createState() => _GroupViewListState();
}

class _GroupViewListState extends State<GroupViewList> {
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

    timer = Timer.periodic(Duration(seconds: 4), (Timer t) {

      void getData(){
        final currentDataRef = FirebaseDatabase.instance.reference().child("group");
        currentDataRef.orderByKey().equalTo("-MOMv1bRLqHkdW4mmBVa").once().then((DataSnapshot snapshot) {
          //print('Data : ${snapshot.value}');
        });
      }

      //.child('-MOMv1bRLqHkdW4mmBVa').child('currentInfo').child("cameraInput").child("currentData");
      //print(currentDataRef.get().val());
      getData();

      //print('current info');
      //print(widget.group.currentInfo['enhancedCurrentFrame']['Inputs']);

      if(true){//widget.group.currentInfo['enhancedCurrentFrame']['Inputs'] != Null
        currentEnhancedFrame = widget.group.currentInfo['enhancedCurrentFrame']['Inputs'];
        //(currentEnhancedFrame);
        datetime = widget.group.currentInfo['enhancedCurrentFrame']['datetime'];
        //minTemp = widget.group.currentInfo['enhancedCurrentFrame']['minTemp'];
        print('gigigigigigigiig');
        print(DateTime.now().difference(DateTime.parse(datetime)).inSeconds);

        Random random = new Random();
        int randomNumber = random.nextInt(100);
        minTemp = 0.0 + widget.group.currentInfo['enhancedCurrentFrame']['minTemp'];//TODO

        maxTemp = widget.group.currentInfo['enhancedCurrentFrame']['maxTemp'];
        //print(widget.group.currentInfo['enhancedCurrentFrame']['maxTemp']);
        widthPixels = currentEnhancedFrame.length;
        heightPixels = currentEnhancedFrame[0].length;
        setState(() {

        });
      } else {
        currentEnhancedFrame = [];
        //print(currentEnhancedFrame);
        //datetime = widget.group.currentInfo['enhancedCurrentFrame']['datetime'];
        //minTemp = widget.group.currentInfo['enhancedCurrentFrame']['minTemp'];

        Random random = new Random();
        int randomNumber = random.nextInt(100);
        minTemp = -1000.0;//TODO

        maxTemp = -1000.0;
        //print(minTemp);
        widthPixels = 1;
        heightPixels = 1;
        setState(() {

        });
      }

    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    /*currentEnhancedFrame = widget.group.currentInfo['enhancedCurrentFrame']['Inputs'];
    datetime = widget.group.currentInfo['enhancedCurrentFrame']['datetime'];
    //minTemp = widget.group.currentInfo['enhancedCurrentFrame']['minTemp'];
    maxTemp = widget.group.currentInfo['enhancedCurrentFrame']['maxTemp'];
    print(minTemp);
    widthPixels = currentEnhancedFrame.length;
    heightPixels = currentEnhancedFrame[0].length;*/

    Widget GroupInfo() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(widget.group.name.toString()),
          Text('admin: ' + widget.group.admin.toString()),
          //Text('members: ' + widget.group.members.elementAt(0).displayname),
          //Text('code: ' + widget.group.id.toString()),
          Text('password: ' + widget.group.code),
        ],
      );
    }

    //updateEnhancedCurrentFrame();

    return ListView(
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
          child: GroupInfo(),
    /*Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  widget.group.name,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(
                  'admin: ' + widget.group.admin,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              Text(
                  'members: ' + widget.group.members.elementAt(0),
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),//widget.group.members.elementAt(0).displayName
              Text(
                  'code: ' + widget.group.id.toString(),
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              Text(
                  'password: ' + widget.group.code,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),*/
        ),
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
            child: Text('hi')
        ),
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
            child: (DateTime.now().difference(DateTime.parse(datetime)).inSeconds > 5) ? Column(
              children: [
                Text('Camera'),
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
                Text('Date and Time: ' + datetime),
                Text('Minimum Temperature: ' + minTemp.toString()),
                Text('Maximum Temperature: ' + maxTemp.toString())
              ],
            ),
        ),
      ],
    );
    /*return ListView.builder(
      itemCount: widgetList.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent)
          ),
          color: Colors.orange,
          child: widgetList[index],
        );
      },
    );*/
  }
}
*/