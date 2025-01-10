// Define la clase `CreditsResponse` que contiene información sobre los actores y el equipo de una película.
class CreditsResponse {

  // Constructor de la clase, que inicializa el id, la lista de actores (cast) y el equipo de producción (crew).
  CreditsResponse({
    required this.id,
    required this.cast,
    required this.crew,
  });

  final int id; // ID de la película.
  final List<Cast> cast; // Lista de actores (cast).
  final List<Cast> crew; // Lista de miembros del equipo (crew).

  // Método de fábrica que crea un objeto `CreditsResponse` a partir de un mapa JSON.
  factory CreditsResponse.fromJson(Map<String, dynamic> json) => CreditsResponse(
    id: json["id"], // Extrae el ID de la película.
    cast: List<Cast>.from(json["cast"].map((x) => Cast.fromJson(x))), // Mapea la lista de actores desde JSON.
    crew: List<Cast>.from(json["crew"].map((x) => Cast.fromJson(x))), // Mapea la lista de equipo desde JSON.
  );

  // Método para convertir un objeto `CreditsResponse` a un mapa JSON.
  Map<String, dynamic> toJson() => {
    "id": id, // Incluye el ID de la película.
    "cast": List<dynamic>.from(cast.map((x) => x.toJson())), // Convierte la lista de actores a JSON.
    "crew": List<dynamic>.from(crew.map((x) => x.toJson())), // Convierte la lista de equipo a JSON.
  };
}

// Define la clase `Cast` que representa a un actor o miembro del equipo.
class Cast {

  // Constructor de la clase, que inicializa los atributos del actor o miembro del equipo.
  Cast({
    required this.adult,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    this.profilePath,
    this.castId,
    this.character,
    required this.creditId,
    this.order,
    this.department,
    this.job,
  });

  final bool adult; // Si es una película para adultos.
  final int gender; // Género del actor (0: mujer, 1: hombre).
  final int id; // ID del actor o miembro del equipo.
  final String knownForDepartment; // Departamento en el que es conocido (actores, directores, etc.).
  final String name; // Nombre del actor o miembro del equipo.
  final String originalName; // Nombre original del actor o miembro del equipo.
  final double popularity; // Popularidad del actor o miembro del equipo.
  final String? profilePath; // Ruta al perfil del actor o miembro del equipo (si existe).
  final int? castId; // ID del actor en el elenco (si está presente).
  final String? character; // El personaje interpretado por el actor (si aplica).
  final String creditId; // ID de crédito único.
  final int? order; // El orden del actor o miembro del equipo en la lista (si aplica).
  final String? department; // El departamento del equipo (si aplica).
  final String? job; // El trabajo del miembro del equipo (si aplica).

  // Método de fábrica que crea un objeto `Cast` a partir de un mapa JSON.
  factory Cast.fromJson(Map<String, dynamic> json) => Cast(
    adult: json["adult"], // Si la película es para adultos.
    gender: json["gender"], // Género del actor (0 o 1).
    id: json["id"], // ID único del actor.
    knownForDepartment: json["known_for_department"]!, // Departamento en el que es conocido.
    name: json["name"], // Nombre del actor o miembro del equipo.
    originalName: json["original_name"], // Nombre original del actor o miembro del equipo.
    popularity: json["popularity"]?.toDouble(), // Popularidad, lo convertimos a double.
    profilePath: json["profile_path"], // Ruta al perfil (si existe).
    castId: json["cast_id"], // ID de cast (si existe).
    character: json["character"], // El personaje interpretado (si existe).
    creditId: json["credit_id"], // ID de crédito.
    order: json["order"], // El orden en la lista (si existe).
    department: json["department"], // Departamento (si existe).
    job: json["job"], // El trabajo realizado (si existe).
  );

  // Método para convertir un objeto `Cast` a un mapa JSON.
  Map<String, dynamic> toJson() => {
    "adult": adult, // Incluye si es para adultos.
    "gender": gender, // Incluye el género del actor (0 o 1).
    "id": id, // ID del actor.
    "known_for_department": knownForDepartment, // El departamento en el que es conocido.
    "name": name, // Nombre del actor.
    "original_name": originalName, // Nombre original.
    "popularity": popularity, // Popularidad del actor.
    "profile_path": profilePath, // Ruta del perfil.
    "cast_id": castId, // ID de cast.
    "character": character, // Personaje interpretado.
    "credit_id": creditId, // ID de crédito.
    "order": order, // Orden del actor en la lista.
    "department": department, // Departamento (si existe).
    "job": job, // El trabajo realizado (si existe).
  };
}
