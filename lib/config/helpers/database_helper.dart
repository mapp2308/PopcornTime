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
    String path = join(await getDatabasesPath(), 'app_bd.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            apellido TEXT NOT NULL,
            username TEXT NOT NULL,
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

  Future<User?> loginUser(String username, String contrasena) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND contrasena = ?',
      whereArgs: [username, contrasena],
    );

    if (result.isNotEmpty) {
      // Marcar el usuario como logueado
      User user = User.fromMap(result.first);
      await _setUserLoggedInState(user.id!, true);
      return user;
    }

    return null;
  }

  Future<bool> isUsernameTaken(String username) async {
    final db = await database;
    final result = await db.query(
      'users', // Nombre de la tabla
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty;
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
    final db = await database;
    final result = await db.query(
      'users',
      where: 'isLogueado = ?',
      whereArgs: [1],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  Future<void> logoutUser(int id) async {
    await _setUserLoggedInState(id, false);
  }

  Future<void> _setUserLoggedInState(int id, bool isLoggedIn) async {
    final db = await database;
    await db.update(
      'users',
      {'isLogueado': isLoggedIn ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
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
