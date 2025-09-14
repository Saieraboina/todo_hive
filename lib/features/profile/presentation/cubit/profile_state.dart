import 'package:social_media_app/features/profile/domain/entities/profile_user.dart';

abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileSuccessState extends ProfileState {
  ProfileSuccessState({required this.profileUser});
  final ProfileUser profileUser;
}

class ProfileErrorState extends ProfileState {
  ProfileErrorState({required this.error});
  final String error;
}
