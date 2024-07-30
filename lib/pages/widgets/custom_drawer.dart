import 'package:flutter/material.dart';

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
        ],
      ),
    );
  }
}
