// Esta clase implementa la interfaz `MoviesDatasource` y se encarga de obtener la información sobre las películas desde la API de The Movie Database (TMDb).

import 'package:popcorntime/domain/datasource/movies_datasource.dart';
import 'package:popcorntime/infraestrucuture/mappers/movie_mapper.dart';
import 'package:popcorntime/infraestrucuture/moviedb/movie_details.dart';
import 'package:popcorntime/infraestrucuture/moviedb/moviedb_response.dart';
import 'package:dio/dio.dart'; // Importa la librería Dio para hacer peticiones HTTP.

import 'package:popcorntime/config/constants/environment.dart'; // Importa las variables de entorno (como la API key).
import 'package:popcorntime/domain/entities/movie.dart';

class MoviedbDatasource extends MoviesDatasource {

  // Instancia de Dio para realizar peticiones HTTP a la API de TMDb.
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3', // URL base de la API de TMDb.
    queryParameters: {
      'api_key': Environment.theMovieDbKey, // API Key obtenida desde las variables de entorno.
      'language': 'es-MX' // Idioma de la respuesta (español de México).
    }
  ));

  // Método privado para convertir la respuesta JSON de la API a una lista de entidades `Movie`.
  List<Movie> _jsonToMovies( Map<String,dynamic> json ) {

    // Convierte la respuesta JSON en un objeto `MovieDbResponse`.
    final movieDBResponse = MovieDbResponse.fromJson(json);

    // Filtra las películas que tienen un poster disponible y las convierte a objetos `Movie`.
    final List<Movie> movies = movieDBResponse.results
    .where((moviedb) => moviedb.posterPath != 'no-poster' ) // Filtra las películas sin poster.
    .map(
      (moviedb) => MovieMapper.movieDBToEntity(moviedb) // Mapea los datos de la API a entidades `Movie`.
    ).toList();

    return movies; // Retorna la lista de películas convertidas.
  }

  // Método para obtener las películas que están actualmente en cartelera (now playing).
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    
    // Hace una petición GET a la API para obtener las películas que están en cartelera.
    final response = await dio.get('/movie/now_playing', 
      queryParameters: {
        'page': page // El número de página para la paginación.
      }
    );
    
    return _jsonToMovies(response.data); // Convierte la respuesta JSON en una lista de películas y la devuelve.
  }
  
  // Método para obtener las películas de una categoría (puede ser una categoría de películas).
  Future<List<Movie>> getCategory({int page = 1}) async {
    
    // Hace una petición GET a la API para obtener las películas de la categoría seleccionada.
    final response = await dio.get('/movie/now_playing', 
      queryParameters: {
        'page': page // El número de página para la paginación.
      }
    );
    
    return _jsonToMovies(response.data); // Convierte la respuesta JSON en una lista de películas y la devuelve.
  }

  // Método para obtener las películas populares.
  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
     
    // Hace una petición GET a la API para obtener las películas populares.
    final response = await dio.get('/movie/popular', 
      queryParameters: {
        'page': page // El número de página para la paginación.
      }
    );

    return _jsonToMovies(response.data); // Convierte la respuesta JSON en una lista de películas y la devuelve.
  }

  // Método para obtener las películas mejor valoradas (top rated).
  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
     
    // Hace una petición GET a la API para obtener las películas mejor valoradas.
    final response = await dio.get('/movie/top_rated', 
      queryParameters: {
        'page': page // El número de página para la paginación.
      }
    );

    return _jsonToMovies(response.data); // Convierte la respuesta JSON en una lista de películas y la devuelve.
  }

  // Método para obtener las películas que están por estrenarse (upcoming).
  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
     
    // Hace una petición GET a la API para obtener las películas por estrenarse.
    final response = await dio.get('/movie/upcoming', 
      queryParameters: {
        'page': page // El número de página para la paginación.
      }
    );

    return _jsonToMovies(response.data); // Convierte la respuesta JSON en una lista de películas y la devuelve.
  }

  // Método para obtener una película por su ID.
  @override
  Future<Movie> getMovieById( String id ) async {

    // Hace una petición GET a la API para obtener los detalles de una película específica.
    final response = await dio.get('/movie/$id');
    if ( response.statusCode != 200 ) throw Exception('Movie with id: $id not found');
    
    // Convierte la respuesta JSON en un objeto `MovieDetails`.
    final movieDetails = MovieDetails.fromJson( response.data );
    // Mapea los detalles de la película a una entidad `Movie`.
    final Movie movie = MovieMapper.movieDetailsToEntity(movieDetails);
    return movie; // Retorna la película obtenida.
  }
  
  // Método para buscar películas por una cadena de texto (query).
  @override
  Future<List<Movie>> searchMovies(String query) async{

    // Si la cadena de búsqueda está vacía, retornamos una lista vacía.
    if ( query.isEmpty ) return [];

    // Hace una petición GET a la API para obtener las películas que coinciden con la búsqueda.
    final response = await dio.get('/search/movie', 
      queryParameters: {
        'query': query
      }
    );

    return _jsonToMovies(response.data); // Convierte la respuesta JSON en una lista de películas y la devuelve.
  }
}
