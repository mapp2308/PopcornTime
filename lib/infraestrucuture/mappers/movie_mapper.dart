
import 'package:popcorntime/domain/entities/movie.dart';
import 'package:popcorntime/infraestrucuture/moviedb/movie_details.dart';
import 'package:popcorntime/infraestrucuture/moviedb/movie_moviedb.dart';

class MovieMapper {
  
  // Método estático que convierte un objeto `MovieMovieDB` (de la respuesta de la API) en una entidad `Movie` (de la aplicación).
  static Movie movieDBToEntity(MovieMovieDB moviedb) => Movie(
    
    adult: moviedb.adult, // Indica si la película es para adultos.
    
    // Si la película tiene una imagen de fondo, se construye la URL completa. Si no, se utiliza una imagen predeterminada.
    backdropPath: (moviedb.backdropPath != '') 
      ? 'https://image.tmdb.org/t/p/w500${ moviedb.backdropPath }' 
      : 'https://sd.keepcalms.com/i-w600/keep-calm-poster-not-found.jpg',
    
    genreIds: moviedb.genreIds.map((e) => e.toString()).toList(), // Convierte los IDs de los géneros en una lista de cadenas.
    
    id: moviedb.id, // El ID de la película.
    originalLanguage: moviedb.originalLanguage, // El idioma original de la película.
    originalTitle: moviedb.originalTitle, // El título original de la película.
    overview: moviedb.overview, // Sinopsis de la película.
    popularity: moviedb.popularity, // Popularidad de la película.
    
    // Si la película tiene una imagen de póster, se construye la URL completa. Si no, se usa una imagen predeterminada.
    posterPath: (moviedb.posterPath != '')
      ? 'https://image.tmdb.org/t/p/w500${ moviedb.posterPath }'
      : 'https://www.movienewz.com/img/films/poster-holder.jpg',
    
    releaseDate: moviedb.releaseDate ?? DateTime.now(), // Fecha de estreno, si no está disponible se usa la fecha actual.
    title: moviedb.title, // El título de la película.
    video: moviedb.video, // Indica si hay un video disponible para la película.
    voteAverage: moviedb.voteAverage, // Promedio de votos de la película.
    voteCount: moviedb.voteCount // Número de votos que ha recibido la película.
  );

  // Método estático que convierte un objeto `MovieDetails` (de la respuesta de la API) en una entidad `Movie` (de la aplicación).
  static Movie movieDetailsToEntity(MovieDetails moviedb) => Movie(
    adult: moviedb.adult, // Indica si la película es para adultos.
    
    // Si la película tiene una imagen de fondo, se construye la URL completa. Si no, se utiliza una imagen predeterminada.
    backdropPath: (moviedb.backdropPath != '') 
      ? 'https://image.tmdb.org/t/p/w500${ moviedb.backdropPath }' 
      : 'https://sd.keepcalms.com/i-w600/keep-calm-poster-not-found.jpg',
    
    // Los géneros de la película se mapean como nombres de géneros.
    genreIds: moviedb.genres.map((e) => e.name).toList(),
    
    id: moviedb.id, // El ID de la película.
    originalLanguage: moviedb.originalLanguage, // El idioma original de la película.
    originalTitle: moviedb.originalTitle, // El título original de la película.
    overview: moviedb.overview, // Sinopsis de la película.
    popularity: moviedb.popularity, // Popularidad de la película.
    
    // Si la película tiene una imagen de póster, se construye la URL completa. Si no, se usa una imagen predeterminada.
    posterPath: (moviedb.posterPath != '')
      ? 'https://image.tmdb.org/t/p/w500${ moviedb.posterPath }'
      : 'https://sd.keepcalms.com/i-w600/keep-calm-poster-not-found.jpg',
    
    releaseDate: moviedb.releaseDate, // Fecha de estreno de la película.
    title: moviedb.title, // El título de la película.
    video: moviedb.video, // Indica si hay un video disponible para la película.
    voteAverage: moviedb.voteAverage, // Promedio de votos de la película.
    voteCount: moviedb.voteCount // Número de votos que ha recibido la película.
  );
}
