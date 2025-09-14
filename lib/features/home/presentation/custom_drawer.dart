import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/presentation/cubits/auth_cubit.dart'
    show AuthCubit;
import 'package:social_media_app/features/home/presentation/drawer_tile.dart';
import 'package:social_media_app/features/profile/presentation/components/profile_page.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              // logo / avatar
              Padding(
                padding: EdgeInsets.symmetric(vertical: 50.0),
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              // divider line
              Divider(color: Theme.of(context).colorScheme.secondary),

              // home tile
              DrawerTile(
                title: "H O M E",
                icon: Icons.home,
                onTap: () {
                  Navigator.pop(context); // closes drawer
                },
              ),

              // profile tile
              DrawerTile(
                title: "P R O F I L E",
                icon: Icons.person,
                onTap: () {
                  final user = context.read<AuthCubit>().currentUser; 
                     
                  if (user != null) {
                    final uid = user.uid;
                 print(uid);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return ProfilePage(uid: uid);
                        },
                      ),
                    );
                  }
                },
              ),

              DrawerTile(
                title: "S E A R C H",
                icon: Icons.search,
                onTap: () {
                  // Navigate to Profile
                },
              ),
              DrawerTile(
                title: "S E T T I N G S",
                icon: Icons.settings,
                onTap: () {
                  // Navigate to Profile
                },
              ),
              Spacer(),

              DrawerTile(
                title: "L O G O U T",
                icon: Icons.logout,
                onTap: () {
                  context.read<AuthCubit>().logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
