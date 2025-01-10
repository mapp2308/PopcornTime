// Define la clase `MovieDetails`, que contiene los detalles completos de una película.
class MovieDetails {
  MovieDetails({
    required this.adult,
    required this.backdropPath,
    required this.belongsToCollection,
    required this.budget,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.imdbId,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.productionCompanies,
    required this.productionCountries,
    required this.releaseDate,
    required this.revenue,
    required this.runtime,
    required this.spokenLanguages,
    required this.status,
    required this.tagline,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  final bool adult; // Si la película es para adultos.
  final String backdropPath; // Ruta al fondo de la imagen (poster de la película).
  final BelongsToCollection? belongsToCollection; // La colección a la que pertenece la película (si aplica).
  final int budget; // Presupuesto de la película.
  final List<Genre> genres; // Lista de géneros de la película.
  final String homepage; // Página web oficial de la película.
  final int id; // ID de la película.
  final String imdbId; // ID de IMDb de la película.
  final String originalLanguage; // Idioma original de la película.
  final String originalTitle; // Título original de la película.
  final String overview; // Descripción de la película.
  final double popularity; // Popularidad de la película.
  final String posterPath; // Ruta al póster de la película.
  final List<ProductionCompany> productionCompanies; // Compañías de producción de la película.
  final List<ProductionCountry> productionCountries; // Países de producción de la película.
  final DateTime releaseDate; // Fecha de lanzamiento de la película.
  final int revenue; // Ingresos generados por la película.
  final int runtime; // Duración de la película en minutos.
  final List<SpokenLanguage> spokenLanguages; // Idiomas hablados en la película.
  final String status; // Estado de la película (ejemplo: 'Released', 'Post-production').
  final String tagline; // Lema de la película.
  final String title; // Título de la película.
  final bool video; // Si existe un video oficial de la película.
  final double voteAverage; // Promedio de votos.
  final int voteCount; // Número de votos recibidos.

  // Método de fábrica para crear un objeto `MovieDetails` a partir de un mapa JSON.
  factory MovieDetails.fromJson(Map<String, dynamic> json) => MovieDetails(
    adult: json["adult"],
    backdropPath: json["backdrop_path"] ?? '',
    belongsToCollection: json["belongs_to_collection"] == null ? null : BelongsToCollection.fromJson(json["belongs_to_collection"]),
    budget: json["budget"],
    genres: List<Genre>.from(json["genres"].map((x) => Genre.fromJson(x))),
    homepage: json["homepage"],
    id: json["id"],
    imdbId: json["imdb_id"],
    originalLanguage: json["original_language"],
    originalTitle: json["original_title"],
    overview: json["overview"],
    popularity: json["popularity"]?.toDouble(),
    posterPath: json["poster_path"],
    productionCompanies: List<ProductionCompany>.from(json["production_companies"].map((x) => ProductionCompany.fromJson(x))),
    productionCountries: List<ProductionCountry>.from(json["production_countries"].map((x) => ProductionCountry.fromJson(x))),
    releaseDate: DateTime.parse(json["release_date"]),
    revenue: json["revenue"],
    runtime: json["runtime"],
    spokenLanguages: List<SpokenLanguage>.from(json["spoken_languages"].map((x) => SpokenLanguage.fromJson(x))),
    status: json["status"],
    tagline: json["tagline"],
    title: json["title"],
    video: json["video"],
    voteAverage: json["vote_average"]?.toDouble(),
    voteCount: json["vote_count"],
  );

  // Método para convertir un objeto `MovieDetails` a un mapa JSON.
  Map<String, dynamic> toJson() => {
    "adult": adult,
    "backdrop_path": backdropPath,
    "belongs_to_collection": belongsToCollection?.toJson(),
    "budget": budget,
    "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
    "homepage": homepage,
    "id": id,
    "imdb_id": imdbId,
    "original_language": originalLanguage,
    "original_title": originalTitle,
    "overview": overview,
    "popularity": popularity,
    "poster_path": posterPath,
    "production_companies": List<dynamic>.from(productionCompanies.map((x) => x.toJson())),
    "production_countries": List<dynamic>.from(productionCountries.map((x) => x.toJson())),
    "release_date": "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
    "revenue": revenue,
    "runtime": runtime,
    "spoken_languages": List<dynamic>.from(spokenLanguages.map((x) => x.toJson())),
    "status": status,
    "tagline": tagline,
    "title": title,
    "video": video,
    "vote_average": voteAverage,
    "vote_count": voteCount,
  };
}

// Define la clase `BelongsToCollection` que describe la colección a la que pertenece una película.
class BelongsToCollection {
  BelongsToCollection({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.backdropPath,
  });

  final int id;
  final String name;
  final String posterPath;
  final String backdropPath;

  // Método de fábrica para crear un objeto `BelongsToCollection` desde un mapa JSON.
  factory BelongsToCollection.fromJson(Map<String, dynamic> json) => BelongsToCollection(
    id: json["id"],
    name: json["name"],
    posterPath: json["poster_path"],
    backdropPath: json["backdrop_path"],
  );

  // Método para convertir un objeto `BelongsToCollection` a un mapa JSON.
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "poster_path": posterPath,
    "backdrop_path": backdropPath,
  };
}

// Define la clase `Genre` que representa un género en la película.
class Genre {
  Genre({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  // Método de fábrica para crear un objeto `Genre` a partir de un mapa JSON.
  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
    id: json["id"],
    name: json["name"],
  );

  // Método para convertir un objeto `Genre` a un mapa JSON.
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

// Define la clase `ProductionCompany` que representa una compañía de producción.
class ProductionCompany {
  ProductionCompany({
    required this.id,
    required this.logoPath,
    required this.name,
    required this.originCountry,
  });

  final int id;
  final String? logoPath;
  final String name;
  final String originCountry;

  // Método de fábrica para crear un objeto `ProductionCompany` desde un mapa JSON.
  factory ProductionCompany.fromJson(Map<String, dynamic> json) => ProductionCompany(
    id: json["id"],
    logoPath: json["logo_path"],
    name: json["name"],
    originCountry: json["origin_country"],
  );

  // Método para convertir un objeto `ProductionCompany` a un mapa JSON.
  Map<String, dynamic> toJson() => {
    "id": id,
    "logo_path": logoPath,
    "name": name,
    "origin_country": originCountry,
  };
}

// Define la clase `ProductionCountry` que representa un país de producción.
class ProductionCountry {
  ProductionCountry({
    required this.iso31661,
    required this.name,
  });

  final String iso31661;
  final String name;

  // Método de fábrica para crear un objeto `ProductionCountry` desde un mapa JSON.
  factory ProductionCountry.fromJson(Map<String, dynamic> json) => ProductionCountry(
    iso31661: json["iso_3166_1"],
    name: json["name"],
  );

  // Método para convertir un objeto `ProductionCountry` a un mapa JSON.
  Map<String, dynamic> toJson() => {
    "iso_3166_1": iso31661,
    "name": name,
  };
}

// Define la clase `SpokenLanguage` que representa un idioma hablado en la película.
class SpokenLanguage {
  SpokenLanguage({
    required this.englishName,
    required this.iso6391,
    required this.name,
  });

  final String englishName;
  final String iso6391;
  final String name;

  // Método de fábrica para crear un objeto `SpokenLanguage` desde un mapa JSON.
  factory SpokenLanguage.fromJson(Map<String, dynamic> json) => SpokenLanguage(
    englishName: json["english_name"],
    iso6391: json["iso_639_1"],
    name: json["name"],
  );

  // Método para convertir un objeto `SpokenLanguage` a un mapa JSON.
  Map<String, dynamic> toJson() => {
    "english_name": englishName,
    "iso_639_1": iso6391,
    "name": name,
  };
}
