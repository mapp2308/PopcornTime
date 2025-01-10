// Clase que gestiona las variables de entorno de la aplicación.
// Utiliza dotenv para cargar valores configurados en el archivo .env.

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {

  // Carga la clave de API de TMDB (The Movie Database) desde el archivo .env.
  // Si no se encuentra la clave, se asigna un valor por defecto.
  static String theMovieDbKey = dotenv.env['TMDB_API_KEY'] ?? 'No hay api key';

}
