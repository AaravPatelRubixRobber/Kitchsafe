import 'package:firebase_database/firebase_database.dart';
import 'userData.dart';
import 'post.dart';

final databaseReference = FirebaseDatabase.instance.reference();

DatabaseReference saveGroup(Group group) {
  var id = databaseReference.child('groups/').push();
  id.set(group.toJson());
  return id;
}

void updateGroup(Group group, DatabaseReference id) {
  id.update(group.toJson());
}

Future<List<Group>> getAllGroups() async {
  DataSnapshot dataSnapshot = await databaseReference.child('groups/').once();
  List<Group> groups = [];
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      Group group = createGroup(value);
      group.setId(databaseReference.child('groups/' + key));
      groups.add(group);
    });
  }
  return groups;
}

DatabaseReference saveUser(UserData userData) {
  var id = databaseReference.child('userData/').push();
  id.set(userData.toJson());
  return id;
}

void updateUserData(UserData userData, DatabaseReference id) {
  id.update(userData.toJson());
}