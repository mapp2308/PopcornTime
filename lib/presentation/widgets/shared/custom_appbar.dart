import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Estado global con Riverpod
import 'package:go_router/go_router.dart'; // Navegación con GoRouter
import 'package:popcorntime/domain/entities/movie.dart'; // Entidad Movie
import 'package:popcorntime/presentation/delegates/search_movie_delegate.dart'; // Delegate para búsqueda
import 'package:popcorntime/presentation/providers/providers.dart'; // Providers de estado

// Este widget (`CustomAppbar`) es una barra de navegación personalizada para la aplicación.
// - Muestra el logo de la app y un botón de búsqueda.
// - Usa `showSearch` para abrir un buscador de películas con `SearchMovieDelegate`.
// - La búsqueda mantiene el estado usando `Riverpod` con `searchedMoviesProvider` y `searchQueryProvider`.
// - Navega a la pantalla de detalles de la película cuando se selecciona un resultado de búsqueda.

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme; // Obtiene los colores del tema actual
    final titleStyle = Theme.of(context).textTheme.titleMedium; // Estilo del título

    return SafeArea(
        bottom: false, // Evita recortes en la parte superior en dispositivos con notch
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10), // Margen horizontal
          child: SizedBox(
            width: double.infinity, // Ocupa todo el ancho disponible
            child: Row(
              children: [
                Icon(Icons.movie_outlined, color: colors.primary), // Ícono de la app
                const SizedBox(width: 5),
                Text('PopCornTime', style: titleStyle), // Nombre de la app
                const Spacer(), // Empuja el botón de búsqueda hacia la derecha

                // Botón de búsqueda
                IconButton(
                    onPressed: () {
                      final searchedMovies = ref.read(searchedMoviesProvider); // Obtiene películas buscadas anteriormente
                      final searchQuery = ref.read(searchQueryProvider); // Obtiene la última consulta de búsqueda

                      // Muestra el cuadro de búsqueda
                      showSearch<Movie?>(
                              query: searchQuery, // Usa la última consulta de búsqueda
                              context: context,
                              delegate: SearchMovieDelegate(
                                  initialMovies: searchedMovies,
                                  searchMovies: ref
                                      .read(searchedMoviesProvider.notifier)
                                      .searchMoviesByQuery)) // Función para buscar películas
                          .then((movie) {
                        if (movie == null) return; // Si no se selecciona una película, no hace nada

                        context.push('/movie/${movie.id}'); // Navega a la pantalla de detalles de la película
                      });
                    },
                    icon: const Icon(Icons.search)) // Ícono de búsqueda
              ],
            ),
          ),
        ));
  }
}
