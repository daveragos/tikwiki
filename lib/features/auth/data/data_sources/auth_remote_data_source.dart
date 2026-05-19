import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

abstract interface class AuthRemoteDataSource {
  Stream<firebase.User?> get authStateChanges;

  firebase.User? get currentUser;

  Future<firebase.UserCredential> signInWithGoogle();

  Future<void> syncUserProfile(firebase.User user, {String? displayName});

  Future<void> signOut();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(
    this._firebaseAuth,
    this._firestore,
    this._googleSignIn,
  );

  final firebase.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  @override
  Stream<firebase.User?> get authStateChanges =>
      _firebaseAuth.authStateChanges();

  @override
  firebase.User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<firebase.UserCredential> signInWithGoogle() async {
    final googleUser = await _googleSignIn.authenticate();
    final googleAuth = googleUser.authentication;
    final credential = firebase.GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    return _firebaseAuth.signInWithCredential(credential);
  }

  @override
  Future<void> syncUserProfile(
    firebase.User user, {
    String? displayName,
  }) async {
    final normalizedDisplayName = displayName?.trim();

    if (normalizedDisplayName != null &&
        normalizedDisplayName.isNotEmpty &&
        user.displayName != normalizedDisplayName) {
      await user.updateDisplayName(normalizedDisplayName);
    }

    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'displayName': normalizedDisplayName ?? user.displayName,
      'photoUrl': user.photoURL,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
