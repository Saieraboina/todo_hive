import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app/features/auth/domain/repository/auth_repo.dart';
import 'package:social_media_app/features/auth/presentation/cubits/auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  final AuthRepo authRepo;
   AppUser? _currentUser;
  AuthCubit({required this.authRepo}) : super(AuthInitialState());

  // check if user is already authenticated
  void checkAuth() async {
    final AppUser? user = await authRepo.getCurrentUser();
    if (user != null) {
      _currentUser = user;
      emit(AuthSuccessState(user));
    } else {
      emit(UnAuthenticatedState());
    }
  }

  // get current user
  AppUser? get currentUser {
    return _currentUser;
  }

  // login with email+pw
  Future<void> login(String email, String password) async {
    try {
      emit(AuthLoadingState());
      final user = await authRepo.loginWithEmailAndPassword(email, password);
      if (user != null) {
        _currentUser = user;
        emit(AuthSuccessState(user));
      } else {
        emit(UnAuthenticatedState());
      }
    } catch (e) {
      emit(AuthErrorState(e.toString()));
      emit(UnAuthenticatedState());
    }
  }

  //register with emaail+ pw

  Future<void> registerUser(String name, String email, String password) async {
    try {
      emit(AuthLoadingState());
      final user = await authRepo.registerWithEmailAndPassword(
        name,
        email,
        password,
      );
      if (user != null) {
        _currentUser = user;
        emit(AuthSuccessState(_currentUser));
      } else {
        emit(UnAuthenticatedState());
      }
    } catch (e) {
      emit(AuthErrorState(e.toString()));
      emit(UnAuthenticatedState());
    }
  }

  // logout
  Future<void> logout() async {
    await authRepo.logOut();
    emit(UnAuthenticatedState());
  }
}
