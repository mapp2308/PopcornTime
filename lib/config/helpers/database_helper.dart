import 'package:path/path.dart';
import 'package:popcorntime/domain/entities/user.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

Future<Database> get database async {
  if (_database != null) return _database!;
  _database = await _initDatabase();
  return _database!;
}

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_db.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            apellido TEXT NOT NULL,
            contrasena TEXT NOT NULL,
            direccion TEXT NOT NULL,
            telefono TEXT NOT NULL,
            peliculasFavoritas TEXT DEFAULT '',
            peliculasPorVer TEXT DEFAULT '',
            isLogueado BOOLEAN DEFAULT false 
          )
        ''');
      },
    );
  }

  Future<int> registerUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> loginUser(String nombre, String contrasena) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'nombre = ? AND contrasena = ?',
      whereArgs: [nombre, contrasena],
    );
    return result.isNotEmpty ? User.fromMap(result.first) : null;
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<User?> getLoggedInUser() async {
  final db = await database; // Obtener instancia de la base de datos.
  final result = await db.query(
    'users',
    where: 'isLogueado = ?',
    whereArgs: [1],
  );

  if (result.isNotEmpty) {
    return User.fromMap(result.first); // Convertir el resultado en un objeto User.
  }
  return null; // Si no hay usuario logueado, regresar null.
}


}

extension UserExtensions on User {
  void addPeliculaFavorita(String pelicula) {
    peliculasFavoritas.add(pelicula);
  }

  void removePeliculaFavorita(String pelicula) {
    peliculasFavoritas.remove(pelicula);
  }

  void addPeliculaPorVer(String pelicula) {
    peliculasPorVer.add(pelicula);
  }

  void removePeliculaPorVer(String pelicula) {
    peliculasPorVer.remove(pelicula);
  }

}

