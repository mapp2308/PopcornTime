
class User {
  final int? id;
  final String nombre;
  final String apellido;
  final String contrasena;
  final String direccion;
  final String telefono;
  List<String> peliculasFavoritas;
  List<String> peliculasPorVer;

  User({
    this.id,
    required this.nombre,
    required this.apellido,
    required this.contrasena,
    required this.direccion,
    required this.telefono,
    List<String>? peliculasFavoritas,
    List<String>? peliculasPorVer,
  })  : peliculasFavoritas = peliculasFavoritas ?? [],
        peliculasPorVer = peliculasPorVer ?? [];

  // Convertir un User a un Map para la base de datos
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'contrasena': contrasena,
      'direccion': direccion,
      'telefono': telefono,
      'peliculasFavoritas': peliculasFavoritas.join(','),
      'peliculasPorVer': peliculasPorVer.join(','),
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
      peliculasFavoritas: map['peliculasFavoritas'].isNotEmpty ? map['peliculasFavoritas'].split(',') : [],
      peliculasPorVer: map['peliculasPorVer'].isNotEmpty ? map['peliculasPorVer'].split(',') : [],
    );
  }
}
