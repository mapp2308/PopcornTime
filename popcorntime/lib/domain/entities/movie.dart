// Esta clase representa una película, con todos los datos relevantes obtenidos de una API o base de datos.

class Movie {
  
  // Indica si la película es para adultos (contenido restringido).
  final bool adult;
  // Ruta de la imagen de fondo (backdrop) de la película.
  final String backdropPath;
  // Lista de IDs de los géneros de la película.
  final List<String> genreIds;
  // ID único de la película.
  final int id;
  // El idioma original en que fue creada la película.
  final String originalLanguage;
  // Título original de la película.
  final String originalTitle;
  // Descripción o resumen de la película.
  final String overview;
  // Popularidad de la película (basada en métricas externas).
  final double popularity;
  // Ruta de la imagen del póster de la película.
  final String posterPath;
  // Fecha de estreno de la película.
  final DateTime releaseDate;
  // Título de la película.
  final String title;
  // Indica si la película es un video (puede estar relacionado con contenido especial).
  final bool video;
  // Promedio de votos de los usuarios para la película.
  final double voteAverage;
  // Número total de votos recibidos por la película.
  final int voteCount;

  // Constructor que inicializa todos los campos de la clase.
  // Se requiere el valor para cada uno de los parámetros.
  Movie({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount
  });
}
