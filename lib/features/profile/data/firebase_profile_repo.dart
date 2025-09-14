import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/features/profile/domain/entities/profile_user.dart';
import 'package:social_media_app/features/profile/domain/repo/profile_repo.dart';

class FirebaseProfileRepo implements ProfileRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<ProfileUser?> fetchUser(String uid) async {
    try {
      final userDoc = await firebaseFirestore
          .collection('users')
          .doc(uid)
          .get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          return ProfileUser(
            uid: uid,
            email: userData['email'],
            name: userData['name'],
            bio: userData['bio'] ?? '',
            profileImgUrl: userData['profileImgUrl'].toString(),
          );
        }
      }
    } catch (e) {
      throw Exception(e);
    }
    return null;
  }

  @override
  Future<void> updateUser(ProfileUser updatedUser) async {
    try {
      await firebaseFirestore.collection('users').doc(updatedUser.uid).update({
        'bio': updatedUser.bio,
        'profileImgUrl': updatedUser.profileImgUrl,
      });
    } catch (e) {
      throw Exception(e);
    }
  }
}
