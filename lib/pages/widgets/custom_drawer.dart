import 'package:flutter/material.dart';
import 'package:mini_project_3_bootcamp/bloc/auth_bloc/auth_bloc.dart';
import 'package:mini_project_3_bootcamp/pages/login_page.dart';
import 'package:provider/provider.dart';

import '../../shared/style.dart';
import '../cart_page.dart';
import '../profile_page.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text(
              'Belanjain  ',
              style: title.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),
          ListTile(
            title: Text(
              'Profile',
              style: body,
            ),
            leading: const Icon(Icons.person_outline_outlined),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
          ),
          ListTile(
            title: Text(
              'Cart',
              style: body,
            ),
            leading: const Icon(Icons.shopping_cart_outlined),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartPage(),
                ),
              );
            },
          ),
          ListTile(
            title: Text(
              'Log Out',
              style: body,
            ),
            leading: const Icon(Icons.logout),
            onTap: () {
              context.read<AuthBloc>().add(AuthLogout());

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
