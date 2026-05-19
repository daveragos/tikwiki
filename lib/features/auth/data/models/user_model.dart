import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:tikwiki/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    super.displayName,
    super.photoUrl,
  });

  factory UserModel.fromFirebaseUser(firebase.User firebaseUser) {
    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
    );
  }
}
