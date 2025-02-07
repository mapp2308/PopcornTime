// Esta clase representa la entidad `User`, que modela un usuario dentro de la aplicación.
// Contiene atributos básicos como nombre, apellido, nombre de usuario, contraseña, dirección y teléfono.
// Además, incluye listas de películas favoritas y por ver, y un indicador de sesión iniciada (`isLogueado`).
// La clase proporciona métodos para convertir instancias de `User` en mapas (`toMap`) y para crear 
// instancias de `User` desde mapas (`fromMap`), facilitando la integración con SQLite.

class User {
  final int? id; // Identificador único del usuario en la base de datos (puede ser null si aún no ha sido guardado)
  final String nombre; // Nombre del usuario
  final String apellido; // Apellido del usuario
  final String username; // Nombre de usuario (único)
  final String contrasena; // Contraseña del usuario (debe ser almacenada de manera segura)
  final String direccion; // Dirección del usuario
  final String telefono; // Número de teléfono del usuario
  List<String> peliculasFavoritas; // Lista de películas favoritas del usuario
  List<String> peliculasPorVer; // Lista de películas que el usuario quiere ver
  bool isLogueado; // Estado que indica si el usuario ha iniciado sesión

  // Constructor de la clase User
  User({
    this.id,
    required this.nombre,
    required this.apellido,
    required this.username,
    required this.contrasena,
    required this.direccion,
    required this.telefono,
    this.isLogueado = false,
    List<String>? peliculasFavoritas,
    List<String>? peliculasPorVer,
  })  : peliculasFavoritas = peliculasFavoritas ?? [], // Si no se proporciona una lista de películas favoritas, se inicializa como una lista vacía
        peliculasPorVer = peliculasPorVer ?? []; // Si no se proporciona una lista de películas por ver, se inicializa como una lista vacía

  // Convierte la instancia de `User` en un `Map<String, dynamic>` para almacenarlo en la base de datos SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Se mantiene el ID si existe
      'nombre': nombre,
      'apellido': apellido,
      'username': username,
      'contrasena': contrasena,
      'direccion': direccion,
      'telefono': telefono,
      'peliculasFavoritas': peliculasFavoritas.join(','), // Convierte la lista en un String separado por comas para almacenarlo en la base de datos
      'peliculasPorVer': peliculasPorVer.join(','), // Convierte la lista en un String separado por comas
      'isLogueado': isLogueado ? 1 : 0, // Se guarda como `1` si está logueado, `0` si no lo está
    };
  }

  // Constructor de fábrica que crea una instancia de `User` a partir de un `Map<String, dynamic>`, útil para obtener datos de la base de datos
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'], // Obtiene el ID desde el mapa
      nombre: map['nombre'],
      apellido: map['apellido'],
      username: map['username'],
      contrasena: map['contrasena'],
      direccion: map['direccion'],
      telefono: map['telefono'],
      isLogueado: map['isLogueado'] == 1, // Convierte `1` en `true` y `0` en `false`
      peliculasFavoritas: map['peliculasFavoritas'] != null &&
              map['peliculasFavoritas'].isNotEmpty
          ? map['peliculasFavoritas'].split(',') // Convierte el String separado por comas en una lista de Strings
          : [],
      peliculasPorVer:
          map['peliculasPorVer'] != null && map['peliculasPorVer'].isNotEmpty
              ? map['peliculasPorVer'].split(',') // Convierte el String separado por comas en una lista de Strings
              : [],
    );
  }
}
