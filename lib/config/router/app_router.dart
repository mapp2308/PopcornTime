// Este archivo configura las rutas de navegación de la aplicación utilizando GoRouter.
// GoRouter es una librería que facilita la gestión de rutas y navegación en aplicaciones Flutter.

import 'package:go_router/go_router.dart'; // Importa la librería GoRouter para la navegación.

import 'package:popcorntime/presentation/screens/screens.dart';
import 'package:popcorntime/presentation/screens/users/login_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/', // Establece la ubicación inicial al inicio de la aplicación, en este caso la pantalla principal ('/').
  routes: [
    
    // Definición de la ruta para la pantalla de inicio (HomeScreen).
    GoRoute(
      path: '/', // Ruta para la pantalla principal.
      name: HomeScreen.name, // Nombre de la ruta, utilizado para la navegación.
      builder: (context, state) =>  LoginScreen(), // Construye el widget HomeScreen cuando se accede a esta ruta.
      routes: [
         // Definición de la ruta para la pantalla de detalle de película (MovieScreen).
         GoRoute(
          path: 'movie/:id', // Ruta que recibe un parámetro dinámico 'id' que se refiere a la ID de la película.
          name: MovieScreen.name, // Nombre de la ruta, utilizado para la navegación.
          builder: (context, state) {
            // Obtiene el ID de la película de los parámetros de la ruta. Si no se encuentra, asigna 'no-id'.
            final movieId = state.params['id'] ?? 'no-id';

            // Construye el widget MovieScreen pasando el ID de la película como parámetro.
            return MovieScreen(movieId: movieId);
          },
        ),
      ]
    ),
  ]
);
