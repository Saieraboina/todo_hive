import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/data/firebase_auth_repo.dart';
import 'package:social_media_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social_media_app/features/auth/presentation/cubits/auth_states.dart';
import 'package:social_media_app/features/auth/presentation/pages/auth_page.dart';
import 'package:social_media_app/features/home/presentation/home_page.dart';
import 'package:social_media_app/features/profile/data/firebase_profile_repo.dart';
import 'package:social_media_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:social_media_app/features/storage/data/firebase_storage_repo.dart';
import 'package:social_media_app/themes/lignt_mode.dart';

class MyApp extends StatelessWidget {
  final firebaseauthRepo = FirebaseAuthRepo();
  final firebaseprofileRepo = FirebaseProfileRepo();
  final firebasestorageRepo = FirebaseStorageRepo();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (BuildContext context) =>
              AuthCubit(authRepo: firebaseauthRepo)..checkAuth(),
        ),
        BlocProvider<ProfileCubit>(
          create: (BuildContext context) =>
              ProfileCubit(profileRepo: firebaseprofileRepo, storageRepo: firebasestorageRepo),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        home: BlocConsumer<AuthCubit, AuthStates>(
          builder: (context, state) {
            if (state is AuthSuccessState) {
              return HomePage();
            }
            if (state is UnAuthenticatedState) {
              return AuthPage();
            } else {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }
          },
          listener: (context, state) {
            if (state is AuthErrorState) {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error)));
              return;
            }
          },
        ),
      ),
    );
  }
}
