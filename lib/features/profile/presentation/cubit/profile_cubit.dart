import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/profile/domain/repo/profile_repo.dart';
import 'package:social_media_app/features/profile/presentation/cubit/profile_state.dart';
import 'package:social_media_app/features/storage/domain/storage_repo.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;
  ProfileCubit({required this.profileRepo, required this.storageRepo})
    : super(ProfileInitialState());

  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoadingState());
      final user = await profileRepo.fetchUser(uid);
      if (user != null) {
        emit(ProfileSuccessState(profileUser: user));
      } else {
        emit(ProfileErrorState(error: 'User not found'));
      }
    } catch (e) {
      emit(ProfileErrorState(error: e.toString()));
    }
  }

  Future<void> updateProfileUser({
    required String uid,
    String? newBio,
    String? imgProfileMobilePath,
    Uint8List? imgProfileWebBytes,
  }) async {
    emit(ProfileLoadingState());
    try {
      final currentUser = await profileRepo.fetchUser(uid);
      String? profileImageUrl;
      if (currentUser == null) {
        emit(
          ProfileErrorState(error: 'Failed to fetch user for profile update'),
        );
        return;
      }
      if (imgProfileMobilePath != null || imgProfileWebBytes != null) {
        if (imgProfileMobilePath != null) {
          profileImageUrl = await storageRepo.uploadProfileImageMobile(
            path: imgProfileMobilePath,
            fileName: uid,
          );
        } else if (imgProfileWebBytes != null) {
          profileImageUrl = await storageRepo.uploadProfileImageWeb(
            path: imgProfileWebBytes,
            fileName: uid,
          );
        }
      } else {
        emit(ProfileErrorState(error: 'Failed to upload image'));
        return;
      } 
      final updatedUser = currentUser.copyWith(
        newBio: newBio ?? currentUser.bio,
        newProfileImgUrl: profileImageUrl ?? currentUser.profileImgUrl,
      );
      await profileRepo.updateUser(updatedUser);
      await fetchUserProfile(uid);
    } catch (e) {
      emit(ProfileErrorState(error: e.toString()));
    }
  }
}
