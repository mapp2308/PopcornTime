import 'package:path/path.dart'; // Permite gestionar rutas de archivos para la base de datos
import 'package:popcorntime/domain/entities/user.dart'; // Importa la entidad User
import 'package:sqflite/sqflite.dart'; // Manejo de bases de datos SQLite en Flutter

// Esta clase maneja la base de datos SQLite para la aplicación. 
// Se encarga de la creación de la base de datos, la gestión de usuarios y sus estados de sesión.
// Incluye funciones para registrar, iniciar sesión, verificar existencia de usuario, actualizar y eliminar datos.

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal(); // Implementación de Singleton
  factory DatabaseHelper() => _instance; // Permite acceder a la única instancia de DatabaseHelper

  DatabaseHelper._internal(); // Constructor privado para el Singleton

  static Database? _database; // Instancia de la base de datos

  // Getter para obtener la base de datos, inicializándola si es necesario
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicialización de la base de datos
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_bd.db'); // Obtiene la ruta de la base de datos
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Creación de la tabla de usuarios con los campos necesarios
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

  // Registra un usuario en la base de datos
  Future<int> registerUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  // Autenticación de usuario
  Future<User?> loginUser(String username, String contrasena) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND contrasena = ?',
      whereArgs: [username, contrasena],
    );

    if (result.isNotEmpty) {
      // Si el usuario existe, se marca como logueado
      User user = User.fromMap(result.first);
      await _setUserLoggedInState(user.id!, true);
      return user;
    }
    return null;
  }

  // Verifica si un nombre de usuario ya está registrado
  Future<bool> isUsernameTaken(String username) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty; // Devuelve true si el usuario ya existe
  }

  // Actualiza la información de un usuario en la base de datos
  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Elimina un usuario por ID
  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Obtiene el usuario actualmente logueado
  Future<User?> getLoggedInUser() async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'isLogueado = ?',
      whereArgs: [1], // Busca usuarios con el campo isLogueado en true (1)
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  // Cierra la sesión de un usuario
  Future<void> logoutUser(int id) async {
    await _setUserLoggedInState(id, false);
  }

  // Cambia el estado de logueo de un usuario
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

// Extensión para manejar listas de películas favoritas y por ver en la clase User
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
