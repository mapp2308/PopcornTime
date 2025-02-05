import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Navegación con GoRouter
import 'package:popcorntime/config/helpers/database_helper.dart'; // Base de datos local

// Este widget (`AppDrawer`) es un menú lateral que permite la navegación dentro de la aplicación.
// - Contiene enlaces a "Inicio", "Géneros", "Favoritos" y "Por Ver".
// - Permite cerrar sesión actualizando el estado de "logueado" del usuario en la base de datos.
// - Usa `GoRouter` para navegar entre las pantallas de la app.

class AppDrawer extends StatelessWidget {
  final DatabaseHelper dbHelper = DatabaseHelper(); // Instancia para acceder a la base de datos

  AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme; // Estilos del texto

    return Drawer(
      child: Column(
        children: [
          // Encabezado del Drawer
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor, // Color de fondo del encabezado
            ),
            child: Center(
              child: Text(
                'Popcorn Time', // Nombre de la app en el menú lateral
                style: textStyles.titleLarge?.copyWith(color: Colors.white),
              ),
            ),
          ),

          // Opción: Inicio
          ListTile(
            leading: const Icon(Icons.home), // Ícono de la opción
            title: const Text('Inicio'), // Nombre de la opción
            onTap: () {
              context.go('/'); // Navega a la pantalla de inicio
            },
          ),

          // Opción: Géneros
          ListTile(
            leading: const Icon(Icons.movie),
            title: const Text('Géneros'),
            onTap: () {
              context.go('/generos'); // Navega a la pantalla de géneros
            },
          ),

          // Opción: Favoritos
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favoritos'),
            onTap: () {
              context.go('/favoritos'); // Navega a la pantalla de favoritos
            },
          ),

          // Opción: Por Ver
          ListTile(
            leading: const Icon(Icons.visibility),
            title: const Text('Por Ver'),
            onTap: () {
              context.go('/por-ver'); // Navega a la pantalla de películas por ver
            },
          ),

          const Spacer(), // Empuja el resto del contenido hacia arriba

          const Divider(), // Línea divisoria

          // Opción: Cerrar sesión
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red), // Ícono de logout
            title: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)), // Texto en rojo
            onTap: () async {
              // Cerrar sesión: obtiene el usuario logueado y cambia su estado
              final loggedInUser = await dbHelper.getLoggedInUser();
              if (loggedInUser != null) {
                loggedInUser.isLogueado = false; // Marca al usuario como deslogueado
                await dbHelper.updateUser(loggedInUser);
              }

              context.go('/login'); // Redirige a la pantalla de login
            },
          ),
        ],
      ),
    );
  }
}
