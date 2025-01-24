// Este archivo configura las rutas de navegación de la aplicación utilizando GoRouter.
// GoRouter es una librería que facilita la gestión de rutas y navegación en aplicaciones Flutter.

import 'package:go_router/go_router.dart'; // Importa la librería GoRouter para la navegación.
import 'package:popcorntime/config/helpers/database_helper.dart';
import 'package:popcorntime/presentation/screens/screens.dart';
import 'package:popcorntime/presentation/screens/users/login_screen.dart';
import 'package:popcorntime/presentation/screens/movies/categories_screen.dart';


Future<GoRouter> createAppRouter() async {
  // Verifica si hay un usuario logueado
  final DatabaseHelper dbHelper = DatabaseHelper();
  final loggedInUser = await dbHelper.getLoggedInUser();

  // Configura el GoRouter
  return GoRouter(
    initialLocation: loggedInUser != null ? '/' : '/login',
    routes: [
      // Ruta para el login
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),

      // Ruta para la pantalla principal (HomeScreen)
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),

      // Ruta para la pantalla de géneros
      GoRoute(
        path: '/generos',
        builder: (context, state) => GenersScreen(),
      ),

      // Ruta para la pantalla de detalles de la película
      GoRoute(
        path: '/movie/:id',
        name: MovieScreen.name,
        builder: (context, state) {
          final movieId = state.params['id'] ?? 'no-id';
          return MovieScreen(movieId: movieId);
        },
      ),

      // Ruta para categorías de películas
      GoRoute(
        path: '/categories',
        builder: (context, state) => GenersScreen(),
      ),
    ],
  );
}
