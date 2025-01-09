import 'package:flutter_dotenv/flutter_dotenv.dart';


class Environment {

  static String theMovieDbKey = dotenv.env['TMDB_API_KEY'] ?? 'No hay api key';


}