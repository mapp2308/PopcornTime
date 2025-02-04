class User {
  final int? id;
  final String nombre;
  final String apellido;
  final String username;
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
    required this.username,
    required this.contrasena,
    required this.direccion,
    required this.telefono,
    this.isLogueado = false,
    List<String>? peliculasFavoritas,
    List<String>? peliculasPorVer,
  })  : peliculasFavoritas = peliculasFavoritas ?? [],
        peliculasPorVer = peliculasPorVer ?? [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'username': username,
      'contrasena': contrasena,
      'direccion': direccion,
      'telefono': telefono,
      'peliculasFavoritas': peliculasFavoritas.join(','),
      'peliculasPorVer': peliculasPorVer.join(','),
      'isLogueado': isLogueado ? 1 : 0,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      nombre: map['nombre'],
      apellido: map['apellido'],
      username: map['username'],
      contrasena: map['contrasena'],
      direccion: map['direccion'],
      telefono: map['telefono'],
      isLogueado: map['isLogueado'] == 1,
      peliculasFavoritas: map['peliculasFavoritas'] != null &&
              map['peliculasFavoritas'].isNotEmpty
          ? map['peliculasFavoritas'].split(',')
          : [],
      peliculasPorVer:
          map['peliculasPorVer'] != null && map['peliculasPorVer'].isNotEmpty
              ? map['peliculasPorVer'].split(',')
              : [],
    );
  }
}
