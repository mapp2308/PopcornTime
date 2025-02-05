import 'package:flutter/material.dart';
import 'package:popcorntime/config/helpers/database_helper.dart'; // Helper para interactuar con la base de datos local
import 'package:popcorntime/domain/entities/movie.dart'; // Entidad Movie
import 'package:popcorntime/infraestrucuture/datasource/moviedb_datasource.dart'; // Fuente de datos para obtener información de películas desde la API
import 'package:popcorntime/presentation/screens/screens.dart'; // Pantallas de la aplicación
import 'package:popcorntime/presentation/widgets/widgets.dart'; // Widgets reutilizables como Drawer y Bottom Navigation

// Esta pantalla (`MoviesFavoritesPage`) muestra una lista de películas favoritas guardadas por el usuario.
// - Obtiene la lista de películas favoritas desde la base de datos SQLite.
// - Utiliza `FutureBuilder` para obtener detalles de las películas desde la API de MovieDB.
// - Permite eliminar películas de favoritos mediante `Dismissible`.
// - Usa `Navigator.push` para ver los detalles de una película en `MovieScreen`.

class MoviesFavoritesPage extends StatefulWidget {
  const MoviesFavoritesPage({super.key});

  @override
  _MoviesFavoritesPageState createState() => _MoviesFavoritesPageState();
}

class _MoviesFavoritesPageState extends State<MoviesFavoritesPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper(); // Instancia para acceder a la base de datos
  final MoviedbDatasource _movieDatasource = MoviedbDatasource(); // Instancia para obtener datos de la API
  List<Movie> _favoriteMovies = []; // Lista de películas favoritas del usuario

  @override
  void initState() {
    super.initState();
    _loadFavoriteMovies(); // Cargar las películas favoritas al iniciar la pantalla
  }

  /// Carga la lista de películas favoritas desde la base de datos local
  Future<void> _loadFavoriteMovies() async {
    final user = await _dbHelper.getLoggedInUser(); // Obtiene el usuario logueado
    if (user != null && user.peliculasFavoritas.isNotEmpty) {
      List<Movie> movies = await getMoviesByIds(user.peliculasFavoritas); // Obtiene las películas por ID desde la API
      setState(() {
        _favoriteMovies = movies; // Actualiza la lista de películas en el estado
      });
    } else {
      setState(() {
        _favoriteMovies = []; // Si no hay películas favoritas, se asigna una lista vacía
      });
    }
  }

  /// Obtiene detalles de las películas por sus IDs desde la API
  Future<List<Movie>> getMoviesByIds(List<String> movieIds) async {
    List<Movie> movies = [];
    for (String id in movieIds) {
      final movie = await _movieDatasource.getMovieById(id);
      if (movie != null) {
        movies.add(movie);
      }
    }
    return movies;
  }

  /// Elimina una película de la lista de favoritos
  Future<void> _removeMovieFromFavorites(String movieId) async {
    final user = await _dbHelper.getLoggedInUser();
    if (user != null) {
      user.peliculasFavoritas.remove(movieId); // Elimina la película de la lista de favoritos del usuario
      await _dbHelper.updateUser(user); // Actualiza la base de datos
      _loadFavoriteMovies(); // Recarga la lista de favoritos
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Película eliminada de favoritos')), // Muestra un mensaje de confirmación
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Películas favoritas', style: textStyles.titleLarge),
        centerTitle: true,
      ),
      drawer: AppDrawer(), // Menú lateral
      body: _favoriteMovies.isEmpty
          ? Center(
              child: Text('No hay películas en la lista de favoritos.', style: textStyles.bodyLarge),
            )
          : ListView.builder(
              itemCount: _favoriteMovies.length,
              itemBuilder: (context, index) {
                final movie = _favoriteMovies[index];

                return Dismissible(
                  key: Key(movie.id.toString()), // Clave única para cada elemento
                  background: Container(
                    color: Colors.red, // Fondo rojo al deslizar
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white), // Ícono de eliminar
                  ),
                  direction: DismissDirection.endToStart, // Deslizar de derecha a izquierda
                  onDismissed: (direction) {
                    _removeMovieFromFavorites(movie.id.toString()); // Elimina la película de favoritos al deslizar
                  },
                  child: GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MovieScreen(
                            movieId: movie.id.toString(),
                          ),
                        ),
                      );
                      _loadFavoriteMovies(); // Recarga la lista de favoritos después de ver una película
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(
                        children: [
                          // Imagen de la película
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10), // Borde redondeado para la imagen
                            child: Image.network(
                              movie.posterPath, // URL del póster de la película
                              width: 100,
                              height: 150,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error), // Ícono de error si no carga la imagen
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Descripción de la película
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(movie.title, style: textStyles.titleMedium), // Título de la película
                                const SizedBox(height: 5),
                                Text(
                                  movie.overview.length > 100
                                      ? '${movie.overview.substring(0, 100)}...' // Descripción truncada a 100 caracteres
                                      : movie.overview,
                                  style: textStyles.bodyMedium,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(Icons.star_half_rounded, color: Colors.yellow.shade800), // Ícono de calificación
                                    const SizedBox(width: 5),
                                    Text(
                                      movie.voteAverage.toString(), // Calificación de la película
                                      style: textStyles.bodyMedium!.copyWith(color: Colors.yellow.shade900),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: const CustomBottomNavigation(), // Barra de navegación inferior
    );
  }
}
