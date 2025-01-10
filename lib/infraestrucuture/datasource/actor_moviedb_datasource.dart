// Esta clase implementa la interfaz `ActorsDatasource` y se encarga de obtener los actores de una película desde la API de The Movie Database (TMDb).

import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasource/actors_datasource.dart'; 
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infraestrucuture/mappers/actor_mapper.dart';
import 'package:cinemapedia/infraestrucuture/moviedb/credits_response.dart';

import 'package:dio/dio.dart'; // Importa Dio, la librería para hacer peticiones HTTP.

class ActorMovieDbDatasource extends ActorsDatasource {

  //Instancia de Dio para hacer las peticiones HTTP a la API de TMDb.
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3', // URL base de la API de TMDb.
    queryParameters: {
      'api_key': Environment.theMovieDbKey, // API Key obtenida desde las variables de entorno.
      'language': 'es-MX' // Idioma de la respuesta (en este caso, español de México).
    }
  ));

  // Implementación del método `getActorsByMovie` que obtiene los actores de una película.
  // El parámetro `movieId` es el ID de la película que queremos consultar.
  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async{
    
    // Hacemos una petición GET a la API de TMDb para obtener los créditos de la película (actores y equipo).
    final response = await dio.get(
      '/movie/$movieId/credits' // La URL de la API que devuelve los créditos de la película.
    );

    // Convertimos la respuesta JSON de la API en un objeto `CreditsResponse`.
    final castResponse = CreditsResponse.fromJson(response.data);

    // Mapeamos la lista de actores obtenida desde la respuesta de la API a una lista de entidades `Actor`.
    List<Actor> actors = castResponse.cast.map(
      (cast) => ActorMapper.castToEntity(cast) // Usamos el `ActorMapper` para convertir los datos de la API en un objeto `Actor`.
    ).toList();
    
    // Devolvemos la lista de actores obtenidos.
    return actors;
  }

}
