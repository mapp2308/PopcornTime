import 'package:flutter/material.dart';
import 'package:popcorntime/domain/entities/movie.dart';
import 'package:popcorntime/infraestrucuture/datasource/moviedb_datasource.dart';
import 'package:popcorntime/presentation/screens/screens.dart';
import 'package:popcorntime/presentation/widgets/drawer.dart';
import 'package:popcorntime/presentation/widgets/shared/custom_bottom_navigation.dart';

class GenersScreen extends StatelessWidget {
  final MoviedbDatasource moviesDatasource = MoviedbDatasource();

  GenersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Géneros', style: textStyles.titleLarge),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: moviesDatasource.getGenres(), // Obtener los géneros desde el datasource
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No hay géneros disponibles.', style: textStyles.bodyLarge),
            );
          }

          final categories = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MoviesByCategoryPage(
                          categoryId: category['id'] as int,
                          categoryName: category['name'] as String,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.blueGrey.shade800,
                    ),
                    child: Center(
                      child: Text(
                        category['name'] as String,
                        style: textStyles.titleMedium!.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      drawer: AppDrawer(),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}

class MoviesByCategoryPage extends StatelessWidget {
  final int categoryId;
  final String categoryName;
  final MoviedbDatasource moviesDatasource = MoviedbDatasource();

  MoviesByCategoryPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Películas de $categoryName', style: textStyles.titleLarge),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Movie>>(
        future: moviesDatasource.getMoviesByCategory(categoryId: categoryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No hay películas disponibles en este género.', style: textStyles.bodyLarge),
            );
          }

          final movies = snapshot.data!;

          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];

              return GestureDetector(
                onTap: () {
                  // Navega a la página de detalles de la película
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MovieScreen(
                        movieId: movie.id.toString(), // Pasa el movieId como String
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      SizedBox(
                        width: size.width * 0.2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            movie.posterPath,
                            loadingBuilder: (context, child, loadingProgress) =>
                                child,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: size.width * 0.7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(movie.title, style: textStyles.titleMedium),
                            Text(
                              movie.overview.length > 100
                                  ? '${movie.overview.substring(0, 100)}...'
                                  : movie.overview,
                            ),
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
              );
            },
          );
        },
      ),
    );
  }
}
