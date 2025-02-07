import 'dart:async';

import 'package:popcorntime/config/helpers/human_formats.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:popcorntime/domain/entities/movie.dart';

// Esta clase implementa un `SearchDelegate` para buscar películas de manera dinámica.
// Utiliza `StreamController` para gestionar las búsquedas con debounce y actualizar los resultados en tiempo real.
// Se usa `animate_do` para animaciones en los íconos de carga.
// La clase `_MovieItem` representa un elemento individual en la lista de resultados.

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query); // Tipo de función para buscar películas

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  
  final SearchMoviesCallback searchMovies; // Función que obtiene películas basadas en la búsqueda
  List<Movie> initialMovies; // Lista de películas iniciales antes de la búsqueda
  
  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast(); // Stream para manejar los resultados de búsqueda con debounce
  StreamController<bool> isLoadingStream = StreamController.broadcast(); // Stream para manejar el estado de carga

  Timer? _debounceTimer; // Temporizador para manejar debounce en la búsqueda

  SearchMovieDelegate({
    required this.searchMovies,
    required this.initialMovies,
  }) : super(
    searchFieldLabel: 'Buscar películas', // Texto dentro del campo de búsqueda
  );

  // Cierra los streams cuando ya no se necesitan
  void clearStreams() {
    debouncedMovies.close();
    isLoadingStream.close();
  }

  // Maneja los cambios en la consulta del usuario con debounce
  void _onQueryChanged(String query) {
    isLoadingStream.add(true); // Indica que la búsqueda está en curso

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final movies = await searchMovies(query); // Obtiene las películas basadas en la búsqueda
      initialMovies = movies;
      debouncedMovies.add(movies); // Emite los resultados al stream
      isLoadingStream.add(false); // Indica que la búsqueda ha finalizado
    });
  }

  // Construye los resultados y sugerencias de búsqueda
  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
      initialData: initialMovies,
      stream: debouncedMovies.stream,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) => _MovieItem(
            movie: movies[index],
            onMovieSelected: (context, movie) {
              clearStreams();
              close(context, movie); // Cierra el SearchDelegate y devuelve la película seleccionada
            },
          ),
        );
      },
    );
  }

  // Botones de acciones en la barra de búsqueda
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return SpinPerfect(
              duration: const Duration(seconds: 20),
              spins: 10,
              infinite: true,
              child: IconButton(
                onPressed: () => query = '',
                icon: const Icon(Icons.refresh_rounded),
              ),
            );
          }

          return FadeIn(
            animate: query.isNotEmpty,
            child: IconButton(
              onPressed: () => query = '',
              icon: const Icon(Icons.clear),
            ),
          );
        },
      ),
    ];
  }

  // Botón de regreso en la barra de búsqueda
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        clearStreams();
        close(context, null); // Cierra la búsqueda sin seleccionar nada
      },
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
    );
  }

  // Muestra los resultados basados en la búsqueda
  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions();
  }

  // Muestra sugerencias mientras se escribe
  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query); // Actualiza los resultados basados en el input del usuario
    return buildResultsAndSuggestions();
  }
}

// Representa un elemento de película en la lista de resultados
class _MovieItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected; // Callback cuando se selecciona una película

  const _MovieItem({
    required this.movie,
    required this.onMovieSelected,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie); // Llama a la función cuando se selecciona una película
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            // Imagen de la película
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10), // Borde redondeado
                child: Image.network(
                  movie.posterPath,
                  loadingBuilder: (context, child, loadingProgress) => FadeIn(child: child), // Animación al cargar la imagen
                ),
              ),
            ),

            const SizedBox(width: 10),

            // Descripción de la película
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: textStyles.titleMedium),

                  // Muestra la descripción corta o completa según su longitud
                  (movie.overview.length > 100)
                      ? Text('${movie.overview.substring(0, 100)}...')
                      : Text(movie.overview),

                  // Muestra el puntaje de la película con un ícono de estrella
                  Row(
                    children: [
                      Icon(Icons.star_half_rounded, color: Colors.yellow.shade800),
                      const SizedBox(width: 5),
                      Text(
                        HumanFormats.number(movie.voteAverage, 1), // Formatea el puntaje numérico
                        style: textStyles.bodyMedium!.copyWith(color: Colors.yellow.shade900),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
