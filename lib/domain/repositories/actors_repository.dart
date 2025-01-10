// Esta es una clase abstracta que define la interfaz del repositorio de actores.
// El propósito de esta clase es ser implementada por una clase que se encargue de acceder a los datos de los actores, ya sea desde una API, base de datos u otra fuente.

import 'package:cinemapedia/domain/entities/actor.dart';

abstract class ActorsRepository {

  // Método para obtener una lista de actores basados en el ID de una película.
  // Este método debe ser implementado por una clase que recupere actores desde alguna fuente de datos.
  // Devuelve una lista de actores.
  Future<List<Actor>> getActorsByMovie(String movieId);
}
