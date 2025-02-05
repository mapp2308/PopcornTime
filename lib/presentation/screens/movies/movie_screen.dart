import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod para la gestión del estado
import 'package:animate_do/animate_do.dart'; // Librería para animaciones
import 'package:popcorntime/config/helpers/database_helper.dart'; // Base de datos local
import 'package:popcorntime/domain/entities/movie.dart'; // Entidad Movie
import 'package:popcorntime/presentation/providers/providers.dart'; // Proveedores de estado
import 'package:popcorntime/presentation/providers/movies/movie_info_provider.dart'; // Proveedor de información de películas

// Esta pantalla (`MovieScreen`) muestra los detalles de una película específica.
// - Obtiene la información de la película y el reparto usando `Riverpod`.
// - Permite agregar o eliminar películas de la lista de favoritos y de "por ver".
// - Usa `CustomScrollView` con `SliverAppBar` para una experiencia de navegación fluida.
// - Incluye `_MovieDetails` para mostrar información y `_ActorsByMovie` para mostrar el reparto.
// - `_CustomSliverAppBar` maneja la imagen de fondo con degradado para mejorar la visualización.

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';

  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  bool isFavorite = false;
  bool isWatchlist = false;
  final DatabaseHelper _dbHelper = DatabaseHelper(); // Instancia de base de datos

  @override
  void initState() {
    super.initState();
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId); // Carga la información de la película
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId); // Carga los actores de la película
    _checkMovieStatus(); // Verifica si la película está en favoritos o en la lista de por ver
  }

  /// Verifica si la película está en favoritos o en la lista de "por ver"
  Future<void> _checkMovieStatus() async {
    final user = await _dbHelper.getLoggedInUser();
    if (user != null) {
      setState(() {
        isFavorite = user.peliculasFavoritas.contains(widget.movieId);
        isWatchlist = user.peliculasPorVer.contains(widget.movieId);
      });
    }
  }

  /// Agrega o elimina la película de favoritos
  Future<void> toggleFavorite() async {
    final user = await _dbHelper.getLoggedInUser();
    if (user != null) {
      setState(() {
        if (isFavorite) {
          user.peliculasFavoritas.remove(widget.movieId);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Eliminado de favoritos')));
        } else {
          user.peliculasFavoritas.add(widget.movieId);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Añadido a favoritos')));
        }
        isFavorite = !isFavorite;
      });
      await _dbHelper.updateUser(user);
    }
  }

  /// Agrega o elimina la película de la lista de "por ver"
  Future<void> toggleWatchlist() async {
    final user = await _dbHelper.getLoggedInUser();
    if (user != null) {
      setState(() {
        if (isWatchlist) {
          user.peliculasPorVer.remove(widget.movieId);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Eliminado de por ver')));
        } else {
          user.peliculasPorVer.add(widget.movieId);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Añadido a por ver')));
        }
        isWatchlist = !isWatchlist;
      });
      await _dbHelper.updateUser(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    if (movie == null) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator(strokeWidth: 2))); // Muestra un indicador de carga si la película aún no se ha cargado
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie), // Barra superior con la imagen de la película
          SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => _MovieDetails(
                        movie: movie,
                        isFavorite: isFavorite,
                        isWatchlist: isWatchlist,
                        toggleFavorite: toggleFavorite,
                        toggleWatchlist: toggleWatchlist,
                      ),
                  childCount: 1))
        ],
      ),
    );
  }
}

// Widget que muestra los detalles de la película
class _MovieDetails extends StatelessWidget {
  final Movie movie;
  final bool isFavorite;
  final bool isWatchlist;
  final VoidCallback toggleFavorite;
  final VoidCallback toggleWatchlist;

  const _MovieDetails({
    required this.movie,
    required this.isFavorite,
    required this.isWatchlist,
    required this.toggleFavorite,
    required this.toggleWatchlist,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20), // Borde redondeado para la imagen de la película
                child: Image.network(movie.posterPath, width: size.width * 0.3),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: (size.width - 40) * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title, style: textStyles.titleLarge),
                    Text(
                      movie.overview.isNotEmpty ? movie.overview : 'La sinopsis todavía no está disponible',
                      style: textStyles.bodyMedium,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                          onPressed: toggleFavorite,
                        ),
                        IconButton(
                          icon: Icon(isWatchlist ? Icons.visibility : Icons.visibility_off, color: Colors.blue),
                          onPressed: toggleWatchlist,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _ActorsByMovie(movieId: movie.id.toString()), // Sección de actores
        const SizedBox(height: 50),
      ],
    );
  }
}

// Widget que muestra la lista de actores
class _ActorsByMovie extends ConsumerWidget {
  final String movieId;

  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, ref) {
    final actorsByMovie = ref.watch(actorsByMovieProvider);

    if (actorsByMovie[movieId] == null) {
      return const CircularProgressIndicator(strokeWidth: 2);
    }
    final actors = actorsByMovie[movieId]!;

    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final actor = actors[index];

          return Container(
            padding: const EdgeInsets.all(8.0),
            width: 135,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInRight(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(actor.profilePath, height: 180, width: 135, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 5),
                Text(actor.name, maxLines: 2),
                Text(actor.character ?? '', maxLines: 2, style: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)),
              ],
            ),
          );
        },
      ),
    );
  }
}


class _CustomSliverAppBar extends StatelessWidget {
  final Movie movie;

  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) return const SizedBox();
                  return FadeIn(child: child);
                },
              ),
            ),
            const SizedBox.expand(
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.7, 1.0],
                          colors: [Colors.transparent, Colors.black87]))),
            ),
            const SizedBox.expand(
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      gradient:
                          LinearGradient(begin: Alignment.topLeft, stops: [
                0.0,
                0.3
              ], colors: [
                Colors.black87,
                Colors.transparent,
              ]))),
            ),
          ],
        ),
      ),
    );
  }
}
