import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:popcorntime/config/helpers/database_helper.dart';

class AppDrawer extends StatelessWidget {
  final DatabaseHelper dbHelper = DatabaseHelper();

  AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Center(
              child: Text(
                'Popcorn Time',
                style: textStyles.titleLarge?.copyWith(color: Colors.white),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              context.go('/'); // Navega al HomeScreen
            },
          ),
          ListTile(
            leading: const Icon(Icons.movie),
            title: const Text('Géneros'),
            onTap: () {
              context.go('/generos'); // Navega a la pantalla de géneros
            },
          ),
          const Spacer(), // Empuja el resto del contenido hacia arriba
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
            onTap: () async {
              // Cerrar sesión: desloguea al usuario y redirige al login
              final loggedInUser = await dbHelper.getLoggedInUser();
              if (loggedInUser != null) {
                loggedInUser.isLogueado = false;
                await dbHelper.updateUser(loggedInUser);
              }

              context.go('/login'); // Redirige al login
            },
          ),
        ],
      ),
    );
  }
}
