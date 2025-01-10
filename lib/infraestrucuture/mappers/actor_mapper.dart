
import 'package:cinemapedia/domain/entities/actor.dart'; 
import 'package:cinemapedia/infraestrucuture/moviedb/credits_response.dart';

// Esta clase tiene la responsabilidad de mapear los datos de la API a entidades de la aplicación.
class ActorMapper {
  
  // Método estático que convierte un objeto `Cast` (de la respuesta de la API) en una entidad `Actor` (de la aplicación).
  static Actor castToEntity( Cast cast ) =>
      Actor(
        id: cast.id, // El ID del actor.
        name: cast.name, // El nombre del actor.
        
        // El perfil del actor, si tiene una foto se construye la URL completa, si no tiene foto se usa una imagen predeterminada.
        profilePath: cast.profilePath != null
        ? 'https://image.tmdb.org/t/p/w500${ cast.profilePath }' // Si tiene foto, se construye la URL con el tamaño adecuado.
        : 'https://st3.depositphotos.com/4111759/13425/v/600/depositphotos_134255710-stock-illustration-avatar-vector-male-profile-gray.jpg', // Si no tiene foto, se usa una imagen predeterminada.

        character: cast.character, // El personaje que el actor interpreta en la película (puede ser nulo).
      );
}
