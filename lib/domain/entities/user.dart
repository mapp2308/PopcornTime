class User {
  final int? id;
  final String nombre;
  final String apellido;
  final String contrasena;
  final String direccion;
  final String telefono;
  List<String> peliculasFavoritas;
  List<String> peliculasPorVer;
  bool isLogueado;

  User({
    this.id,
    required this.nombre,
    required this.apellido,
    required this.contrasena,
    required this.direccion,
    required this.telefono,
    this.isLogueado = false,
    List<String>? peliculasFavoritas,
    List<String>? peliculasPorVer,
  })  : peliculasFavoritas = peliculasFavoritas ?? [],
        peliculasPorVer = peliculasPorVer ?? [];

  // Convertir un User a un Map para la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'contrasena': contrasena,
      'direccion': direccion,
      'telefono': telefono,
      'peliculasFavoritas': peliculasFavoritas.join(','), // Convierte la lista en una cadena separada por comas
      'peliculasPorVer': peliculasPorVer.join(','), // Convierte la lista en una cadena separada por comas
      'isLogueado': isLogueado ? 1 : 0, // Almacena el valor booleano como entero (0 o 1)
    };
  }

  // Crear un User desde un Map de la base de datos
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      nombre: map['nombre'],
      apellido: map['apellido'],
      contrasena: map['contrasena'],
      direccion: map['direccion'],
      telefono: map['telefono'],
      isLogueado: map['isLogueado'] == 1, // Convierte 0/1 de la base de datos a un valor booleano
      peliculasFavoritas: map['peliculasFavoritas'] != null && map['peliculasFavoritas'].isNotEmpty
          ? map['peliculasFavoritas'].split(',') // Convierte la cadena separada por comas a una lista
          : [],
      peliculasPorVer: map['peliculasPorVer'] != null && map['peliculasPorVer'].isNotEmpty
          ? map['peliculasPorVer'].split(',') // Convierte la cadena separada por comas a una lista
          : [],
    );
  }
}
