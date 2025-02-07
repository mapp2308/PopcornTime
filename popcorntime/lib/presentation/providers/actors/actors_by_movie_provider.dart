import 'package:popcorntime/domain/entities/actor.dart'; // Importa la entidad Actor
import 'package:popcorntime/presentation/providers/actors/actors_repository_provier.dart'; // Importa el proveedor del repositorio de actores
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Importa Riverpod para la gestión del estado

// Este código maneja la obtención y almacenamiento de los actores asociados a una película usando Riverpod.
// Utiliza `StateNotifier` para gestionar el estado de los actores por película.
// `actorsByMovieProvider` se encarga de proveer los datos y `ActorsByMovieNotifier` los gestiona.
// Se utiliza `Map<String, List<Actor>>` para almacenar actores indexados por el ID de la película.

final actorsByMovieProvider = StateNotifierProvider<ActorsByMovieNotifier, Map<String, List<Actor>>>((ref) {
  final actorsRepository = ref.watch(actorsRepositoryProvider); // Obtiene la instancia del repositorio de actores
  
  return ActorsByMovieNotifier(getActors: actorsRepository.getActorsByMovie); // Retorna una instancia del Notifier con el callback de obtención de actores
});

/*
  Ejemplo de cómo se almacenan los datos en el estado:
  {
    '505642': <Actor>[],  // Lista de actores para la película con ID 505642
    '505643': <Actor>[],  // Lista de actores para la película con ID 505643
    '505645': <Actor>[],  // Lista de actores para la película con ID 505645
    '501231': <Actor>[],  // Lista de actores para la película con ID 501231
  }
*/

// Tipo de función que obtiene actores basado en el ID de una película
typedef GetActorsCallback = Future<List<Actor>> Function(String movieId);

// Notifier encargado de manejar el estado de los actores por película
class ActorsByMovieNotifier extends StateNotifier<Map<String, List<Actor>>> {

  final GetActorsCallback getActors; // Callback para obtener los actores desde el repositorio

  ActorsByMovieNotifier({
    required this.getActors,
  }) : super({}); // Estado inicial vacío

  // Carga los actores de una película si aún no han sido cargados
  Future<void> loadActors(String movieId) async {
    if (state[movieId] != null) return; // Si los actores ya están cargados, no se vuelve a hacer la petición

    final List<Actor> actors = await getActors(movieId); // Obtiene la lista de actores desde el repositorio
    state = {...state, movieId: actors}; // Actualiza el estado agregando los nuevos actores sin perder los anteriores
  }
}
