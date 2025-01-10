import 'movie_moviedb.dart';

class MovieDbResponse {
  MovieDbResponse({
    required this.dates, // Fechas de disponibilidad de las películas.
    required this.page, // Número de página de resultados.
    required this.results, // Lista de resultados de películas.
    required this.totalPages, // Número total de páginas.
    required this.totalResults, // Número total de resultados.
  });

  final Dates? dates; // Fechas de disponibilidad (puede ser nula).
  final int page; // Número de la página actual de resultados.
  final List<MovieMovieDB> results; // Lista de películas.
  final int totalPages; // Número total de páginas de resultados.
  final int totalResults; // Número total de resultados encontrados.

  // Método de fábrica para crear un objeto `MovieDbResponse` desde un mapa JSON.
  factory MovieDbResponse.fromJson(Map<String, dynamic> json) => MovieDbResponse(
    dates: json["dates"] != null ? Dates.fromJson(json["dates"]) : null, // Si `dates` existe, crea un objeto `Dates`.
    page: json["page"], // Número de página actual.
    results: List<MovieMovieDB>.from(json["results"].map((x) => MovieMovieDB.fromJson(x))), // Lista de películas.
    totalPages: json["total_pages"], // Número total de páginas.
    totalResults: json["total_results"], // Número total de resultados.
  );

  // Método para convertir un objeto `MovieDbResponse` a un mapa JSON.
  Map<String, dynamic> toJson() => {
    "dates": dates?.toJson(), // Convierte las fechas a formato JSON (si no son nulas).
    "page": page, // Número de página.
    "results": List<dynamic>.from(results.map((x) => x.toJson())), // Convierte la lista de películas a formato JSON.
    "total_pages": totalPages, // Número total de páginas.
    "total_results": totalResults, // Número total de resultados.
  };
}

class Dates {
  Dates({
    required this.maximum, // Fecha máxima de disponibilidad.
    required this.minimum, // Fecha mínima de disponibilidad.
  });

  final DateTime maximum; // Fecha máxima.
  final DateTime minimum; // Fecha mínima.

  // Método de fábrica para crear un objeto `Dates` desde un mapa JSON.
  factory Dates.fromJson(Map<String, dynamic> json) => Dates(
    maximum: DateTime.parse(json["maximum"]), // Convierte la fecha máxima a `DateTime`.
    minimum: DateTime.parse(json["minimum"]), // Convierte la fecha mínima a `DateTime`.
  );

  // Método para convertir un objeto `Dates` a un mapa JSON.
  Map<String, dynamic> toJson() => {
    "maximum": "${maximum.year.toString().padLeft(4, '0')}-${maximum.month.toString().padLeft(2, '0')}-${maximum.day.toString().padLeft(2, '0')}", // Convierte la fecha máxima a formato de cadena.
    "minimum": "${minimum.year.toString().padLeft(4, '0')}-${minimum.month.toString().padLeft(2, '0')}-${minimum.day.toString().padLeft(2, '0')}", // Convierte la fecha mínima a formato de cadena.
  };
}
