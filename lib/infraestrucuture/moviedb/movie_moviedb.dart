// Define la clase `MovieMovieDB` que representa los detalles básicos de una película.
class MovieMovieDB {
  MovieMovieDB({
    required this.adult, // Si la película es para adultos.
    required this.backdropPath, // Ruta de la imagen de fondo de la película.
    required this.genreIds, // Lista de IDs de géneros de la película.
    required this.id, // ID único de la película.
    required this.originalLanguage, // Idioma original de la película.
    required this.originalTitle, // Título original de la película.
    required this.overview, // Resumen o descripción de la película.
    required this.popularity, // Popularidad de la película.
    required this.posterPath, // Ruta del póster de la película.
    required this.releaseDate, // Fecha de lanzamiento de la película.
    required this.title, // Título de la película.
    required this.video, // Si la película tiene un video oficial.
    required this.voteAverage, // Promedio de calificación de la película.
    required this.voteCount, // Número de votos que ha recibido la película.
  });

  final bool adult; // Si la película es para adultos.
  final String backdropPath; // Ruta de la imagen de fondo de la película.
  final List<int> genreIds; // Lista de IDs de géneros asociados con la película.
  final int id; // ID único de la película.
  final String originalLanguage; // Idioma original de la película.
  final String originalTitle; // Título original de la película.
  final String overview; // Descripción o resumen de la película.
  final double popularity; // Popularidad de la película.
  final String posterPath; // Ruta al póster de la película.
  final DateTime? releaseDate; // Fecha de lanzamiento de la película (puede ser nula).
  final String title; // Título de la película.
  final bool video; // Si la película tiene un video oficial.
  final double voteAverage; // Promedio de votos.
  final int voteCount; // Número de votos recibidos.

  // Método de fábrica para crear un objeto `MovieMovieDB` desde un mapa JSON.
  factory MovieMovieDB.fromJson(Map<String, dynamic> json) => MovieMovieDB(
    adult: json["adult"] ?? false, // Si no existe, se asume como falso.
    backdropPath: json["backdrop_path"] ?? '', // Si no existe, se asume cadena vacía.
    genreIds: List<int>.from(json["genre_ids"].map((x) => x)), // Convierte los IDs de género a una lista de enteros.
    id: json["id"], // ID único de la película.
    originalLanguage: json["original_language"] ?? '', // Si no existe, se asume cadena vacía.
    originalTitle: json["original_title"] ?? '', // Si no existe, se asume cadena vacía.
    overview: json["overview"] ?? '', // Si no existe, se asume cadena vacía.
    popularity: json["popularity"]?.toDouble() ?? 0, // Si no existe, se asume 0.
    posterPath: json["poster_path"] ?? '', // Si no existe, se asume cadena vacía.
    releaseDate: json["release_date"] != null && json["release_date"].toString().isNotEmpty
      ? DateTime.parse(json["release_date"]) // Si existe una fecha válida, se convierte a `DateTime`.
      : null, // Si no existe, se asigna `null`.
    title: json["title"] ?? 'No Title', // Si no existe, se asigna un título por defecto.
    video: json["video"] ?? false, // Si no existe, se asume como falso.
    voteAverage: json["vote_average"]?.toDouble() ?? 0, // Si no existe, se asume 0.
    voteCount: json["vote_count"] ?? 0, // Si no existe, se asume 0.
  );

  // Método para convertir un objeto `MovieMovieDB` a un mapa JSON.
  Map<String, dynamic> toJson() => {
    "adult": adult, // Propiedad `adult`.
    "backdrop_path": backdropPath, // Propiedad `backdropPath`.
    "genre_ids": List<dynamic>.from(genreIds.map((x) => x)), // Convierte la lista de IDs de géneros a un formato JSON.
    "id": id, // Propiedad `id`.
    "original_language": originalLanguage, // Propiedad `originalLanguage`.
    "original_title": originalTitle, // Propiedad `originalTitle`.
    "overview": overview, // Propiedad `overview`.
    "popularity": popularity, // Propiedad `popularity`.
    "poster_path": posterPath, // Propiedad `posterPath`.
    "release_date": (releaseDate != null)
      ? "${releaseDate!.year.toString().padLeft(4, '0')}-${releaseDate!.month.toString().padLeft(2, '0')}-${releaseDate!.day.toString().padLeft(2, '0')}"
      : null, // Convierte la fecha de lanzamiento a un formato adecuado para JSON (si es válida).
    "title": title, // Propiedad `title`.
    "video": video, // Propiedad `video`.
    "vote_average": voteAverage, // Propiedad `voteAverage`.
    "vote_count": voteCount, // Propiedad `voteCount`.
  };
}
