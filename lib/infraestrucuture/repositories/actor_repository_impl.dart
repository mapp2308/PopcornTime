import 'package:cinemapedia/domain/datasource/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/repositories/actors_repository.dart';

class ActorRepositoryImpl extends ActorsRepository {

  final ActorsDatasource datasource; // Fuente de datos (API o base de datos) para obtener los actores.

  // Constructor que inicializa el datasource
  ActorRepositoryImpl(this.datasource);

  // Implementación del método para obtener los actores de una película por su ID
  @override
  Future<List<Actor>> getActorsByMovie(String movieId){
    return datasource.getActorsByMovie(movieId); // Llama al datasource para obtener los actores.
  }
}
