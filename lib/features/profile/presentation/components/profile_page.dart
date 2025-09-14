import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social_media_app/features/profile/presentation/components/bio_box.dart';
import 'package:social_media_app/features/profile/presentation/components/edit_profile_page.dart';
import 'package:social_media_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:social_media_app/features/profile/presentation/cubit/profile_state.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // cubits
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();
  // late AppUser? currentUser = authCubit.currentUser;

  @override
  void initState() {
    profileCubit.fetchUserProfile(widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        //loading
        if (state is ProfileLoadingState) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()
            )
          );
        } else if (state is ProfileSuccessState) {
          final user = state.profileUser;
          return Scaffold(
            appBar: AppBar(  
              actions: [
                IconButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return EditProfilePage(profileUser: user);
                      },
                    ),
                  ),
                  icon: Icon(
                    Icons.settings,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
              title: Text(
                user.name,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      " ${user.email}",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  // profile pic
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 120,
                    width: 120,
                    padding: const EdgeInsets.all(25),
                    child: Center(
                      child: Icon(
                        Icons.person,
                        size: 72,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  BioBox(newBio: user.bio),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            body: Center(child: Text('This user does not exist')),
          );
        }
      },
    );
  }
}
