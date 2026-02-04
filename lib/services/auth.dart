// "553239732400-78lisu23hdvf10smh9oa1v5hp4csh73j.apps.googleusercontent.com",

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/*
AuthService handles Google Sign-In with Firebase.

Setup Steps:
1. Add dependencies in pubspec.yaml:
   firebase_auth, google_sign_in, firebase_core, cloud_firestore

2. In Firebase Console:
   - Enable Google as an authentication provider.

3. In Google Cloud Console:
   - Create an OAuth client ID for Android.
   - Copy the Web client ID (serverClientId).

4. Add SHA-1 and SHA-256 fingerprints:
   - Navigate to android folder and run:
     ./gradlew.bat signingReport
   - Add SHA keys to Firebase app settings.

5. Download updated google-services.json and replace the old file in android/app.

6. Ensure Firebase.initializeApp() is called in main.dart before runApp().
*/

class AuthService {
  final _firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn.instance;
  final _firestore = FirebaseFirestore.instance;

  /*
  Signs in the user using Google and returns a Firebase UserCredential.
  If the user is new, writes their data to Firestore in 'users' collection.
  */
  Future<UserCredential?> signInWithGoogle({required bool isRecruiter}) async {
    try {
      await _googleSignIn.initialize(
        serverClientId:
            "553239732400-78lisu23hdvf10smh9oa1v5hp4csh73j.apps.googleusercontent.com",
      );

      final account = await _googleSignIn.authenticate();

      final auth = account.authentication;

      final cred = GoogleAuthProvider.credential(idToken: auth.idToken);

      final userCredential = await _firebaseAuth.signInWithCredential(cred);
      final user = userCredential.user;
      if (user == null) return null;

      // Write user data to Firestore
      final userRef = _firestore.collection('users').doc(user.uid);

      // Only create if it doesn't exist yet
      final doc = await userRef.get();
      if (!doc.exists) {
        await userRef.set({
          'uid': user.uid,
          'name': user.displayName,
          'email': user.email,
          'role': isRecruiter ? 'recruiter' : 'hiring_manager',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return userCredential;
    } catch (e) {
      print("Google sign in failed: ${e.toString()}");
      return null;
    }
  }

  /* Signs out the user from both Google and Firebase. */
  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _firebaseAuth.signOut();
  }
}
