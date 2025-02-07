import 'package:flutter/material.dart';
import 'package:popcorntime/config/helpers/database_helper.dart'; // Base de datos local
import 'package:popcorntime/domain/entities/movie.dart'; // Entidad Movie
import 'package:popcorntime/infraestrucuture/datasource/moviedb_datasource.dart'; // Fuente de datos para obtener información de películas desde la API
import 'package:popcorntime/presentation/screens/screens.dart'; // Pantallas de la aplicación
import 'package:popcorntime/presentation/widgets/widgets.dart'; // Widgets reutilizables como Drawer y Bottom Navigation

// Esta pantalla (`MoviesWatchlistPage`) muestra la lista de películas que el usuario ha guardado como "Por ver".
// - Obtiene la lista de películas guardadas desde la base de datos SQLite.
// - Usa `FutureBuilder` para obtener detalles de las películas desde la API de MovieDB.
// - Permite eliminar películas de la lista deslizando hacia la izquierda (`Dismissible`).
// - Usa `Navigator.push` para ver los detalles de una película en `MovieScreen`.

class MoviesWatchlistPage extends StatefulWidget {
  const MoviesWatchlistPage({super.key});

  @override
  _MoviesWatchlistPageState createState() => _MoviesWatchlistPageState();
}

class _MoviesWatchlistPageState extends State<MoviesWatchlistPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper(); // Instancia para acceder a la base de datos
  final MoviedbDatasource _movieDatasource = MoviedbDatasource(); // Instancia para obtener datos de la API
  List<Movie> _watchlistMovies = []; // Lista de películas por ver

  @override
  void initState() {
    super.initState();
    _loadWatchlistMovies(); // Cargar las películas por ver al iniciar la pantalla
  }

  /// Carga la lista de películas por ver desde la base de datos local
  Future<void> _loadWatchlistMovies() async {
    final user = await _dbHelper.getLoggedInUser(); // Obtiene el usuario logueado
    if (user != null && user.peliculasPorVer.isNotEmpty) {
      List<Movie> movies = await getMoviesByIds(user.peliculasPorVer); // Obtiene las películas por ID desde la API
      setState(() {
        _watchlistMovies = movies; // Actualiza la lista de películas en el estado
      });
    } else {
      setState(() {
        _watchlistMovies = []; // Si no hay películas por ver, se asigna una lista vacía
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

  /// Elimina una película de la lista de "por ver"
  Future<void> _removeMovieFromWatchlist(String movieId) async {
    final user = await _dbHelper.getLoggedInUser();
    if (user != null) {
      user.peliculasPorVer.remove(movieId); // Elimina la película de la lista de "por ver" del usuario
      await _dbHelper.updateUser(user); // Actualiza la base de datos
      _loadWatchlistMovies(); // Recarga la lista de películas por ver
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Película eliminada de la lista por ver')), // Muestra un mensaje de confirmación
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Películas por ver', style: textStyles.titleLarge),
        centerTitle: true,
      ),
      drawer: AppDrawer(), // Menú lateral
      body: _watchlistMovies.isEmpty
          ? Center(
              child: Text('No hay películas en la lista por ver.', style: textStyles.bodyLarge),
            )
          : ListView.builder(
              itemCount: _watchlistMovies.length,
              itemBuilder: (context, index) {
                final movie = _watchlistMovies[index];

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
                    _removeMovieFromWatchlist(movie.id.toString()); // Elimina la película de la lista por ver al deslizar
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
                      _loadWatchlistMovies(); // Recarga la lista de películas por ver después de ver los detalles
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10), // Redondea las esquinas de la imagen
                            child: Image.network(
                              movie.posterPath, // URL del póster de la película
                              width: 100,
                              height: 150,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error), // Ícono de error si no carga la imagen
                            ),
                          ),
                          const SizedBox(width: 10),
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
