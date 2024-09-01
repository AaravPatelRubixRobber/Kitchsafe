/*import 'package:firebase_messaging/firebase_messaging.dart';

void registerNotification() {

  //FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  firebaseMessaging.requestNotificationPermissions();

  firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
    print('onMessage: $message');
    Platform.isAndroid
        ? showNotification(message['notification'])
        : showNotification(message['aps']['alert']);
    return;
  }, onResume: (Map<String, dynamic> message) {
    print('onResume: $message');
    return;
  }, onLaunch: (Map<String, dynamic> message) {
    print('onLaunch: $message');
    return;
  });

  firebaseMessaging.getToken().then((token) {
    print('token: $token');
    Firestore.instance
        .collection('users')
        .document(currentUserId)
        .updateData({'pushToken': token});
  }).catchError((err) {
    Fluttertoast.showToast(msg: err.message.toString());
  });
}*/