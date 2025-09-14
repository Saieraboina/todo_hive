import 'package:social_media_app/features/auth/domain/entities/app_user.dart';

abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthLoadingState extends AuthStates {}

class AuthSuccessState extends AuthStates {
  final AppUser? appUser;
  AuthSuccessState(this.appUser);
}

class AuthErrorState extends AuthStates {
  final String error;
  AuthErrorState(this.error);
}

class UnAuthenticatedState extends AuthStates {}
