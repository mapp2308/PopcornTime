import 'package:popcorntime/presentation/providers/providers.dart'; // Importa el archivo de proveedores de la aplicación
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Importa Riverpod para la gestión del estado
import 'package:popcorntime/domain/entities/movie.dart'; // Importa la entidad Movie

// Este código define un `StateNotifierProvider` llamado `movieInfoProvider`, 
// que maneja el estado de información de películas en un `Map<String, Movie>`.
// Utiliza `MovieMapNotifier` para administrar el estado y cargar los datos de películas 
// de manera eficiente, evitando múltiples solicitudes innecesarias al backend.
// `loadMovie` obtiene información de una película solo si aún no está almacenada en el estado.

final movieInfoProvider = StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {
  final movieRepository = ref.watch(movieRepositoryProvider); // Obtiene el repositorio de películas
  return MovieMapNotifier(getMovie: movieRepository.getMovieById); // Inicializa el Notifier con el método para obtener películas por ID
});

/*
  Ejemplo de cómo se almacenan los datos en el estado:
  {
    '505642': Movie(),  // Información de la película con ID 505642
    '505643': Movie(),  // Información de la película con ID 505643
    '505645': Movie(),  // Información de la película con ID 505645
    '501231': Movie(),  // Información de la película con ID 501231
  }
*/

// Tipo de función que obtiene una película por su ID
typedef GetMovieCallback = Future<Movie> Function(String movieId);

// Notifier encargado de manejar el estado de las películas por su ID
class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {

  final GetMovieCallback getMovie; // Callback para obtener una película desde el repositorio

  MovieMapNotifier({
    required this.getMovie,
  }) : super({}); // Estado inicial vacío

  // Carga la información de una película si aún no ha sido cargada
  Future<void> loadMovie(String movieId) async {
    if (state[movieId] != null) return; // Si la película ya está en el estado, no la vuelve a cargar

    final movie = await getMovie(movieId); // Obtiene la película desde el repositorio
    state = {...state, movieId: movie}; // Agrega la película al estado sin perder las ya almacenadas
  }
}
