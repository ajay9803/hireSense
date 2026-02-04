import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/*
AuthService handles Google Sign-In with Firebase.

Setup Steps:
1. Add dependencies in pubspec.yaml:
   firebase_auth, google_sign_in, firebase_core

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

  /*
  Signs in the user using Google and returns a Firebase UserCredential.
  Returns null if the user cancels or an error occurs.
  */
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Initialize Google Sign-In with your server client ID
      await _googleSignIn.initialize(
        serverClientId:
            "553239732400-78lisu23hdvf10smh9oa1v5hp4csh73j.apps.googleusercontent.com",
      );

      // Prompt user to pick a Google account
      final account = await _googleSignIn.authenticate();

      // Get authentication tokens
      final auth = account.authentication;

      // Create a Firebase credential
      final cred = GoogleAuthProvider.credential(idToken: auth.idToken);

      // Sign in to Firebase
      return await _firebaseAuth.signInWithCredential(cred);
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
