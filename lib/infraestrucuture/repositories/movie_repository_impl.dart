
import 'package:popcorntime/domain/datasource/movies_datasource.dart';
import 'package:popcorntime/domain/entities/movie.dart';
import 'package:popcorntime/domain/repositories/movies_repository.dart';

// Implementación del repositorio de películas, que interactúa con el datasource para obtener datos de películas
class MovieRepositoryImpl extends MoviesRepository {

  // El repositorio depende de un datasource para obtener los datos de películas.
  final MoviesDatasource datasource;
  
  // El constructor toma un MoviesDatasource como dependencia.
  // Esto permite que el repositorio se comunique con la fuente de datos.
  MovieRepositoryImpl(this.datasource);

  // Obtiene las películas que están actualmente en cines.
  // El parámetro `page` se usa para la paginación (valor por defecto es 1).
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    // Llama al datasource para obtener las películas en cines.
    return datasource.getNowPlaying(page: page);
  }

  // Obtiene las películas más populares.
  // El parámetro `page` se usa para la paginación (valor por defecto es 1).
  @override
  Future<List<Movie>> getPopular({int page = 1}) {
    // Llama al datasource para obtener las películas populares.
    return datasource.getPopular(page: page);
  }

  // Obtiene las películas mejor valoradas.
  // El parámetro `page` se usa para la paginación (valor por defecto es 1).
  @override
  Future<List<Movie>> getTopRated({int page = 1}) {
    // Llama al datasource para obtener las películas mejor valoradas.
    return datasource.getTopRated(page: page);
  }

  // Obtiene las películas que se van a estrenar próximamente.
  // El parámetro `page` se usa para la paginación (valor por defecto es 1).
  @override
  Future<List<Movie>> getUpcoming({int page = 1}) {
    // Llama al datasource para obtener las películas próximas a estrenar.
    return datasource.getUpcoming(page: page);
  }

  // Obtiene los detalles de una película por su ID.
  @override
  Future<Movie> getMovieById(String id) {
    // Llama al datasource para obtener una película específica usando su ID.
    return datasource.getMovieById(id);
  }

  // Realiza una búsqueda de películas basándose en un término de búsqueda.
  @override
  Future<List<Movie>> searchMovies(String query) {
    // Llama al datasource para buscar películas que coincidan con el término de búsqueda.
    return datasource.searchMovies(query);
  }
}
