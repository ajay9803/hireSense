import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hiresense/models/user.dart';
import 'package:hiresense/services/user_service.dart';

class AuthService {
  final _firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn.instance;
  final _userService = UserService();

  // ---------------- GOOGLE SIGN IN ----------------
  Future<UserCredential?> signInWithGoogle({required bool isRecruiter}) async {
    try {
      await _googleSignIn.initialize(
        serverClientId:
            "553239732400-78lisu23hdvf10smh9oa1v5hp4csh73j.apps.googleusercontent.com",
      );

      final account = await _googleSignIn.authenticate();
      final auth = account.authentication;

      final credential = GoogleAuthProvider.credential(idToken: auth.idToken);

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      final user = userCredential.user;
      if (user == null) return null;

      final appUser = AppUser(
        uid: user.uid,
        name: user.displayName,
        email: user.email!,
        role: isRecruiter ? 'recruiter' : 'hiring_manager',
        emailVerified: user.emailVerified,
        createdAt: Timestamp.now(),
      );

      await _userService.createUserIfNotExists(appUser);

      return userCredential;
    } catch (e) {
      print("Google sign in failed: $e");
      return null;
    }
  }

  // ---------------- EMAIL SIGN UP ----------------
  Future<UserCredential?> signUpWithEmailPassword({
    required String email,
    required String password,
    required bool isRecruiter,
    required String username,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) return null;

      await user.sendEmailVerification();

      final appUser = AppUser(
        uid: user.uid,
        name: username,
        email: email,
        role: isRecruiter ? 'recruiter' : 'hiring_manager',
        emailVerified: false,
        createdAt: Timestamp.now(),
      );

      await _userService.createUserIfNotExists(appUser);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Throw the Firebase error message
      throw e.message ?? "An unknown error occurred";
    } catch (e) {
      throw e.toString();
    }
  }

  // ---------------- EMAIL SIGN IN ----------------
  Future<UserCredential?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print("Email sign-in failed: $e");
      return null;
    }
  }

  // ---------------- SIGN OUT ----------------
  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _firebaseAuth.signOut();
  }
}
