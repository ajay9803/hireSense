import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hiresense/models/user.dart';

class UserService {
  final _usersRef = FirebaseFirestore.instance.collection('users');

  Future<void> createUserIfNotExists(AppUser user) async {
    final doc = await _usersRef.doc(user.uid).get();

    if (!doc.exists) {
      await _usersRef.doc(user.uid).set(user.toMap());
    }
  }

  Future<void> updateEmailVerified(String uid) async {
    await _usersRef.doc(uid).update({'emailVerified': true});
  }

  Future<AppUser?> getUser(String uid) async {
    final doc = await _usersRef.doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromMap(doc.data()!);
  }
}
