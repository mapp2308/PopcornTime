// Esta es una clase abstracta que define la interfaz para la obtención de datos de actores.
// El propósito de esta clase es ser implementada por una clase que se encargue de obtener actores desde una fuente de datos, como una API o base de datos.

import 'package:cinemapedia/domain/entities/actor.dart';

abstract class ActorsDatasource {

  // Método abstracto para obtener una lista de actores basada en el ID de una película.
  // Este método debe ser implementado por una clase que recupere actores desde alguna fuente de datos.
  // Devuelve una lista de actores o lanza un error en caso de no poder obtener los datos.
  Future<List<Actor>> getActorsByMovie(String movieId);
}
