import 'package:firebase_messaging/firebase_messaging.dart';

FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

String getToken() {
  _firebaseMessaging.getToken().then((value){
    print('the token is ' + value);
    return value;
  });
}

/*class PushNotificationService {
  final FirebaseMessaging _fcm;

  PushNotificationService(this._fcm);

  Future initialise() async {
    //if (Platform.isIOS) {
      //_fcm.requestNotificationPermissions(IosNotificationSettings());
    //}

    // If you want to test the push notification locally,
    // you need to get the token and input to the Firebase console
    // https://console.firebase.google.com/project/YOUR_PROJECT_ID/notification/compose
    String token = await _fcm.getToken();
    print("FirebaseMessaging token: $token");

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        /*if (Platform.isAndroid) {
          notification = PushNotificationMessage(
            title: message['notification']['title'],
            body: message['notification']['body'],
          );
        }*/
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }
}
*/
/*final String serverToken = '<Server-Token>';
final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

Future<Map<String, dynamic>> sendAndRetrieveMessage() async {
  await firebaseMessaging.requestNotificationPermissions(
    const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
  );

  await http.post(
    'https://fcm.googleapis.com/fcm/send',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body': 'this is a body',
          'title': 'this is a title'
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done'
        },
        'to': await firebaseMessaging.getToken(),
      },
    ),
  );

  final Completer<Map<String, dynamic>> completer =
  Completer<Map<String, dynamic>>();

  firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      completer.complete(message);
    },
  );

  return completer.future;
}*/