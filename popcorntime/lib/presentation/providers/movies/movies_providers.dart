import 'package:popcorntime/domain/entities/movie.dart'; // Importa la entidad Movie
import 'package:popcorntime/presentation/providers/movies/movies_repository_provider.dart'; // Importa el proveedor del repositorio de películas
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Importa Riverpod para la gestión del estado

// Este código define múltiples `StateNotifierProviders` para manejar diferentes categorías de películas: 
// - `nowPlayingMoviesProvider` (Películas en cartelera)
// - `popularMoviesProvider` (Películas populares)
// - `upcomingMoviesProvider` (Próximos estrenos)
// - `topRatedMoviesProvider` (Películas mejor valoradas)
//
// Cada proveedor usa `MoviesNotifier`, que maneja la paginación y la obtención de más películas cuando es necesario.
// Se evita realizar múltiples llamadas innecesarias utilizando `isLoading` para controlar las peticiones.

/// Proveedor para las películas en cartelera
final nowPlayingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

/// Proveedor para las películas populares
final popularMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getPopular;
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

/// Proveedor para los próximos estrenos
final upcomingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getUpcoming;
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

/// Proveedor para las películas mejor valoradas
final topRatedMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getTopRated;
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

/// Tipo de función que obtiene una lista de películas paginadas
typedef MovieCallback = Future<List<Movie>> Function({int page});

/// Notifier que maneja el estado de una lista de películas y la paginación
class MoviesNotifier extends StateNotifier<List<Movie>> {
  
  int currentPage = 0; // Página actual en la paginación
  bool isLoading = false; // Bandera para evitar múltiples solicitudes simultáneas
  MovieCallback fetchMoreMovies; // Callback para obtener más películas

  MoviesNotifier({
    required this.fetchMoreMovies,
  }) : super([]); // Estado inicial vacío

  /// Obtiene la siguiente página de películas y las agrega al estado
  Future<void> loadNextPage() async {
    if (isLoading) return; // Evita múltiples llamadas simultáneas
    isLoading = true;

    currentPage++; // Incrementa el número de página
    final List<Movie> movies = await fetchMoreMovies(page: currentPage); // Obtiene películas
    state = [...state, ...movies]; // Agrega las nuevas películas sin eliminar las anteriores
    
    await Future.delayed(const Duration(milliseconds: 300)); // Simula un pequeño retraso en la carga
    isLoading = false;
  }
}
