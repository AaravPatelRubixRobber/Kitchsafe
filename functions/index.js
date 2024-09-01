//const functions = require('firebase-functions');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

/*const functions = require('firebase-functions')
const admin = require('firebase-admin')
admin.initializeApp()

exports.sendNotification = functions.firestore
  .document('messages/{groupId1}/notifications')
  .onCreate((snap, context) => {//called when it sees something created here
    console.log('----------------start function--------------------')

    const doc = snap.data()
    console.log(doc)

    const sendNewNotification = doc.sendNewNotification
    const currentNotificationSeverity = doc.currentNotificationSeverity
    const contentMessage = 'hi'
    devices = {}

    // Get push token user to (receive)
    for (i = 0; i < devices.length; i++){
        String device = devices[0]
        console.log(`Found user from: ${device}`)
                              const payload = {
                                notification: {
                                  title: `Kitchen Equipment Unattended`,
                                  body: contentMessage,
                                  badge: '1',
                                  sound: 'default'
                                }
                              }
                              // Let push to the target device
                              admin
                                .messaging()
                                .sendToDevice(device, payload)
                                .then(response => {
                                  console.log('Successfully sent message:', response)
                                })
                                .catch(error => {
                                  console.log('Error sending message:', error)
                                })
            return null
          })
    }
*/
const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().functions);

var newData;

exports.myTrigger = functions.database.ref('groups/{groupId}/sendNewNotification').onWrite(async (snapshot, context) => {//-MQFEo-SGmIZOEsuXIh-
    //
    console.log('triggered');

    if (snapshot.empty) {
        console.log('No Devices');
        return;
    }

    newData = snapshot.data;
    //const deviceIdTokens = await admin.database.ref('groups/{groupId}/devices');

    //var tokens = deviceIdTokens;

    /*for (var token of deviceIdTokens.docs) {
        tokens.push(token.data().device_token);
    }*/

    //console.log(tokens);

    /*const deviceIdTokens = await admin
        .firestore()
        .collection('DeviceIDTokens')
        .get();*/

    /*var db=admin.database();
    var userRefdemo=db.ref("users");
    var oneUser=userRefdemo.child(obj.roll);
    oneUser.once('value',function(snap){
    res.status(200).json({"user":snap.val()});*/

    /*return firebase.database().ref('/users/' + userId).once('value').then((snapshot) => {
        var username = (snapshot.val() && snapshot.val().username) || 'Anonymous';
        // ...
      });*/

    var tokens = ['dXASC-CNQ2CYI_tOxiaiiS:APA91bGo3rOdFIx5vBv-Z-L29y1NFli6-YSy2NMfzn920vTaD8-k9fICo2lCY8gAj6NOhUsJPG75XY5U7M4tazCUp6dkdgpkakOuv-IsuBuKKuk7jvZLnG9UOnGMgUdih_gFqUTKnYvB',
    'eAtUhvKuSbC97dbjqowPM2:APA91bEh8N0XIozBgGiBxH7shyJCb4aSH5KBgoslKs1khRO-d01V6rZmPURDOcePQhKG0T9l5AObOruu42s-zgh2CaoL7MWUlGw5OJ_zbA0DVLi1DIiaIqv9QMgQTvzkrmhSBpaLxSW9'];
    var groupDevicesGlobal;
    try {
                console.log('beginning to get devices...');
                admin.database().ref('groups/' + context.params.groupId +'/devices').once('value').then(function(snap) {
                        console.log('devices request inside started');
                        if (snap.exists()) {
                            console.log(snap.val());
                        }
                        else {
                            console.log("No data available");
                        }
                        var groupDevices = snap.val();
                        groupDevicesGlobal  = snap.val();
                        console.log(snap.val());
                        console.log(groupDevices);
                        console.log('groupDevicesGlobal inside');
                        console.log(groupDevicesGlobal);

                        try {
                            console.log('groupDevicesGlobal');
                            console.log(groupDevicesGlobal);
                        } catch {
                            console.log('cant get groupDevicesGlobal');
                        }

                        //tokens = tokens.addAll(groupDevicesGlobal);
                        /*for (var token of deviceIdTokens.docs) {
                            tokens.push(token.data().device_token);
                        }*/
                        var payload = {
                            notification: {
                                title: 'Push Title',
                                body: 'Push Body',
                                sound: 'default',
                            },
                            data: {
                                //push_key: 'Push Key Value',
                                //key1: newData.data,
                            },
                        };
                        if(true){
                            try {
                                //const response = admin.messaging().sendToDevice(tokens, payload);//should have await
                                const response = admin.messaging().sendToDevice(groupDevicesGlobal, payload);//should have await
                                console.log('Notification sent successfully in group', context.params.groupId);
                                console.log('Notification sent to...');
                                console.log(tokens);
                                console.log('groupDevicesGlobal');
                                console.log(groupDevicesGlobal);
                            } catch (err) {
                                console.log(err);
                            }
                        } else {
                            console.log('false alarm')
                        }
                }).catch(function(error) {
                    console.log('error with getting app devices from group');
                    console.error(error);
                });
    } catch {
        console.log('error')
    }



});