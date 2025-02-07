// Esta es una clase abstracta que define la interfaz para la obtención de datos de películas.
// El propósito de esta clase es ser implementada por una clase que se encargue de obtener datos de películas desde una fuente de datos, como una API o base de datos.

import 'package:popcorntime/domain/entities/movie.dart';

abstract class MoviesDatasource {

  // Método para obtener una lista de películas que están en reproducción actualmente (Now Playing).
  // El parámetro `page` es opcional y por defecto es 1, permite paginar los resultados.
  Future<List<Movie>> getNowPlaying({ int page = 1 });

  // Método para obtener una lista de películas populares.
  // El parámetro `page` es opcional y por defecto es 1, permite paginar los resultados.
  Future<List<Movie>> getPopular({ int page = 1 });

  // Método para obtener una lista de películas próximas a estrenarse (Upcoming).
  // El parámetro `page` es opcional y por defecto es 1, permite paginar los resultados.
  Future<List<Movie>> getUpcoming({ int page = 1 });

  // Método para obtener una lista de las películas mejor valoradas (Top Rated).
  // El parámetro `page` es opcional y por defecto es 1, permite paginar los resultados.
  Future<List<Movie>> getTopRated({ int page = 1 });

  // Método para obtener los detalles de una película específica usando su ID.
  Future<Movie> getMovieById(String id);

  // Método para buscar películas por un término de búsqueda (query).
  Future<List<Movie>> searchMovies(String query);
}
