// Esta clase representa a un actor, con la información básica que se puede obtener de una API o base de datos.
class Actor {

  // ID único del actor.
  final int id;
  // Nombre del actor.
  final String name;
  // Ruta al perfil de imagen del actor.
  final String profilePath;
  // Personaje interpretado por el actor en una película. Este campo puede ser nulo si no se especifica.
  final String? character;

  // Constructor que inicializa los valores del actor.
  // Se requiere el ID, el nombre, la ruta del perfil y el personaje (que puede ser nulo).
  Actor({
    required this.id,
    required this.name,
    required this.profilePath,
    required this.character
  });
}
