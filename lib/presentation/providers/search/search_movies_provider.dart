import 'package:flutter_riverpod/flutter_riverpod.dart'; // Importa Riverpod para la gestión del estado
import 'package:popcorntime/domain/entities/movie.dart'; // Importa la entidad Movie
import 'package:popcorntime/presentation/providers/providers.dart'; // Importa los proveedores de la aplicación

// Este código maneja la búsqueda de películas en la aplicación utilizando Riverpod.
// - `searchQueryProvider`: almacena la consulta de búsqueda actual.
// - `searchedMoviesProvider`: maneja el estado de las películas encontradas.
// - `SearchedMoviesNotifier`: obtiene películas basadas en una consulta y actualiza el estado con los resultados.

/// Proveedor que almacena la consulta de búsqueda actual como un `String`
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Proveedor que maneja la búsqueda de películas
final searchedMoviesProvider = StateNotifierProvider<SearchedMoviesNotifier, List<Movie>>((ref) {
  final movieRepository = ref.read(movieRepositoryProvider); // Obtiene el repositorio de películas
  return SearchedMoviesNotifier(
    searchMovies: movieRepository.searchMovies, 
    ref: ref
  );
});

/// Tipo de función que realiza una búsqueda de películas con una consulta `query`
typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

/// Notifier encargado de gestionar la búsqueda de películas
class SearchedMoviesNotifier extends StateNotifier<List<Movie>> {
  
  final SearchMoviesCallback searchMovies; // Callback para realizar la búsqueda
  final Ref ref; // Referencia a los proveedores

  SearchedMoviesNotifier({
    required this.searchMovies,
    required this.ref,
  }) : super([]); // Estado inicial vacío

  /// Realiza una búsqueda de películas según la consulta `query`
  Future<List<Movie>> searchMoviesByQuery(String query) async {
    
    final List<Movie> movies = await searchMovies(query); // Obtiene las películas desde el repositorio
    ref.read(searchQueryProvider.notifier).update((state) => query); // Actualiza la consulta en el estado global

    state = movies; // Actualiza el estado con los resultados obtenidos
    return movies;
  }
}
