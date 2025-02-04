import 'package:flutter/material.dart';
import 'package:popcorntime/config/helpers/database_helper.dart';
import 'package:popcorntime/domain/entities/movie.dart';
import 'package:popcorntime/infraestrucuture/datasource/moviedb_datasource.dart';
import 'package:popcorntime/presentation/widgets/shared/custom_bottom_navigation.dart';
import 'movie_screen.dart';

class MoviesWatchlistPage extends StatefulWidget {
  const MoviesWatchlistPage({super.key});

  @override
  _MoviesWatchlistPageState createState() => _MoviesWatchlistPageState();
}

class _MoviesWatchlistPageState extends State<MoviesWatchlistPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final MoviedbDatasource _movieDatasource = MoviedbDatasource();
  List<Movie> _watchlistMovies = [];

  @override
  void initState() {
    super.initState();
    _loadWatchlistMovies();
  }

  Future<void> _loadWatchlistMovies() async {
    final user = await _dbHelper.getLoggedInUser();
    if (user != null && user.peliculasPorVer.isNotEmpty) {
      List<Movie> movies = await getMoviesByIds(user.peliculasPorVer);
      setState(() {
        _watchlistMovies = movies;
      });
    } else {
      setState(() {
        _watchlistMovies = [];
      });
    }
  }

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

  Future<void> _removeMovieFromWatchlist(String movieId) async {
    final user = await _dbHelper.getLoggedInUser();
    if (user != null) {
      user.peliculasPorVer.remove(movieId);
      await _dbHelper.updateUser(user);
      _loadWatchlistMovies();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Película eliminada de la lista por ver')),
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
      body: _watchlistMovies.isEmpty
          ? Center(
              child: Text('No hay películas en la lista por ver.',
                  style: textStyles.bodyLarge),
            )
          : ListView.builder(
              itemCount: _watchlistMovies.length,
              itemBuilder: (context, index) {
                final movie = _watchlistMovies[index];

                return Dismissible(
                  key: Key(movie.id.toString()),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    _removeMovieFromWatchlist(movie.id.toString());
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
                      _loadWatchlistMovies();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              movie.posterPath,
                              width: 100,
                              height: 150,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(movie.title,
                                    style: textStyles.titleMedium),
                                const SizedBox(height: 5),
                                Text(
                                  movie.overview.length > 100
                                      ? '${movie.overview.substring(0, 100)}...'
                                      : movie.overview,
                                  style: textStyles.bodyMedium,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(Icons.star_half_rounded,
                                        color: Colors.yellow.shade800),
                                    const SizedBox(width: 5),
                                    Text(
                                      movie.voteAverage.toString(),
                                      style: textStyles.bodyMedium!.copyWith(
                                          color: Colors.yellow.shade900),
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
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}
